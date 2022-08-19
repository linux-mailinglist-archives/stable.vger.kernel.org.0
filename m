Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08674599E91
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349932AbiHSPlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349933AbiHSPkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:40:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E78110229B;
        Fri, 19 Aug 2022 08:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FD9D615ED;
        Fri, 19 Aug 2022 15:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC47C433C1;
        Fri, 19 Aug 2022 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923642;
        bh=vBDzMj0vdneBljcs0J9+8LQUISJkWb9gloLTniwZybo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eu1ekFSldIDN+C+S6DQ1Ev6oBn5RaNB27ivb2rPEUVQWAMgtjqmwi+cJDm+GR1/iV
         d6VAWTbFyV+jUis6ArPmyW7eVWsYi2fNihoS0ourS5CuWKymInYgilUumj6TixbzjY
         snQ5xHRQD/ykL0IuM7vS7ugw5YWftKFY0cjTQC20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>
Subject: [PATCH 5.18 4/6] btrfs: raid56: dont trust any cached sector in __raid56_parity_recover()
Date:   Fri, 19 Aug 2022 17:40:16 +0200
Message-Id: <20220819153710.607138769@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153710.430046927@linuxfoundation.org>
References: <20220819153710.430046927@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit f6065f8edeb25f4a9dfe0b446030ad995a84a088 upstream.

[BUG]
There is a small workload which will always fail with recent kernel:
(A simplified version from btrfs/125 test case)

  mkfs.btrfs -f -m raid5 -d raid5 -b 1G $dev1 $dev2 $dev3
  mount $dev1 $mnt
  xfs_io -f -c "pwrite -S 0xee 0 1M" $mnt/file1
  sync
  umount $mnt
  btrfs dev scan -u $dev3
  mount -o degraded $dev1 $mnt
  xfs_io -f -c "pwrite -S 0xff 0 128M" $mnt/file2
  umount $mnt
  btrfs dev scan
  mount $dev1 $mnt
  btrfs balance start --full-balance $mnt
  umount $mnt

The failure is always failed to read some tree blocks:

  BTRFS info (device dm-4): relocating block group 217710592 flags data|raid5
  BTRFS error (device dm-4): parent transid verify failed on 38993920 wanted 9 found 7
  BTRFS error (device dm-4): parent transid verify failed on 38993920 wanted 9 found 7
  ...

[CAUSE]
With the recently added debug output, we can see all RAID56 operations
related to full stripe 38928384:

  56.1183: raid56_read_partial: full_stripe=38928384 devid=2 type=DATA1 offset=0 opf=0x0 physical=9502720 len=65536
  56.1185: raid56_read_partial: full_stripe=38928384 devid=3 type=DATA2 offset=16384 opf=0x0 physical=9519104 len=16384
  56.1185: raid56_read_partial: full_stripe=38928384 devid=3 type=DATA2 offset=49152 opf=0x0 physical=9551872 len=16384
  56.1187: raid56_write_stripe: full_stripe=38928384 devid=3 type=DATA2 offset=0 opf=0x1 physical=9502720 len=16384
  56.1188: raid56_write_stripe: full_stripe=38928384 devid=3 type=DATA2 offset=32768 opf=0x1 physical=9535488 len=16384
  56.1188: raid56_write_stripe: full_stripe=38928384 devid=1 type=PQ1 offset=0 opf=0x1 physical=30474240 len=16384
  56.1189: raid56_write_stripe: full_stripe=38928384 devid=1 type=PQ1 offset=32768 opf=0x1 physical=30507008 len=16384
  56.1218: raid56_write_stripe: full_stripe=38928384 devid=3 type=DATA2 offset=49152 opf=0x1 physical=9551872 len=16384
  56.1219: raid56_write_stripe: full_stripe=38928384 devid=1 type=PQ1 offset=49152 opf=0x1 physical=30523392 len=16384
  56.2721: raid56_parity_recover: full stripe=38928384 eb=39010304 mirror=2
  56.2723: raid56_parity_recover: full stripe=38928384 eb=39010304 mirror=2
  56.2724: raid56_parity_recover: full stripe=38928384 eb=39010304 mirror=2

Before we enter raid56_parity_recover(), we have triggered some metadata
write for the full stripe 38928384, this leads to us to read all the
sectors from disk.

Furthermore, btrfs raid56 write will cache its calculated P/Q sectors to
avoid unnecessary read.

This means, for that full stripe, after any partial write, we will have
stale data, along with P/Q calculated using that stale data.

Thankfully due to patch "btrfs: only write the sectors in the vertical stripe
which has data stripes" we haven't submitted all the corrupted P/Q to disk.

When we really need to recover certain range, aka in
raid56_parity_recover(), we will use the cached rbio, along with its
cached sectors (the full stripe is all cached).

This explains why we have no event raid56_scrub_read_recover()
triggered.

Since we have the cached P/Q which is calculated using the stale data,
the recovered one will just be stale.

In our particular test case, it will always return the same incorrect
metadata, thus causing the same error message "parent transid verify
failed on 39010304 wanted 9 found 7" again and again.

[BTRFS DESTRUCTIVE RMW PROBLEM]

Test case btrfs/125 (and above workload) always has its trouble with
the destructive read-modify-write (RMW) cycle:

        0       32K     64K
Data1:  | Good  | Good  |
Data2:  | Bad   | Bad   |
Parity: | Good  | Good  |

In above case, if we trigger any write into Data1, we will use the bad
data in Data2 to re-generate parity, killing the only chance to recovery
Data2, thus Data2 is lost forever.

This destructive RMW cycle is not specific to btrfs RAID56, but there
are some btrfs specific behaviors making the case even worse:

- Btrfs will cache sectors for unrelated vertical stripes.

  In above example, if we're only writing into 0~32K range, btrfs will
  still read data range (32K ~ 64K) of Data1, and (64K~128K) of Data2.
  This behavior is to cache sectors for later update.

  Incidentally commit d4e28d9b5f04 ("btrfs: raid56: make steal_rbio()
  subpage compatible") has a bug which makes RAID56 to never trust the
  cached sectors, thus slightly improve the situation for recovery.

  Unfortunately, follow up fix "btrfs: update stripe_sectors::uptodate in
  steal_rbio" will revert the behavior back to the old one.

- Btrfs raid56 partial write will update all P/Q sectors and cache them

  This means, even if data at (64K ~ 96K) of Data2 is free space, and
  only (96K ~ 128K) of Data2 is really stale data.
  And we write into that (96K ~ 128K), we will update all the parity
  sectors for the full stripe.

  This unnecessary behavior will completely kill the chance of recovery.

  Thankfully, an unrelated optimization "btrfs: only write the sectors
  in the vertical stripe which has data stripes" will prevent
  submitting the write bio for untouched vertical sectors.

  That optimization will keep the on-disk P/Q untouched for a chance for
  later recovery.

[FIX]
Although we have no good way to completely fix the destructive RMW
(unless we go full scrub for each partial write), we can still limit the
damage.

With patch "btrfs: only write the sectors in the vertical stripe which
has data stripes" now we won't really submit the P/Q of unrelated
vertical stripes, so the on-disk P/Q should still be fine.

Now we really need to do is just drop all the cached sectors when doing
recovery.

By this, we have a chance to read the original P/Q from disk, and have a
chance to recover the stale data, while still keep the cache to speed up
regular write path.

In fact, just dropping all the cache for recovery path is good enough to
allow the test case btrfs/125 along with the small script to pass
reliably.

The lack of metadata write after the degraded mount, and forced metadata
COW is saving us this time.

So this patch will fix the behavior by not trust any cache in
__raid56_parity_recover(), to solve the problem while still keep the
cache useful.

But please note that this test pass DOES NOT mean we have solved the
destructive RMW problem, we just do better damage control a little
better.

Related patches:

- btrfs: only write the sectors in the vertical stripe
- d4e28d9b5f04 ("btrfs: raid56: make steal_rbio() subpage compatible")
- btrfs: update stripe_sectors::uptodate in steal_rbio

Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/raid56.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2084,9 +2084,12 @@ static int __raid56_parity_recover(struc
 	atomic_set(&rbio->error, 0);
 
 	/*
-	 * read everything that hasn't failed.  Thanks to the
-	 * stripe cache, it is possible that some or all of these
-	 * pages are going to be uptodate.
+	 * Read everything that hasn't failed. However this time we will
+	 * not trust any cached sector.
+	 * As we may read out some stale data but higher layer is not reading
+	 * that stale part.
+	 *
+	 * So here we always re-read everything in recovery path.
 	 */
 	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 		if (rbio->faila == stripe || rbio->failb == stripe) {
@@ -2095,16 +2098,6 @@ static int __raid56_parity_recover(struc
 		}
 
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
-			struct page *p;
-
-			/*
-			 * the rmw code may have already read this
-			 * page in
-			 */
-			p = rbio_stripe_page(rbio, stripe, pagenr);
-			if (PageUptodate(p))
-				continue;
-
 			ret = rbio_add_io_page(rbio, &bio_list,
 				       rbio_stripe_page(rbio, stripe, pagenr),
 				       stripe, pagenr, rbio->stripe_len);


