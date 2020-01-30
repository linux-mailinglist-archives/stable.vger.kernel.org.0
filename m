Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA0514DD59
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgA3Ox1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:53:27 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:41450 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbgA3Ox1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:53:27 -0500
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id B5F762E0EEA;
        Thu, 30 Jan 2020 17:53:24 +0300 (MSK)
Received: from vla1-5a8b76e65344.qloud-c.yandex.net (vla1-5a8b76e65344.qloud-c.yandex.net [2a02:6b8:c0d:3183:0:640:5a8b:76e6])
        by mxbackcorp1g.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id YrXfyxhXbH-rM38Ftrw;
        Thu, 30 Jan 2020 17:53:24 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1580396004; bh=ErDg9q5tx1jcUv0mv/fq4rEz0B+nbir38rGTLqNzQHU=;
        h=In-Reply-To:Message-ID:References:Date:To:From:Subject:Cc;
        b=nRScms4FEf59pkk52nddESylWWRvq24uIb/8glHohJrXIiEbT29Ujc9gAq8URTiFS
         ydvT1FSv6jkzXWJ7zysxctzkaXTeDilB8nKo7iw+ZoYhrGZqVWAxMhnb9OTtpZSJtu
         wsFnc5HGpzoSaJdQ3uLpiONNQdVRtspYM12dzme8=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:8448:fbcc:1dac:c863])
        by vla1-5a8b76e65344.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id StvIjeNO68-rMVmSb4u;
        Thu, 30 Jan 2020 17:53:22 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH v4.19 2/2] block: fix 32 bit overflow in
 __blkdev_issue_discard()
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     Greg KH <greg@kroah.com>, Stable <stable@vger.kernel.org>
Cc:     linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <dchinner@redhat.com>,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Ming Lei <ming.lei@redhat.com>
Date:   Thu, 30 Jan 2020 17:53:22 +0300
Message-ID: <158039600260.4465.8760113992408208442.stgit@buzz>
In-Reply-To: <158039599680.4465.7011319825891038466.stgit@buzz>
References: <158039599680.4465.7011319825891038466.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Commit 4800bf7bc8c725e955fcbc6191cc872f43f506d3 upstream.

-- snip --

Overflow in __blkdev_issue_discard() actually exists since 4.18
commit af097f5d199e2aa3ab3ef777f0716e487b8f7b08 ("block: break discard
submissions into the user defined size"):

- req_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
+ req_sects = min_t(sector_t, nr_sects, q->limits.max_discard_sectors)

Default max_discard_sectors could be bigger than UINT_MAX.

And finally 4.19 commit 744889b7cbb56a64f957e65ade7cb65fe3f35714
("block: don't deal with discard limit in blkdev_issue_discard()")
made problem worse:

- req_sects = min_t(sector_t, nr_sects, q->limits.max_discard_sectors);
+ req_sects = nr_sects;

Now BLKDISCARD ioctl fails unexpectedly if lower word of length is zero:
ioctl(3, BLKDISCARD, [0, 0x20000000000])  = -1 EOPNOTSUPP (Operation not supported)

-- snip --

A discard cleanup merged into 4.20-rc2 causes fstests xfs/259 to
fall into an endless loop in the discard code. The test is creating
a device that is exactly 2^32 sectors in size to test mkfs boundary
conditions around the 32 bit sector overflow region.

mkfs issues a discard for the entire device size by default, and
hence this throws a sector count of 2^32 into
blkdev_issue_discard(). It takes the number of sectors to discard as
a sector_t - a 64 bit value.

The commit ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
takes this sector count and casts it to a 32 bit value before
comapring it against the maximum allowed discard size the device
has. This truncates away the upper 32 bits, and so if the lower 32
bits of the sector count is zero, it starts issuing discards of
length 0. This causes the code to fall into an endless loop, issuing
a zero length discards over and over again on the same sector.

Fixes: ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
Tested-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>

Killed pointless WARN_ON().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 block/blk-lib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 41088d5466c1..0dbc9e2ab9a3 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -56,9 +56,11 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		return -EINVAL;
 
 	while (nr_sects) {
-		unsigned int req_sects = min_t(unsigned int, nr_sects,
+		sector_t req_sects = min_t(sector_t, nr_sects,
 				bio_allowed_max_sectors(q));
 
+		WARN_ON_ONCE((req_sects << 9) > UINT_MAX);
+
 		bio = next_bio(bio, 0, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);

