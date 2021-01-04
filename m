Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382672E97F2
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbhADPBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbhADPBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 10:01:06 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6F9C0617A0
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 07:00:07 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id e25so19634903wme.0
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 07:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CkSaZgPxJaN1/gTlwX2RFLNOGUrJzxXD9c7FCL0OvWs=;
        b=EZ/Hj48cX6MYteSDyqdtFUrE0f1WDt2ndOW5KzpQP5xO8NBk6qy5nD1jodk4WFFrl+
         Smo0BSgMCDDNDjCVfko6zO2kQIn7NCH/0nERvA04CukuPKIzecatoCv5YE39KRrRxQf8
         RCLWWSHyZ6Rx4tKQujVZcDK5f74mjlqFkZb9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CkSaZgPxJaN1/gTlwX2RFLNOGUrJzxXD9c7FCL0OvWs=;
        b=b+GHy0UdLrihvKAO5yHyLP1+R6MbnVxHk7Trk7X8bUg92MalHdoIAsgrtnrCZZ1BPM
         iEm33weOohTGgRg9K5kAssAZRLoNTpSuZZ9UgoUKWcjhmgY6irEYz8yDguC+MBOavugx
         IvzQMkSWegRySL5rl+igx05MCke3JhQNhfGf8ldrFLoWmIbVD9vHFQ+Djm5LZmm37eIu
         u4pByItwHBRAegRDt3GTvdjBm4WZMgBNZLmvCXPrjaH1KwdX9hIDIdtN+oE/yZgd/yd9
         dvaSmvcpgmToHHVyE7DpRnnHmHsZum3Es+iIboPLcSQTwUKNG8glX70BPTE6EpD5f5it
         Fm4g==
X-Gm-Message-State: AOAM5311l4YXEfTM+PGyTgfj8kwft/hhnPa4aokPJEDkLJAqCPdk4+6j
        ek9YJ94cCRol+XW6/RHaPzVrmA==
X-Google-Smtp-Source: ABdhPJykwXDDJNzKLSUmY714yiMnGq/D9M+7673ivecOYRuECp7qQrAI+7IWvJweD1ihVKXaiv4+RQ==
X-Received: by 2002:a1c:6746:: with SMTP id b67mr27003449wmc.8.1609772406139;
        Mon, 04 Jan 2021 07:00:06 -0800 (PST)
Received: from dev.cfops.net (165.176.200.146.dyn.plus.net. [146.200.176.165])
        by smtp.gmail.com with ESMTPSA id r1sm94445954wrl.95.2021.01.04.07.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 07:00:05 -0800 (PST)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org
Cc:     Ignat Korchagin <ignat@cloudflare.com>, ebiggers@kernel.org,
        Damien.LeMoal@wdc.com, mpatocka@redhat.com,
        herbert@gondor.apana.org.au, kernel-team@cloudflare.com,
        nobuto.murata@canonical.com, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org,
        mail@maciej.szmigiero.name, stable@vger.kernel.org
Subject: [PATCH v3 1/2] dm crypt: do not wait for backlogged crypto request completion in softirq
Date:   Mon,  4 Jan 2021 14:59:47 +0000
Message-Id: <20210104145948.1857-2-ignat@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210104145948.1857-1-ignat@cloudflare.com>
References: <20210104145948.1857-1-ignat@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877 made it possible for some code
paths in dm-crypt to be executed in softirq context, when the underlying driver
processes IO requests in interrupt/softirq context.

When Crypto API backlogs a crypto request, dm-crypt uses wait_for_completion to
avoid sending further requests to an already overloaded crypto driver. However,
if the code is executing in softirq context, we might get the following
stacktrace:

[  210.235213][    C0] BUG: scheduling while atomic: fio/2602/0x00000102
[  210.236701][    C0] Modules linked in:
[  210.237566][    C0] CPU: 0 PID: 2602 Comm: fio Tainted: G        W         5.10.0+ #50
[  210.239292][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[  210.241233][    C0] Call Trace:
[  210.241946][    C0]  <IRQ>
[  210.242561][    C0]  dump_stack+0x7d/0xa3
[  210.243466][    C0]  __schedule_bug.cold+0xb3/0xc2
[  210.244539][    C0]  __schedule+0x156f/0x20d0
[  210.245518][    C0]  ? io_schedule_timeout+0x140/0x140
[  210.246660][    C0]  schedule+0xd0/0x270
[  210.247541][    C0]  schedule_timeout+0x1fb/0x280
[  210.248586][    C0]  ? usleep_range+0x150/0x150
[  210.249624][    C0]  ? unpoison_range+0x3a/0x60
[  210.250632][    C0]  ? ____kasan_kmalloc.constprop.0+0x82/0xa0
[  210.251949][    C0]  ? unpoison_range+0x3a/0x60
[  210.252958][    C0]  ? __prepare_to_swait+0xa7/0x190
[  210.254067][    C0]  do_wait_for_common+0x2ab/0x370
[  210.255158][    C0]  ? usleep_range+0x150/0x150
[  210.256192][    C0]  ? bit_wait_io_timeout+0x160/0x160
[  210.257358][    C0]  ? blk_update_request+0x757/0x1150
[  210.258582][    C0]  ? _raw_spin_lock_irq+0x82/0xd0
[  210.259674][    C0]  ? _raw_read_unlock_irqrestore+0x30/0x30
[  210.260917][    C0]  wait_for_completion+0x4c/0x90
[  210.261971][    C0]  crypt_convert+0x19a6/0x4c00
[  210.263033][    C0]  ? _raw_spin_lock_irqsave+0x87/0xe0
[  210.264193][    C0]  ? kasan_set_track+0x1c/0x30
[  210.265191][    C0]  ? crypt_iv_tcw_ctr+0x4a0/0x4a0
[  210.266283][    C0]  ? kmem_cache_free+0x104/0x470
[  210.267363][    C0]  ? crypt_endio+0x91/0x180
[  210.268327][    C0]  kcryptd_crypt_read_convert+0x30e/0x420
[  210.269565][    C0]  blk_update_request+0x757/0x1150
[  210.270563][    C0]  blk_mq_end_request+0x4b/0x480
[  210.271680][    C0]  blk_done_softirq+0x21d/0x340
[  210.272775][    C0]  ? _raw_spin_lock+0x81/0xd0
[  210.273847][    C0]  ? blk_mq_stop_hw_queue+0x30/0x30
[  210.275031][    C0]  ? _raw_read_lock_irq+0x40/0x40
[  210.276182][    C0]  __do_softirq+0x190/0x611
[  210.277203][    C0]  ? handle_edge_irq+0x221/0xb60
[  210.278340][    C0]  asm_call_irq_on_stack+0x12/0x20
[  210.279514][    C0]  </IRQ>
[  210.280164][    C0]  do_softirq_own_stack+0x37/0x40
[  210.281281][    C0]  irq_exit_rcu+0x110/0x1b0
[  210.282286][    C0]  common_interrupt+0x74/0x120
[  210.283376][    C0]  asm_common_interrupt+0x1e/0x40
[  210.284496][    C0] RIP: 0010:_aesni_enc1+0x65/0xb0

Fix this by making crypt_convert function reentrant from the point of a single
bio and make dm-crypt defer further bio processing to a workqueue, if Crypto API
backlogs a request in interrupt context.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workq
ueues")
Cc: <stable@vger.kernel.org> # v5.9+

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 103 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 98 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 392337f16ecf..a3326dadfd4d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1529,13 +1529,19 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
 static blk_status_t crypt_convert(struct crypt_config *cc,
-			 struct convert_context *ctx, bool atomic)
+			 struct convert_context *ctx, bool atomic, bool reset_pending)
 {
 	unsigned int tag_offset = 0;
 	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
 	int r;
 
-	atomic_set(&ctx->cc_pending, 1);
+	/*
+	 * if reset_pending is set we are dealing with the bio for the first time,
+	 * else we're continuing to work on the previous bio, so don't mess with
+	 * the cc_pending counter
+	 */
+	if (reset_pending)
+		atomic_set(&ctx->cc_pending, 1);
 
 	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
 
@@ -1553,7 +1559,25 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 		 * but the driver request queue is full, let's wait.
 		 */
 		case -EBUSY:
-			wait_for_completion(&ctx->restart);
+			if (in_interrupt()) {
+				if (try_wait_for_completion(&ctx->restart)) {
+					/*
+					 * we don't have to block to wait for completion,
+					 * so proceed
+					 */
+				} else {
+					/*
+					 * we can't wait for completion without blocking
+					 * exit and continue processing in a workqueue
+					 */
+					ctx->r.req = NULL;
+					ctx->cc_sector += sector_step;
+					tag_offset++;
+					return BLK_STS_DEV_RESOURCE;
+				}
+			} else {
+				wait_for_completion(&ctx->restart);
+			}
 			reinit_completion(&ctx->restart);
 			fallthrough;
 		/*
@@ -1945,6 +1969,37 @@ static bool kcryptd_crypt_write_inline(struct crypt_config *cc,
 	}
 }
 
+static void kcryptd_crypt_write_continue(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	struct crypt_config *cc = io->cc;
+	struct convert_context *ctx = &io->ctx;
+	int crypt_finished;
+	sector_t sector = io->sector;
+	blk_status_t r;
+
+	wait_for_completion(&ctx->restart);
+	reinit_completion(&ctx->restart);
+
+	r = crypt_convert(cc, &io->ctx, true, false);
+	if (r)
+		io->error = r;
+	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
+	if (!crypt_finished && kcryptd_crypt_write_inline(cc, ctx)) {
+		/* Wait for completion signaled by kcryptd_async_done() */
+		wait_for_completion(&ctx->restart);
+		crypt_finished = 1;
+	}
+
+	/* Encryption was already finished, submit io now */
+	if (crypt_finished) {
+		kcryptd_crypt_write_io_submit(io, 0);
+		io->sector = sector;
+	}
+
+	crypt_dec_pending(io);
+}
+
 static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
@@ -1973,7 +2028,17 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 
 	crypt_inc_pending(io);
 	r = crypt_convert(cc, ctx,
-			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags));
+			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
+	/*
+	 * Crypto API backlogged the request, because its queue was full
+	 * and we're in softirq context, so continue from a workqueue
+	 * (TODO: is it actually possible to be in softirq in the write path?)
+	 */
+	if (r == BLK_STS_DEV_RESOURCE) {
+		INIT_WORK(&io->work, kcryptd_crypt_write_continue);
+		queue_work(cc->crypt_queue, &io->work);
+		return;
+	}
 	if (r)
 		io->error = r;
 	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
@@ -1998,6 +2063,25 @@ static void kcryptd_crypt_read_done(struct dm_crypt_io *io)
 	crypt_dec_pending(io);
 }
 
+static void kcryptd_crypt_read_continue(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	struct crypt_config *cc = io->cc;
+	blk_status_t r;
+
+	wait_for_completion(&io->ctx.restart);
+	reinit_completion(&io->ctx.restart);
+
+	r = crypt_convert(cc, &io->ctx, true, false);
+	if (r)
+		io->error = r;
+
+	if (atomic_dec_and_test(&io->ctx.cc_pending))
+		kcryptd_crypt_read_done(io);
+
+	crypt_dec_pending(io);
+}
+
 static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
@@ -2009,7 +2093,16 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 			   io->sector);
 
 	r = crypt_convert(cc, &io->ctx,
-			  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags));
+			  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags), true);
+	/*
+	 * Crypto API backlogged the request, because its queue was full
+	 * and we're in softirq context, so continue from a workqueue
+	 */
+	if (r == BLK_STS_DEV_RESOURCE) {
+		INIT_WORK(&io->work, kcryptd_crypt_read_continue);
+		queue_work(cc->crypt_queue, &io->work);
+		return;
+	}
 	if (r)
 		io->error = r;
 
-- 
2.20.1

