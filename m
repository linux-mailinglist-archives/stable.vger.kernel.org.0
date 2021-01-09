Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7998B2F00B6
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 16:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbhAIPSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 10:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbhAIPSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 10:18:14 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C535C06179F
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 07:17:24 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d13so11773364wrc.13
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 07:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jbX9sBSOqq7HnyVgOIs0Y/3AvCeAvSl2m8KcaMD9b14=;
        b=qCY0836HKpt4YDXJfwUb9k75+aoxktyeyEfiVRHxaV1cpw2F+RieU86/Nw8D8Mx3bG
         /OcKZ60qQF/I7XnfglZNeUbwiKwjwfNlqs1Dp81AB1FFhqhyhnU6HcElZSRvBhp2qDq9
         kjcxrNKxyYUvjKlQnIHlrC10260AobJIRF7jk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jbX9sBSOqq7HnyVgOIs0Y/3AvCeAvSl2m8KcaMD9b14=;
        b=aPFw/UBwsaZ1WfbFsXCbiLEeqWXwhD9MgUbX41J/AkGHeOvDcZOVG2lj3HdXPmN7gJ
         G3Rh02BJQAR2W8x1rQxtxX/dkv34+M+5jTprMpk7vLl9Hq2ctDtw29lFEY9YKFftHWFu
         /z8Hil1ANDL3XCDS+mtvMNsBKBcPlVCYh9baV7Vvc5gqZgNwXExeCge3EVtbuy+YR6kJ
         bxim3EBeT/3BwT17lYPNe1WkYjAIM/rYnqCFD3Xbs1gJiqycocfta7YWJDyjcW+Dhq3+
         i4PDQggPvHEf38EFgJeLHiIn21V2Si1g48fb1j736MoBLv/PnClb110uRBB2LKB6ndrF
         B9YA==
X-Gm-Message-State: AOAM5318tOqkWOpX5Z0YXItMDeukh5kqULQG9T3hkCgV8OH4jqqrnHXJ
        zpSMz7vRV0Y1W0mFcBYm/JS4sA==
X-Google-Smtp-Source: ABdhPJy84ymJk61jvZVZl4F+m82bWKREprN+kea/fz/8BHD09MMbKN08wcjL9PWoWHq07WnCEP4n8g==
X-Received: by 2002:adf:dc10:: with SMTP id t16mr8736626wri.345.1610205442583;
        Sat, 09 Jan 2021 07:17:22 -0800 (PST)
Received: from dev.cfops.net (29.177.200.146.dyn.plus.net. [146.200.177.29])
        by smtp.gmail.com with ESMTPSA id m21sm15663601wml.13.2021.01.09.07.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 07:17:21 -0800 (PST)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org
Cc:     Ignat Korchagin <ignat@cloudflare.com>, kernel-team@cloudflare.com,
        stable@vger.kernel.org
Subject: [PATCH] dm crypt: do not call bio_endio() from the dm-crypt tasklet
Date:   Sat,  9 Jan 2021 15:17:06 +0000
Message-Id: <20210109151706.1466-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sometimes, when dm-crypt executes decryption in a tasklet, we may get the
following on a kasan-enabled kernel:

[  397.613621][   C74] ==================================================================
[  397.621794][   C74] BUG: KASAN: use-after-free in tasklet_action_common.constprop.0+0x151/0x2b0
[  397.630759][   C74] Write of size 8 at addr ffff88a139054648 by task swapper/74/0
[  397.638465][   C74]
[  397.640725][   C74] CPU: 74 PID: 0 Comm: swapper/74 Not tainted 5.10.5-cloudflare-kasan-2021.1.3 #1
[  397.650048][   C74] Hardware name: does not matter
[  397.658834][   C74] Call Trace:
[  397.662073][   C74]  <IRQ>
[  397.664862][   C74]  dump_stack+0x7d/0xa3
[  397.668994][   C74]  print_address_description.constprop.0+0x1c/0x210
[  397.675632][   C74]  ? _raw_spin_lock_irqsave+0x87/0xe0
[  397.681017][   C74]  ? _raw_write_unlock_bh+0x60/0x60
[  397.686221][   C74]  ? tasklet_action_common.constprop.0+0x151/0x2b0
[  397.692772][   C74]  ? tasklet_action_common.constprop.0+0x151/0x2b0
[  397.699324][   C74]  kasan_report.cold+0x1f/0x37
[  397.704086][   C74]  ? tasklet_action_common.constprop.0+0x151/0x2b0
[  397.710634][   C74]  check_memory_region+0x13c/0x180
[  397.715752][   C74]  tasklet_action_common.constprop.0+0x151/0x2b0
[  397.722122][   C74]  __do_softirq+0x1a0/0x667
[  397.732905][   C74]  asm_call_irq_on_stack+0x12/0x20
[  397.744322][   C74]  </IRQ>
[  397.753537][   C74]  do_softirq_own_stack+0x37/0x40
[  397.764745][   C74]  irq_exit_rcu+0x110/0x1b0
[  397.775248][   C74]  common_interrupt+0x74/0x120
[  397.785851][   C74]  asm_common_interrupt+0x1e/0x40
[  397.796568][   C74] RIP: 0010:cpuidle_enter_state+0x188/0xab0
[  397.808040][   C74] Code: 89 c4 0f 1f 44 00 00 31 ff e8 d4 bc a4 fe 80 3c 24 00 74 12 9c 58 f6 c4 02 0f 85 2f 06 00 00 31 ff e8 2c 9d b6 fe fb 45 85 f6 <0f> 88 8d 03 00 00 4d 63 ee 49 83 fd 09 0f 87 e1 06 00 00 49 6b c5
[  397.845062][   C74] RSP: 0018:ffff88a05325fe10 EFLAGS: 00000202
[  397.857116][   C74] RAX: dffffc0000000000 RBX: ffff88a068850800 RCX: 000000000000001f
[  397.871232][   C74] RDX: 1ffff115f9f76634 RSI: 0000000037a6f674 RDI: ffff88afcfbb31a0
[  397.885178][   C74] RBP: ffffffff969c0920 R08: 0000011bef59a0e8 R09: ffff88afcfbb3383
[  397.899043][   C74] R10: ffffed15f9f76670 R11: 0000005c1545d831 R12: 0000005c939dd540
[  397.912779][   C74] R13: 0000000000000002 R14: 0000000000000002 R15: ffffffff969c0a48
[  397.926511][   C74]  cpuidle_enter+0x4a/0xa0
[  397.936547][   C74]  ? call_cpuidle+0x3c/0xb0
[  397.946522][   C74]  do_idle+0x2bd/0x320
[  397.955903][   C74]  ? arch_cpu_idle_exit+0x40/0x40
[  397.966195][   C74]  ? swake_up_locked+0x72/0x190
[  397.976193][   C74]  cpu_startup_entry+0x19/0x20
[  397.985918][   C74]  secondary_startup_64_no_verify+0xb0/0xbb
[  397.996679][   C74]
[  398.003698][   C74] Allocated by task 0:
[  398.012533][   C74] (stack is not available)
[  398.021729][   C74]
[  398.028707][   C74] Freed by task 0:
[  398.037155][   C74]  kasan_save_stack+0x20/0x50
[  398.046457][   C74]  kasan_set_track+0x1c/0x30
[  398.055610][   C74]  kasan_set_free_info+0x1b/0x30
[  398.065170][   C74]  __kasan_slab_free+0x110/0x150
[  398.074676][   C74]  slab_free_freelist_hook+0x66/0x120
[  398.084586][   C74]  kmem_cache_free+0x104/0x480
[  398.093834][   C74]  dec_pending+0x1ed/0x8f0 [dm_mod]
[  398.103486][   C74]  clone_endio+0x215/0x870 [dm_mod]
[  398.113058][   C74]  tasklet_action_common.constprop.0+0x20d/0x2b0
[  398.123838][   C74]  __do_softirq+0x1a0/0x667
[  398.132768][   C74]
[  398.139448][   C74] The buggy address belongs to the object at ffff88a139054600
[  398.139448][   C74]  which belongs to the cache bio-5 of size 1144
[  398.162373][   C74] The buggy address is located 72 bytes inside of
[  398.162373][   C74]  1144-byte region [ffff88a139054600, ffff88a139054a78)
[  398.185131][   C74] The buggy address belongs to the page:
[  398.195384][   C74] page:0000000020f4c3cc refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2139050
[  398.214988][   C74] head:0000000020f4c3cc order:3 compound_mapcount:0 compound_pincount:0
[  398.228183][   C74] flags: 0xaffff800010200(slab|head)
[  398.238146][   C74] raw: 00affff800010200 dead000000000100 dead000000000122 ffff88a13b99da00
[  398.251691][   C74] raw: 0000000000000000 0000000080190019 00000001ffffffff 0000000000000000
[  398.265140][   C74] page dumped because: kasan: bad access detected
[  398.276422][   C74]
[  398.283502][   C74] Memory state around the buggy address:
[  398.293892][   C74]  ffff88a139054500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  398.306895][   C74]  ffff88a139054580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  398.319841][   C74] >ffff88a139054600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  398.332767][   C74]                                               ^
[  398.344064][   C74]  ffff88a139054680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  398.357159][   C74]  ffff88a139054700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  398.370160][   C74] ==================================================================

When the decryption fully completes in the tasklet, dm-crypt will call
bio_endio(), which in turn will call clone_endio() from dm.c core code. That
function frees the resources associated with the bio, including per bio private
structures. For dm-crypt it will free the current struct dm_crypt_io, which
contains our tasklet object, causing use-after-free, when the tasklet is being
dequeued by the kernel.

To avoid this, do not call bio_endio() from the current tasklet context, but
delay its execution to the dm-crypt IO workqueue.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 53791138d78b..90f109d8a4a7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1691,6 +1691,12 @@ static void crypt_inc_pending(struct dm_crypt_io *io)
 	atomic_inc(&io->io_pending);
 }
 
+static void kcryptd_io_bio_endio(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	bio_endio(io->base_bio);
+}
+
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
@@ -1713,7 +1719,23 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 		kfree(io->integrity_metadata);
 
 	base_bio->bi_status = error;
-	bio_endio(base_bio);
+
+	/*
+	 * If we are running this function from our tasklet,
+	 * we can't call bio_endio() here, because it will call
+	 * clone_endio() from dm.c, which in turn will
+	 * free the current struct dm_crypt_io structure with
+	 * our tasklet. In this case we need to delay bio_endio()
+	 * execution to after the tasklet is done and dequeued.
+	 */
+	if (tasklet_trylock(&io->tasklet)) {
+		tasklet_unlock(&io->tasklet);
+		bio_endio(base_bio);
+		return;
+	}
+
+	INIT_WORK(&io->work, kcryptd_io_bio_endio);
+	queue_work(cc->io_queue, &io->work);
 }
 
 /*
-- 
2.20.1

