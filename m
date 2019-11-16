Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA9BFF2D1
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbfKPQVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbfKPPnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:31 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A5372082E;
        Sat, 16 Nov 2019 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919010;
        bh=kvrgsIZ8Gymbi6c4WYY9shIxHq3UQvTGVVPm6yj3KAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFR+Gcfon30PiINYsSwpeLOzQbG21u3OMBhJDEUijVfpQ2OYhqtR1nYiDzM11JZei
         CDwbF+IUIWaeopifCJdO4KX6gBlvCXBDYGXIgwnLUqFJVcxaXCQ5Ih2OjjIKMBhTqg
         A7BQPGzIa+SRcmscVPG/qxXOtVRgNuCAzGY10JTA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Garry McNulty <garrmcnu@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 114/237] fs/cifs: fix uninitialised variable warnings
Date:   Sat, 16 Nov 2019 10:39:09 -0500
Message-Id: <20191116154113.7417-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Garry McNulty <garrmcnu@gmail.com>

[ Upstream commit ef2298a06d012973bbc592b86fe5ff730d4d0c63 ]

In some error conditions, resp_buftype can be passed uninitialised to
free_rsp_buf(), potentially resulting in a spurious debug message.
If resp_buftype randomly had the value 1 (CIFS_SMALL_BUFFER) then this
would log a debug message.
The rsp pointer is initialised to NULL so there is no other side-effect.

Detected by CoverityScan, CID 1438585 ("Uninitialized scalar variable")
Detected by CoverityScan, CID 1438667 ("Uninitialized scalar variable")
Detected by CoverityScan, CID 1438764 ("Uninitialized scalar variable")

Signed-off-by: Garry McNulty <garrmcnu@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b1f5d0d28335a..9194f17675c89 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2283,7 +2283,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[SMB2_CREATE_IOV_SIZE];
 	struct kvec rsp_iov = {NULL, 0};
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
 
@@ -2570,7 +2570,7 @@ SMB2_close_flags(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 
 	cifs_dbg(FYI, "Close\n");
@@ -2723,7 +2723,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	int rc = 0;
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
 
-- 
2.20.1

