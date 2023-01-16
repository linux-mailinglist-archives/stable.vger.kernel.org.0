Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CA066C8A0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjAPQlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjAPQkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:40:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B22B27498
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:29:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D47EB80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FCBC433F0;
        Mon, 16 Jan 2023 16:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886543;
        bh=D8hXZNR+Dhb8nYIzmUavICNzVyzpGj2VTQ3/lqjfY+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTqFf/YoIjXFlonKwbigkPJ50D4SNL/J/lhH74FEPvyDjAbmc38w9JVi4bSqjDf6L
         miZmG8hNLZaOlMagdpX04L3uXPC1d52jrLmeThLkdsj2wAAKU9Dh1bfRBht9fMl+lr
         1GmBRMMqe9ORefZ5aJEy1iv49Gucy7/qhRNSpS34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.4 470/658] md: fix a crash in mempool_free
Date:   Mon, 16 Jan 2023 16:49:18 +0100
Message-Id: <20230116154930.997436308@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 341097ee53573e06ab9fc675d96a052385b851fa upstream.

There's a crash in mempool_free when running the lvm test
shell/lvchange-rebuild-raid.sh.

The reason for the crash is this:
* super_written calls atomic_dec_and_test(&mddev->pending_writes) and
  wake_up(&mddev->sb_wait). Then it calls rdev_dec_pending(rdev, mddev)
  and bio_put(bio).
* so, the process that waited on sb_wait and that is woken up is racing
  with bio_put(bio).
* if the process wins the race, it calls bioset_exit before bio_put(bio)
  is executed.
* bio_put(bio) attempts to free a bio into a destroyed bio set - causing
  a crash in mempool_free.

We fix this bug by moving bio_put before atomic_dec_and_test.

We also move rdev_dec_pending before atomic_dec_and_test as suggested by
Neil Brown.

The function md_end_flush has a similar bug - we must call bio_put before
we decrement the number of in-progress bios.

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 11557f0067 P4D 11557f0067 PUD 0
 Oops: 0002 [#1] PREEMPT SMP
 CPU: 0 PID: 73 Comm: kworker/0:1 Not tainted 6.1.0-rc3 #5
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Workqueue: kdelayd flush_expired_bios [dm_delay]
 RIP: 0010:mempool_free+0x47/0x80
 Code: 48 89 ef 5b 5d ff e0 f3 c3 48 89 f7 e8 32 45 3f 00 48 63 53 08 48 89 c6 3b 53 04 7d 2d 48 8b 43 10 8d 4a 01 48 89 df 89 4b 08 <48> 89 2c d0 e8 b0 45 3f 00 48 8d 7b 30 5b 5d 31 c9 ba 01 00 00 00
 RSP: 0018:ffff88910036bda8 EFLAGS: 00010093
 RAX: 0000000000000000 RBX: ffff8891037b65d8 RCX: 0000000000000001
 RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8891037b65d8
 RBP: ffff8891447ba240 R08: 0000000000012908 R09: 00000000003d0900
 R10: 0000000000000000 R11: 0000000000173544 R12: ffff889101a14000
 R13: ffff8891562ac300 R14: ffff889102b41440 R15: ffffe8ffffa00d05
 FS:  0000000000000000(0000) GS:ffff88942fa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 0000001102e99000 CR4: 00000000000006b0
 Call Trace:
  <TASK>
  clone_endio+0xf4/0x1c0 [dm_mod]
  clone_endio+0xf4/0x1c0 [dm_mod]
  __submit_bio+0x76/0x120
  submit_bio_noacct_nocheck+0xb6/0x2a0
  flush_expired_bios+0x28/0x2f [dm_delay]
  process_one_work+0x1b4/0x300
  worker_thread+0x45/0x3e0
  ? rescuer_thread+0x380/0x380
  kthread+0xc2/0x100
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>
 Modules linked in: brd dm_delay dm_raid dm_mod af_packet uvesafb cfbfillrect cfbimgblt cn cfbcopyarea fb font fbdev tun autofs4 binfmt_misc configfs ipv6 virtio_rng virtio_balloon rng_core virtio_net pcspkr net_failover failover qemu_fw_cfg button mousedev raid10 raid456 libcrc32c async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod sd_mod t10_pi crc64_rocksoft crc64 virtio_scsi scsi_mod evdev psmouse bsg scsi_common [last unloaded: brd]
 CR2: 0000000000000000
 ---[ end trace 0000000000000000 ]---

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -481,13 +481,14 @@ static void md_end_flush(struct bio *bio
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
 
+	bio_put(bio);
+
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
-	bio_put(bio);
 }
 
 static void md_submit_flush_data(struct work_struct *ws);
@@ -885,10 +886,12 @@ static void super_written(struct bio *bi
 	} else
 		clear_bit(LastDev, &rdev->flags);
 
+	bio_put(bio);
+
+	rdev_dec_pending(rdev, mddev);
+
 	if (atomic_dec_and_test(&mddev->pending_writes))
 		wake_up(&mddev->sb_wait);
-	rdev_dec_pending(rdev, mddev);
-	bio_put(bio);
 }
 
 void md_super_write(struct mddev *mddev, struct md_rdev *rdev,


