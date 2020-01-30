Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F84C14E20D
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgA3StN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgA3Ss5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 467A920CC7;
        Thu, 30 Jan 2020 18:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410136;
        bh=wTJKfnahA9dRh4GuTokx+sUYQydd9BTA3cBAE6sWKVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjbmkMJpWr9aEAc9dJslD4KjHQL3MtTT1SjMFLxn0QyNyIaFzjb85WbK7GBG3vGRd
         Z9Y4Qek0+1vw/8Xun2JOpvhXyRz2sR+VIhKrcpiqDazG6kyvgsiKfb9Tq0c3DwlGTp
         2cIRCMqxp+LuYJS2tiK6mCrIpP72JhTBUEapSrcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH 4.19 54/55] block: fix 32 bit overflow in __blkdev_issue_discard()
Date:   Thu, 30 Jan 2020 19:39:35 +0100
Message-Id: <20200130183618.177984182@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 4800bf7bc8c725e955fcbc6191cc872f43f506d3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-lib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -56,9 +56,11 @@ int __blkdev_issue_discard(struct block_
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


