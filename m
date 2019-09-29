Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE09C1593
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbfI2OBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbfI2OBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:01:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61BEB2082F;
        Sun, 29 Sep 2019 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765674;
        bh=QCc1+IZSJhTqcE8sJ998hMa8hSC03JMq+jgOzg9VnPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdlqAz2M9TthDRiuCeP6+Q8TFgrEm4q6B2lKtKwwVu8z4AuXp16Z/0qyyC3i05CEE
         OsTnH5zg5Qye893nKBrPHhzrBkZ+wtgweoExXvCFDdZFSo2em6IdPfztsAJL2luXXS
         abXeDVd3GegxW1k+FcK7KgBBXWYW0xJzHVTPrOPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 02/45] smb3: fix unmount hang in open_shroot
Date:   Sun, 29 Sep 2019 15:55:30 +0200
Message-Id: <20190929135025.151404151@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 96d9f7ed00b86104bf03adeffc8980897e9694ab ]

An earlier patch "CIFS: fix deadlock in cached root handling"
did not completely address the deadlock in open_shroot. This
patch addresses the deadlock.

In testing the recent patch:
  smb3: improve handling of share deleted (and share recreated)
we were able to reproduce the open_shroot deadlock to one
of the target servers in unmount in a delete share scenario.

Fixes: 7e5a70ad88b1e ("CIFS: fix deadlock in cached root handling")

This is version 2 of this patch. An earlier version of this
patch "smb3: fix unmount hang in open_shroot" had a problem
found by Dan.

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Aurelien Aptel <aaptel@suse.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 42de31d206169..8ae8ef526b4a5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -656,6 +656,15 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 		return 0;
 	}
 
+	/*
+	 * We do not hold the lock for the open because in case
+	 * SMB2_open needs to reconnect, it will end up calling
+	 * cifs_mark_open_files_invalid() which takes the lock again
+	 * thus causing a deadlock
+	 */
+
+	mutex_unlock(&tcon->crfid.fid_mutex);
+
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
@@ -677,7 +686,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 
 	rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, &utf16_path);
 	if (rc)
-		goto oshr_exit;
+		goto oshr_free;
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));
@@ -690,18 +699,10 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 				  sizeof(struct smb2_file_all_info) +
 				  PATH_MAX * 2, 0, NULL);
 	if (rc)
-		goto oshr_exit;
+		goto oshr_free;
 
 	smb2_set_related(&rqst[1]);
 
-	/*
-	 * We do not hold the lock for the open because in case
-	 * SMB2_open needs to reconnect, it will end up calling
-	 * cifs_mark_open_files_invalid() which takes the lock again
-	 * thus causing a deadlock
-	 */
-
-	mutex_unlock(&tcon->crfid.fid_mutex);
 	rc = compound_send_recv(xid, ses, flags, 2, rqst,
 				resp_buftype, rsp_iov);
 	mutex_lock(&tcon->crfid.fid_mutex);
-- 
2.20.1



