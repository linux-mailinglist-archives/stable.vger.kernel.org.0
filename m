Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7FC53CF56
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344795AbiFCRyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347230AbiFCRwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25C132E;
        Fri,  3 Jun 2022 10:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B6FEB82419;
        Fri,  3 Jun 2022 17:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58B1C385A9;
        Fri,  3 Jun 2022 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278641;
        bh=YrXhbiJph5afatE3srEUKuLmWGYAxVpDpkaWS5nFUjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IF6s2I/u2/q0yDCdMNSoCJTI1NEJQ2bXhrbmy1tu9g7cQe+BLAu+Rt66KrAm0s1cb
         Y9ItHMdhwKK00OCju+sg2xFKqBfCzSiw3AsCQ0wvPRiK0JHi9Ulh3NdD8IywKwghKp
         Rg7rFS25QDuHrpftlIUwyGuOduXnUzwjqIBP+kHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Song Liu <song@kernel.org>, Xiao Ni <xni@redhat.com>
Subject: [PATCH 5.15 46/66] raid5: introduce MD_BROKEN
Date:   Fri,  3 Jun 2022 19:43:26 +0200
Message-Id: <20220603173821.998035862@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

commit 57668f0a4cc4083a120cc8c517ca0055c4543b59 upstream.

Raid456 module had allowed to achieve failed state. It was fixed by
fb73b357fb9 ("raid5: block failing device if raid will be failed").
This fix introduces a bug, now if raid5 fails during IO, it may result
with a hung task without completion. Faulty flag on the device is
necessary to process all requests and is checked many times, mainly in
analyze_stripe().
Allow to set faulty on drive again and set MD_BROKEN if raid is failed.

As a result, this level is allowed to achieve failed state again, but
communication with userspace (via -EBUSY status) will be preserved.

This restores possibility to fail array via #mdadm --set-faulty command
and will be fixed by additional verification on mdadm side.

Reproduction steps:
 mdadm -CR imsm -e imsm -n 3 /dev/nvme[0-2]n1
 mdadm -CR r5 -e imsm -l5 -n3 /dev/nvme[0-2]n1 --assume-clean
 mkfs.xfs /dev/md126 -f
 mount /dev/md126 /mnt/root/

 fio --filename=/mnt/root/file --size=5GB --direct=1 --rw=randrw
--bs=64k --ioengine=libaio --iodepth=64 --runtime=240 --numjobs=4
--time_based --group_reporting --name=throughput-test-job
--eta-newline=1 &

 echo 1 > /sys/block/nvme2n1/device/device/remove
 echo 1 > /sys/block/nvme1n1/device/device/remove

 [ 1475.787779] Call Trace:
 [ 1475.793111] __schedule+0x2a6/0x700
 [ 1475.799460] schedule+0x38/0xa0
 [ 1475.805454] raid5_get_active_stripe+0x469/0x5f0 [raid456]
 [ 1475.813856] ? finish_wait+0x80/0x80
 [ 1475.820332] raid5_make_request+0x180/0xb40 [raid456]
 [ 1475.828281] ? finish_wait+0x80/0x80
 [ 1475.834727] ? finish_wait+0x80/0x80
 [ 1475.841127] ? finish_wait+0x80/0x80
 [ 1475.847480] md_handle_request+0x119/0x190
 [ 1475.854390] md_make_request+0x8a/0x190
 [ 1475.861041] generic_make_request+0xcf/0x310
 [ 1475.868145] submit_bio+0x3c/0x160
 [ 1475.874355] iomap_dio_submit_bio.isra.20+0x51/0x60
 [ 1475.882070] iomap_dio_bio_actor+0x175/0x390
 [ 1475.889149] iomap_apply+0xff/0x310
 [ 1475.895447] ? iomap_dio_bio_actor+0x390/0x390
 [ 1475.902736] ? iomap_dio_bio_actor+0x390/0x390
 [ 1475.909974] iomap_dio_rw+0x2f2/0x490
 [ 1475.916415] ? iomap_dio_bio_actor+0x390/0x390
 [ 1475.923680] ? atime_needs_update+0x77/0xe0
 [ 1475.930674] ? xfs_file_dio_aio_read+0x6b/0xe0 [xfs]
 [ 1475.938455] xfs_file_dio_aio_read+0x6b/0xe0 [xfs]
 [ 1475.946084] xfs_file_read_iter+0xba/0xd0 [xfs]
 [ 1475.953403] aio_read+0xd5/0x180
 [ 1475.959395] ? _cond_resched+0x15/0x30
 [ 1475.965907] io_submit_one+0x20b/0x3c0
 [ 1475.972398] __x64_sys_io_submit+0xa2/0x180
 [ 1475.979335] ? do_io_getevents+0x7c/0xc0
 [ 1475.986009] do_syscall_64+0x5b/0x1a0
 [ 1475.992419] entry_SYSCALL_64_after_hwframe+0x65/0xca
 [ 1476.000255] RIP: 0033:0x7f11fc27978d
 [ 1476.006631] Code: Bad RIP value.
 [ 1476.073251] INFO: task fio:3877 blocked for more than 120 seconds.

Cc: stable@vger.kernel.org
Fixes: fb73b357fb9 ("raid5: block failing device if raid will be failed")
Reviewd-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -686,17 +686,17 @@ int raid5_calc_degraded(struct r5conf *c
 	return degraded;
 }
 
-static int has_failed(struct r5conf *conf)
+static bool has_failed(struct r5conf *conf)
 {
-	int degraded;
+	int degraded = conf->mddev->degraded;
 
-	if (conf->mddev->reshape_position == MaxSector)
-		return conf->mddev->degraded > conf->max_degraded;
+	if (test_bit(MD_BROKEN, &conf->mddev->flags))
+		return true;
 
-	degraded = raid5_calc_degraded(conf);
-	if (degraded > conf->max_degraded)
-		return 1;
-	return 0;
+	if (conf->mddev->reshape_position != MaxSector)
+		degraded = raid5_calc_degraded(conf);
+
+	return degraded > conf->max_degraded;
 }
 
 struct stripe_head *
@@ -2877,34 +2877,31 @@ static void raid5_error(struct mddev *md
 	unsigned long flags;
 	pr_debug("raid456: error called\n");
 
+	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n",
+		mdname(mddev), bdevname(rdev->bdev, b));
+
 	spin_lock_irqsave(&conf->device_lock, flags);
+	set_bit(Faulty, &rdev->flags);
+	clear_bit(In_sync, &rdev->flags);
+	mddev->degraded = raid5_calc_degraded(conf);
 
-	if (test_bit(In_sync, &rdev->flags) &&
-	    mddev->degraded == conf->max_degraded) {
-		/*
-		 * Don't allow to achieve failed state
-		 * Don't try to recover this device
-		 */
+	if (has_failed(conf)) {
+		set_bit(MD_BROKEN, &conf->mddev->flags);
 		conf->recovery_disabled = mddev->recovery_disabled;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		return;
+
+		pr_crit("md/raid:%s: Cannot continue operation (%d/%d failed).\n",
+			mdname(mddev), mddev->degraded, conf->raid_disks);
+	} else {
+		pr_crit("md/raid:%s: Operation continuing on %d devices.\n",
+			mdname(mddev), conf->raid_disks - mddev->degraded);
 	}
 
-	set_bit(Faulty, &rdev->flags);
-	clear_bit(In_sync, &rdev->flags);
-	mddev->degraded = raid5_calc_degraded(conf);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 
 	set_bit(Blocked, &rdev->flags);
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
-	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n"
-		"md/raid:%s: Operation continuing on %d devices.\n",
-		mdname(mddev),
-		bdevname(rdev->bdev, b),
-		mdname(mddev),
-		conf->raid_disks - mddev->degraded);
 	r5c_update_on_rdev_error(mddev, rdev);
 }
 


