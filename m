Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D31273E4E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390299AbfGXTmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389740AbfGXTl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:41:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92D7921873;
        Wed, 24 Jul 2019 19:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997319;
        bh=jnWybWz1GHgb+SURgW27+vuHdkH2zlG6t/JUokmp9Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihKC2HBZ7/XUQo3L5Z93YJRa/yiSHKQKbRljDLN7RJiLAutHJ95TOl1/1hti/Jqcu
         cjJQkg4iDmu6xiAxRKtzWKFOaDENja+5KUKwzAykqsLzq0DIitGjJaoTCp2DuDnzT5
         gfmakSv51sUaxOWSe49wkIKJut4Y+8tZrdEYgiR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 5.2 396/413] eCryptfs: fix a couple type promotion bugs
Date:   Wed, 24 Jul 2019 21:21:27 +0200
Message-Id: <20190724191803.299683811@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0bdf8a8245fdea6f075a5fede833a5fcf1b3466c upstream.

ECRYPTFS_SIZE_AND_MARKER_BYTES is type size_t, so if "rc" is negative
that gets type promoted to a high positive value and treated as success.

Fixes: 778aeb42a708 ("eCryptfs: Cleanup and optimize ecryptfs_lookup_interpose()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[tyhicks: Use "if/else if" rather than "if/if"]
Cc: stable@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/crypto.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1004,8 +1004,10 @@ int ecryptfs_read_and_validate_header_re
 
 	rc = ecryptfs_read_lower(file_size, 0, ECRYPTFS_SIZE_AND_MARKER_BYTES,
 				 inode);
-	if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
-		return rc >= 0 ? -EINVAL : rc;
+	if (rc < 0)
+		return rc;
+	else if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
+		return -EINVAL;
 	rc = ecryptfs_validate_marker(marker);
 	if (!rc)
 		ecryptfs_i_size_init(file_size, inode);
@@ -1367,8 +1369,10 @@ int ecryptfs_read_and_validate_xattr_reg
 				     ecryptfs_inode_to_lower(inode),
 				     ECRYPTFS_XATTR_NAME, file_size,
 				     ECRYPTFS_SIZE_AND_MARKER_BYTES);
-	if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
-		return rc >= 0 ? -EINVAL : rc;
+	if (rc < 0)
+		return rc;
+	else if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
+		return -EINVAL;
 	rc = ecryptfs_validate_marker(marker);
 	if (!rc)
 		ecryptfs_i_size_init(file_size, inode);


