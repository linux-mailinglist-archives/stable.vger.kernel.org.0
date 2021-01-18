Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5CB2FA41E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405548AbhARPG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727847AbhARLmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE8822D2C;
        Mon, 18 Jan 2021 11:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970120;
        bh=zeq8z47kOVgOkA3FkV6tmJId5VpkQjTL1pIuLGIf2s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwcI9z9nRI+hutMzY/S2Iw3TEYeKikaWY9OtL2xDTy3b6u+PYpFDyn3hHHGo6/hS1
         CJXST9lP68BaqfCt1cDusxe/DjgGZjqDgYN99/oHLTwx56MXBtQ+YbwKz+wBVNVFy+
         izuDI0Bd6y3DbvfXmTwOVDTA9ppyNB0MN6fPIK+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ignat Korchagin <ignat@cloudflare.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 046/152] dm crypt: do not wait for backlogged crypto request completion in softirq
Date:   Mon, 18 Jan 2021 12:33:41 +0100
Message-Id: <20210118113354.993433198@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ignat Korchagin <ignat@cloudflare.com>

commit 8abec36d1274bbd5ae8f36f3658b9abb3db56c31 upstream.

Commit 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd
workqueues") made it possible for some code paths in dm-crypt to be
executed in softirq context, when the underlying driver processes IO
requests in interrupt/softirq context.

When Crypto API backlogs a crypto request, dm-crypt uses
wait_for_completion to avoid sending further requests to an already
overloaded crypto driver. However, if the code is executing in softirq
context, we might get the following stacktrace:

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

Fix this by making crypt_convert function reentrant from the point of
a single bio and make dm-crypt defer further bio processing to a
workqueue, if Crypto API backlogs a request in interrupt context.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 98 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1539,13 +1539,19 @@ static void crypt_free_req(struct crypt_
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
 
@@ -1568,7 +1574,25 @@ static blk_status_t crypt_convert(struct
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
@@ -1960,6 +1984,37 @@ static bool kcryptd_crypt_write_inline(s
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
@@ -1988,7 +2043,17 @@ static void kcryptd_crypt_write_convert(
 
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
@@ -2013,6 +2078,25 @@ static void kcryptd_crypt_read_done(stru
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
@@ -2024,7 +2108,16 @@ static void kcryptd_crypt_read_convert(s
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
 


