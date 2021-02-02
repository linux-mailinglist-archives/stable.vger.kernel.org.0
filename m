Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5B330CC07
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhBBTm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:42:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhBBNxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:53:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9087264FD6;
        Tue,  2 Feb 2021 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273444;
        bh=AE5CRdV5pTg398EOsEgJPgCIIxFO+/EblHIVh2hYYrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pdxofku2klLIV6p/mimMlZ732OLPKp0ZBOcz4kJ8qYO19DB3K/KW85zkka20sn/Th
         HW2dhj9hSxbNu22oR52/RCoJ5zTgDAuCWvMOa5k3FUEYz4kVsR/5K7aoz8f5/KqiB2
         cg4aa1B1ohv3EKsdJcZGg9OHoEBsbnsOE4MiepYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 077/142] Revert "block: simplify set_init_blocksize" to regain lost performance
Date:   Tue,  2 Feb 2021 14:37:20 +0100
Message-Id: <20210202133000.885609641@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maxtram95@gmail.com>

commit 8dc932d3e8afb65e12eba7495f046c83884c49bf upstream.

The cited commit introduced a serious regression with SATA write speed,
as found by bisecting. This patch reverts this commit, which restores
write speed back to the values observed before this commit.

The performance tests were done on a Helios4 NAS (2nd batch) with 4 HDDs
(WD8003FFBX) using dd (bs=1M count=2000). "Direct" is a test with a
single HDD, the rest are different RAID levels built over the first
partitions of 4 HDDs. Test results are in MB/s, R is read, W is write.

                | Direct | RAID0 | RAID10 f2 | RAID10 n2 | RAID6
----------------+--------+-------+-----------+-----------+--------
9011495c9466    | R:256  | R:313 | R:276     | R:313     | R:323
(before faulty) | W:254  | W:253 | W:195     | W:204     | W:117
----------------+--------+-------+-----------+-----------+--------
5ff9f19231a0    | R:257  | R:398 | R:312     | R:344     | R:391
(faulty commit) | W:154  | W:122 | W:67.7    | W:66.6    | W:67.2
----------------+--------+-------+-----------+-----------+--------
5.10.10         | R:256  | R:401 | R:312     | R:356     | R:375
unpatched       | W:149  | W:123 | W:64      | W:64.1    | W:61.5
----------------+--------+-------+-----------+-----------+--------
5.10.10         | R:255  | R:396 | R:312     | R:340     | R:393
patched         | W:247  | W:274 | W:220     | W:225     | W:121

Applying this patch doesn't hurt read performance, while improves the
write speed by 1.5x - 3.5x (more impact on RAID tests). The write speed
is restored back to the state before the faulty commit, and even a bit
higher in RAID tests (which aren't HDD-bound on this device) - that is
likely related to other optimizations done between the faulty commit and
5.10.10 which also improved the read speed.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Fixes: 5ff9f19231a0 ("block: simplify set_init_blocksize")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/block_dev.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -134,7 +134,15 @@ EXPORT_SYMBOL(truncate_bdev_range);
 
 static void set_init_blocksize(struct block_device *bdev)
 {
-	bdev->bd_inode->i_blkbits = blksize_bits(bdev_logical_block_size(bdev));
+	unsigned int bsize = bdev_logical_block_size(bdev);
+	loff_t size = i_size_read(bdev->bd_inode);
+
+	while (bsize < PAGE_SIZE) {
+		if (size & bsize)
+			break;
+		bsize <<= 1;
+	}
+	bdev->bd_inode->i_blkbits = blksize_bits(bsize);
 }
 
 int set_blocksize(struct block_device *bdev, int size)


