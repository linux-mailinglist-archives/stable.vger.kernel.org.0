Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CD533B9E6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbhCOOG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233506AbhCOOBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE35064DAD;
        Mon, 15 Mar 2021 14:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816913;
        bh=M7EsEqAtFnvfj5oU+YriwkvpIGcbhpNTnd6ThIj0qoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3ej6tPpwysDnlV1ZqXEH3rIjv+bONzlYf8cSMEH/KMIFgBuE2KX1X5IhoYMScshM
         EPGd5R7EwnEK5+F2VT3Jsj6/H8ojC7ocTRE10MBiDu9DuRf43dEY/aMiwsLYomZLki
         KNmOi7nMMqVnMizluA7vsM9M5g7z27Yxxq4NJh+0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 185/290] block: Try to handle busy underlying device on discard
Date:   Mon, 15 Mar 2021 14:54:38 +0100
Message-Id: <20210315135548.169358717@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -123,12 +123,21 @@ int truncate_bdev_range(struct block_dev
 		err = bd_prepare_to_claim(bdev, claimed_bdev,
 					  truncate_bdev_range);
 		if (err)
-			return err;
+			goto invalidate;
 	}
 	truncate_inode_pages_range(bdev->bd_inode->i_mapping, lstart, lend);
 	if (claimed_bdev)
 		bd_abort_claiming(bdev, claimed_bdev, truncate_bdev_range);
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
 


