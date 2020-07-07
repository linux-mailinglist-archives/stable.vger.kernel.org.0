Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ADD21700F
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgGGPOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728676AbgGGPOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E34A20674;
        Tue,  7 Jul 2020 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134875;
        bh=ivVpjAAfUDjrMBSdx4Rk0/bc9fLwNzK7U0CdFpgI/Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyEylXaj0qZXA3CylHzM3690BRM8DhJ7IHp7Y9ym2a8Q8tIuiyoyNtfDwfLpaL5js
         Np8FC7dd+6xcUVn5R6uywF53f6aLG9Fh/kAk/hqNmwu9LIUhHq2pnixOM19mkfCW3f
         1vsZHR1IFtFX5PXAckYf63v1A71LluDESHnWWQFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 4.9 21/24] cifs: Fix the target file was deleted when rename failed.
Date:   Tue,  7 Jul 2020 17:13:53 +0200
Message-Id: <20200707145750.006919411@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 9ffad9263b467efd8f8dc7ae1941a0a655a2bab2 upstream.

When xfstest generic/035, we found the target file was deleted
if the rename return -EACESS.

In cifs_rename2, we unlink the positive target dentry if rename
failed with EACESS or EEXIST, even if the target dentry is positived
before rename. Then the existing file was deleted.

We should just delete the target file which created during the
rename.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1770,6 +1770,7 @@ cifs_rename2(struct inode *source_dir, s
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	unsigned int xid;
 	int rc, tmprc;
+	bool new_target = d_really_is_negative(target_dentry);
 
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
@@ -1846,8 +1847,13 @@ cifs_rename2(struct inode *source_dir, s
 	 */
 
 unlink_target:
-	/* Try unlinking the target dentry if it's not negative */
-	if (d_really_is_positive(target_dentry) && (rc == -EACCES || rc == -EEXIST)) {
+	/*
+	 * If the target dentry was created during the rename, try
+	 * unlinking it if it's not negative
+	 */
+	if (new_target &&
+	    d_really_is_positive(target_dentry) &&
+	    (rc == -EACCES || rc == -EEXIST)) {
 		if (d_is_dir(target_dentry))
 			tmprc = cifs_rmdir(target_dir, target_dentry);
 		else


