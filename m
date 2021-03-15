Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515CF33B989
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhCOOGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233424AbhCOOBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1095F64EED;
        Mon, 15 Mar 2021 14:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816878;
        bh=o9XoxA6cgpzYrjnJoBJUj3JeOPg7fchmVOJ0RcS6UT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjJNbrdzZRjDIde8JFIxue/k+qQ56/IBID3MKM1rua6o8CTp38zv/aMfMGKa0cVVG
         WGrVs9RzWFmf0Ccga+a1XefzVtdFiO0XuPj7N6Xirb+D6g2VRysvKFK4bopmTjQtSt
         2S7KFWvOoJCKKzMn4vrFEPQsVI6OOW5PUtltqKdE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 179/306] block: Try to handle busy underlying device on discard
Date:   Mon, 15 Mar 2021 14:54:02 +0100
Message-Id: <20210315135513.663989986@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jan Kara <jack@suse.cz>

commit 56887cffe946bb0a90c74429fa94d6110a73119d upstream.

Commit 384d87ef2c95 ("block: Do not discard buffers under a mounted
filesystem") made paths issuing discard or zeroout requests to the
underlying device try to grab block device in exclusive mode. If that
failed we returned EBUSY to userspace. This however caused unexpected
fallout in userspace where e.g. FUSE filesystems issue discard requests
from userspace daemons although the device is open exclusively by the
kernel. Also shrinking of logical volume by LVM issues discard requests
to a device which may be claimed exclusively because there's another LV
on the same PV. So to avoid these userspace regressions, fall back to
invalidate_inode_pages2_range() instead of returning EBUSY to userspace
and return EBUSY only of that call fails as well (meaning that there's
indeed someone using the particular device range we are trying to
discard).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=211167
Fixes: 384d87ef2c95 ("block: Do not discard buffers under a mounted filesystem")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/block_dev.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -118,13 +118,22 @@ int truncate_bdev_range(struct block_dev
 	if (!(mode & FMODE_EXCL)) {
 		int err = bd_prepare_to_claim(bdev, truncate_bdev_range);
 		if (err)
-			return err;
+			goto invalidate;
 	}
 
 	truncate_inode_pages_range(bdev->bd_inode->i_mapping, lstart, lend);
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(bdev, truncate_bdev_range);
 	return 0;
+
+invalidate:
+	/*
+	 * Someone else has handle exclusively open. Try invalidating instead.
+	 * The 'end' argument is inclusive so the rounding is safe.
+	 */
+	return invalidate_inode_pages2_range(bdev->bd_inode->i_mapping,
+					     lstart >> PAGE_SHIFT,
+					     lend >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(truncate_bdev_range);
 


