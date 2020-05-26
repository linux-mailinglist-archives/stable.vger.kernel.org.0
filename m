Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF491A0B5C
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgDGKZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbgDGKZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864DE20771;
        Tue,  7 Apr 2020 10:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255147;
        bh=VG7Z96ZUZlKYwd0TaRLpdkJIVqF3gxuR9xzR4g0qwd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgXXRIe7uuEM/GzJfBD7z4R+VHLrAuBHb5Sp1jIzkj099DwljzKOMG0+abS1UvOE5
         c6owCi8hlJ/vvOARmS2OciQgCGhmn5gakOjY2R+pv1aV2CYtee6BMTfx7A+U4wm9xJ
         XJ6S+ng4gdIyi3YLqfSeNMdeR0HzoPe7CEtGiQdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Barry Marson <bmarson@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 31/46] Revert "dm: always call blk_queue_split() in dm_process_bio()"
Date:   Tue,  7 Apr 2020 12:22:02 +0200
Message-Id: <20200407101502.812102667@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 upstream.

This reverts commit effd58c95f277744f75d6e08819ac859dbcbd351.

blk_queue_split() is causing excessive IO splitting -- because
blk_max_size_offset() depends on 'chunk_sectors' limit being set and
if it isn't (as is the case for DM targets!) it falls back to
splitting on a 'max_sectors' boundary regardless of offset.

"Fix" this by reverting back to _not_ using blk_queue_split() in
dm_process_bio() for normal IO (reads and writes).  Long-term fix is
still TBD but it should focus on training blk_max_size_offset() to
call into a DM provided hook (to call DM's max_io_len()).

Test results from simple misaligned IO test on 4-way dm-striped device
with chunksize of 128K and stripesize of 512K:

xfs_io -d -c 'pread -b 2m 224s 4072s' /dev/mapper/stripe_dev

before this revert:

253,0   21        1     0.000000000  2206  Q   R 224 + 4072 [xfs_io]
253,0   21        2     0.000008267  2206  X   R 224 / 480 [xfs_io]
253,0   21        3     0.000010530  2206  X   R 224 / 256 [xfs_io]
253,0   21        4     0.000027022  2206  X   R 480 / 736 [xfs_io]
253,0   21        5     0.000028751  2206  X   R 480 / 512 [xfs_io]
253,0   21        6     0.000033323  2206  X   R 736 / 992 [xfs_io]
253,0   21        7     0.000035130  2206  X   R 736 / 768 [xfs_io]
253,0   21        8     0.000039146  2206  X   R 992 / 1248 [xfs_io]
253,0   21        9     0.000040734  2206  X   R 992 / 1024 [xfs_io]
253,0   21       10     0.000044694  2206  X   R 1248 / 1504 [xfs_io]
253,0   21       11     0.000046422  2206  X   R 1248 / 1280 [xfs_io]
253,0   21       12     0.000050376  2206  X   R 1504 / 1760 [xfs_io]
253,0   21       13     0.000051974  2206  X   R 1504 / 1536 [xfs_io]
253,0   21       14     0.000055881  2206  X   R 1760 / 2016 [xfs_io]
253,0   21       15     0.000057462  2206  X   R 1760 / 1792 [xfs_io]
253,0   21       16     0.000060999  2206  X   R 2016 / 2272 [xfs_io]
253,0   21       17     0.000062489  2206  X   R 2016 / 2048 [xfs_io]
253,0   21       18     0.000066133  2206  X   R 2272 / 2528 [xfs_io]
253,0   21       19     0.000067507  2206  X   R 2272 / 2304 [xfs_io]
253,0   21       20     0.000071136  2206  X   R 2528 / 2784 [xfs_io]
253,0   21       21     0.000072764  2206  X   R 2528 / 2560 [xfs_io]
253,0   21       22     0.000076185  2206  X   R 2784 / 3040 [xfs_io]
253,0   21       23     0.000077486  2206  X   R 2784 / 2816 [xfs_io]
253,0   21       24     0.000080885  2206  X   R 3040 / 3296 [xfs_io]
253,0   21       25     0.000082316  2206  X   R 3040 / 3072 [xfs_io]
253,0   21       26     0.000085788  2206  X   R 3296 / 3552 [xfs_io]
253,0   21       27     0.000087096  2206  X   R 3296 / 3328 [xfs_io]
253,0   21       28     0.000093469  2206  X   R 3552 / 3808 [xfs_io]
253,0   21       29     0.000095186  2206  X   R 3552 / 3584 [xfs_io]
253,0   21       30     0.000099228  2206  X   R 3808 / 4064 [xfs_io]
253,0   21       31     0.000101062  2206  X   R 3808 / 3840 [xfs_io]
253,0   21       32     0.000104956  2206  X   R 4064 / 4096 [xfs_io]
253,0   21       33     0.001138823     0  C   R 4096 + 200 [0]

after this revert:

253,0   18        1     0.000000000  4430  Q   R 224 + 3896 [xfs_io]
253,0   18        2     0.000018359  4430  X   R 224 / 256 [xfs_io]
253,0   18        3     0.000028898  4430  X   R 256 / 512 [xfs_io]
253,0   18        4     0.000033535  4430  X   R 512 / 768 [xfs_io]
253,0   18        5     0.000065684  4430  X   R 768 / 1024 [xfs_io]
253,0   18        6     0.000091695  4430  X   R 1024 / 1280 [xfs_io]
253,0   18        7     0.000098494  4430  X   R 1280 / 1536 [xfs_io]
253,0   18        8     0.000114069  4430  X   R 1536 / 1792 [xfs_io]
253,0   18        9     0.000129483  4430  X   R 1792 / 2048 [xfs_io]
253,0   18       10     0.000136759  4430  X   R 2048 / 2304 [xfs_io]
253,0   18       11     0.000152412  4430  X   R 2304 / 2560 [xfs_io]
253,0   18       12     0.000160758  4430  X   R 2560 / 2816 [xfs_io]
253,0   18       13     0.000183385  4430  X   R 2816 / 3072 [xfs_io]
253,0   18       14     0.000190797  4430  X   R 3072 / 3328 [xfs_io]
253,0   18       15     0.000197667  4430  X   R 3328 / 3584 [xfs_io]
253,0   18       16     0.000218751  4430  X   R 3584 / 3840 [xfs_io]
253,0   18       17     0.000226005  4430  X   R 3840 / 4096 [xfs_io]
253,0   18       18     0.000250404  4430  Q   R 4120 + 176 [xfs_io]
253,0   18       19     0.000847708     0  C   R 4096 + 24 [0]
253,0   18       20     0.000855783     0  C   R 4120 + 176 [0]

Fixes: effd58c95f27774 ("dm: always call blk_queue_split() in dm_process_bio()")
Cc: stable@vger.kernel.org
Reported-by: Andreas Gruenbacher <agruenba@redhat.com>
Tested-by: Barry Marson <bmarson@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1739,8 +1739,9 @@ static blk_qc_t dm_process_bio(struct ma
 	 * won't be imposed.
 	 */
 	if (current->bio_list) {
-		blk_queue_split(md->queue, &bio);
-		if (!is_abnormal_io(bio))
+		if (is_abnormal_io(bio))
+			blk_queue_split(md->queue, &bio);
+		else
 			dm_queue_split(md, ti, &bio);
 	}
 


