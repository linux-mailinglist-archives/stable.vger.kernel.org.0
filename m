Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A79F22EE7C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgG0OIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729375AbgG0OII (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:08:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53A52073E;
        Mon, 27 Jul 2020 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858888;
        bh=1krdMMCgu2EhWpI5PXJAaTOqyzYFC6r2SVugadVwagU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNP2vazWLfFsXwvPq7mp/pSW5f6LQfViFnB9MONEpUov5VbuL20JO0Hr3YvvgSZ6Y
         eM7W5A1og5J1F58O0H1FENE8pwWpiaNMepDdkT8BDh/ZG2oPPeye2nyiOkd/o4Lr80
         WR7gMgrkK8Lkw7SmupbSid/zH0KELURkzsD0ukXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Patrick Fernie <patrick.fernie@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Subject: [PATCH 4.14 49/64] Revert "cifs: Fix the target file was deleted when rename failed."
Date:   Mon, 27 Jul 2020 16:04:28 +0200
Message-Id: <20200727134913.606900997@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 0e6705182d4e1b77248a93470d6d7b3013d59b30 upstream.

This reverts commit 9ffad9263b467efd8f8dc7ae1941a0a655a2bab2.

Upon additional testing with older servers, it was found that
the original commit introduced a regression when using the old SMB1
dialect and rsyncing over an existing file.

The patch will need to be respun to address this, likely including
a larger refactoring of the SMB1 and SMB3 rename code paths to make
it less confusing and also to address some additional rename error
cases that SMB3 may be able to workaround.

Signed-off-by: Steve French <stfrench@microsoft.com>
Reported-by: Patrick Fernie <patrick.fernie@gmail.com>
CC: Stable <stable@vger.kernel.org>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Pavel Shilovsky <pshilov@microsoft.com>
Acked-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1778,7 +1778,6 @@ cifs_rename2(struct inode *source_dir, s
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	unsigned int xid;
 	int rc, tmprc;
-	bool new_target = d_really_is_negative(target_dentry);
 
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
@@ -1855,13 +1854,8 @@ cifs_rename2(struct inode *source_dir, s
 	 */
 
 unlink_target:
-	/*
-	 * If the target dentry was created during the rename, try
-	 * unlinking it if it's not negative
-	 */
-	if (new_target &&
-	    d_really_is_positive(target_dentry) &&
-	    (rc == -EACCES || rc == -EEXIST)) {
+	/* Try unlinking the target dentry if it's not negative */
+	if (d_really_is_positive(target_dentry) && (rc == -EACCES || rc == -EEXIST)) {
 		if (d_is_dir(target_dentry))
 			tmprc = cifs_rmdir(target_dir, target_dentry);
 		else


