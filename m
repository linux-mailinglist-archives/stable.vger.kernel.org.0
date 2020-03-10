Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B3717FBD8
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbgCJNMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731571AbgCJNMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:12:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3404E20409;
        Tue, 10 Mar 2020 13:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845951;
        bh=7nXynGN6VHUPilVfphJiuQpXrogLlV8v9Dm6yFB5kug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVF2jmay09Sglh5/MWpPEq1FfzYXgpeYbF2x8Bxw4SHpO64nK+t5v6WGKHYqzq2ay
         VGIlwUn6yx7j2D3y71D/X6TsiWyyWJlK/u205rysJThgXxH9+xDTgDswiJt9m+ALLf
         BlaypDitVMjxyEUFkTz+uHqRYqLiVFNKnMaRH/1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 4.19 34/86] cifs: dont leak -EAGAIN for stat() during reconnect
Date:   Tue, 10 Mar 2020 13:44:58 +0100
Message-Id: <20200310124532.618767487@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit fc513fac56e1b626ae48a74d7551d9c35c50129e upstream.

If from cifs_revalidate_dentry_attr() the SMB2/QUERY_INFO call fails with an
error, such as STATUS_SESSION_EXPIRED, causing the session to be reconnected
it is possible we will leak -EAGAIN back to the application even for
system calls such as stat() where this is not a valid error.

Fix this by re-trying the operation from within cifs_revalidate_dentry_attr()
if cifs_get_inode_info*() returns -EAGAIN.

This fixes stat() and possibly also other system calls that uses
cifs_revalidate_dentry*().

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2003,6 +2003,7 @@ int cifs_revalidate_dentry_attr(struct d
 	struct inode *inode = d_inode(dentry);
 	struct super_block *sb = dentry->d_sb;
 	char *full_path = NULL;
+	int count = 0;
 
 	if (inode == NULL)
 		return -ENOENT;
@@ -2024,15 +2025,18 @@ int cifs_revalidate_dentry_attr(struct d
 		 full_path, inode, inode->i_count.counter,
 		 dentry, cifs_get_time(dentry), jiffies);
 
+again:
 	if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 					 xid, NULL);
-
+	if (rc == -EAGAIN && count++ < 10)
+		goto again;
 out:
 	kfree(full_path);
 	free_xid(xid);
+
 	return rc;
 }
 


