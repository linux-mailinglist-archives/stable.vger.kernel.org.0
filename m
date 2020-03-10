Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879CA17F8C0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgCJMup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbgCJMuo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:50:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 813E02468E;
        Tue, 10 Mar 2020 12:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844644;
        bh=3Jf6pIjSd3VVTUeADF5yeI9D3TBaQdwryKXwLSrOme0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IGGKy27D/u3twkC60c4lIAEMjR92G7qSGJBtmEE3QcQe4wPlvi97pJr1mZzA4wBB
         bglAxRDyifK8fH7kCnHVXXQy9NeDn9sOdhr7oWYyEuL7rrL+fabIgrYZgcc2k6a/rV
         c88LWYKkJ7iFz0/pkhvBQSYTkLPK8uiFE9IPGi+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 5.4 064/168] cifs: dont leak -EAGAIN for stat() during reconnect
Date:   Tue, 10 Mar 2020 13:38:30 +0100
Message-Id: <20200310123641.747743286@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
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
@@ -2011,6 +2011,7 @@ int cifs_revalidate_dentry_attr(struct d
 	struct inode *inode = d_inode(dentry);
 	struct super_block *sb = dentry->d_sb;
 	char *full_path = NULL;
+	int count = 0;
 
 	if (inode == NULL)
 		return -ENOENT;
@@ -2032,15 +2033,18 @@ int cifs_revalidate_dentry_attr(struct d
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
 


