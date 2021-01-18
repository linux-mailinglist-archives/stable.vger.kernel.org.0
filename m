Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2CB2FA8B5
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405539AbhARPGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390470AbhARLmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52A9022CAD;
        Mon, 18 Jan 2021 11:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970117;
        bh=1zxqlOXMuDkGR6CHmptZhoXpDMLLpArpUmCElQC67EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2RW1Oy+79NiZIDBnAz/Z0ientcpH+6IUo62KPSTzhNYnzpAqfV6Wm1YF2UKR6UH7
         AHgothFFEPKlQyLESKDZ0WSNOKNbagLniIIZU5oc5K+jPLiqj61cQlY9PgjHgI9P4j
         /4uCs+u2gpwscV3tH2BsQAQ/6HQbc3E3n751kYiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 045/152] dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq
Date:   Mon, 18 Jan 2021 12:33:40 +0100
Message-Id: <20210118113354.944646657@linuxfoundation.org>
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

commit d68b29584c25dbacd01ed44a3e45abb35353f1de upstream.

Commit 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd
workqueues") made it possible for some code paths in dm-crypt to be
executed in softirq context, when the underlying driver processes IO
requests in interrupt/softirq context.

In this case sometimes when allocating a new crypto request we may get
a stacktrace like below:

[  210.103008][    C0] BUG: sleeping function called from invalid context at mm/mempool.c:381
[  210.104746][    C0] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2602, name: fio
[  210.106599][    C0] CPU: 0 PID: 2602 Comm: fio Tainted: G        W         5.10.0+ #50
[  210.108331][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[  210.110212][    C0] Call Trace:
[  210.110921][    C0]  <IRQ>
[  210.111527][    C0]  dump_stack+0x7d/0xa3
[  210.112411][    C0]  ___might_sleep.cold+0x122/0x151
[  210.113527][    C0]  mempool_alloc+0x16b/0x2f0
[  210.114524][    C0]  ? __queue_work+0x515/0xde0
[  210.115553][    C0]  ? mempool_resize+0x700/0x700
[  210.116586][    C0]  ? crypt_endio+0x91/0x180
[  210.117479][    C0]  ? blk_update_request+0x757/0x1150
[  210.118513][    C0]  ? blk_mq_end_request+0x4b/0x480
[  210.119572][    C0]  ? blk_done_softirq+0x21d/0x340
[  210.120628][    C0]  ? __do_softirq+0x190/0x611
[  210.121626][    C0]  crypt_convert+0x29f9/0x4c00
[  210.122668][    C0]  ? _raw_spin_lock_irqsave+0x87/0xe0
[  210.123824][    C0]  ? kasan_set_track+0x1c/0x30
[  210.124858][    C0]  ? crypt_iv_tcw_ctr+0x4a0/0x4a0
[  210.125930][    C0]  ? kmem_cache_free+0x104/0x470
[  210.126973][    C0]  ? crypt_endio+0x91/0x180
[  210.127947][    C0]  kcryptd_crypt_read_convert+0x30e/0x420
[  210.129165][    C0]  blk_update_request+0x757/0x1150
[  210.130231][    C0]  blk_mq_end_request+0x4b/0x480
[  210.131294][    C0]  blk_done_softirq+0x21d/0x340
[  210.132332][    C0]  ? _raw_spin_lock+0x81/0xd0
[  210.133289][    C0]  ? blk_mq_stop_hw_queue+0x30/0x30
[  210.134399][    C0]  ? _raw_read_lock_irq+0x40/0x40
[  210.135458][    C0]  __do_softirq+0x190/0x611
[  210.136409][    C0]  ? handle_edge_irq+0x221/0xb60
[  210.137447][    C0]  asm_call_irq_on_stack+0x12/0x20
[  210.138507][    C0]  </IRQ>
[  210.139118][    C0]  do_softirq_own_stack+0x37/0x40
[  210.140191][    C0]  irq_exit_rcu+0x110/0x1b0
[  210.141151][    C0]  common_interrupt+0x74/0x120
[  210.142171][    C0]  asm_common_interrupt+0x1e/0x40

Fix this by allocating crypto requests with GFP_ATOMIC mask in
interrupt context.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1454,13 +1454,16 @@ static int crypt_convert_block_skcipher(
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error);
 
-static void crypt_alloc_req_skcipher(struct crypt_config *cc,
+static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 				     struct convert_context *ctx)
 {
 	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
 
-	if (!ctx->r.req)
-		ctx->r.req = mempool_alloc(&cc->req_pool, GFP_NOIO);
+	if (!ctx->r.req) {
+		ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
+		if (!ctx->r.req)
+			return -ENOMEM;
+	}
 
 	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
 
@@ -1471,13 +1474,18 @@ static void crypt_alloc_req_skcipher(str
 	skcipher_request_set_callback(ctx->r.req,
 	    CRYPTO_TFM_REQ_MAY_BACKLOG,
 	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
+
+	return 0;
 }
 
-static void crypt_alloc_req_aead(struct crypt_config *cc,
+static int crypt_alloc_req_aead(struct crypt_config *cc,
 				 struct convert_context *ctx)
 {
-	if (!ctx->r.req_aead)
-		ctx->r.req_aead = mempool_alloc(&cc->req_pool, GFP_NOIO);
+	if (!ctx->r.req) {
+		ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
+		if (!ctx->r.req)
+			return -ENOMEM;
+	}
 
 	aead_request_set_tfm(ctx->r.req_aead, cc->cipher_tfm.tfms_aead[0]);
 
@@ -1488,15 +1496,17 @@ static void crypt_alloc_req_aead(struct
 	aead_request_set_callback(ctx->r.req_aead,
 	    CRYPTO_TFM_REQ_MAY_BACKLOG,
 	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req_aead));
+
+	return 0;
 }
 
-static void crypt_alloc_req(struct crypt_config *cc,
+static int crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
 	if (crypt_integrity_aead(cc))
-		crypt_alloc_req_aead(cc, ctx);
+		return crypt_alloc_req_aead(cc, ctx);
 	else
-		crypt_alloc_req_skcipher(cc, ctx);
+		return crypt_alloc_req_skcipher(cc, ctx);
 }
 
 static void crypt_free_req_skcipher(struct crypt_config *cc,
@@ -1539,7 +1549,12 @@ static blk_status_t crypt_convert(struct
 
 	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
 
-		crypt_alloc_req(cc, ctx);
+		r = crypt_alloc_req(cc, ctx);
+		if (r) {
+			complete(&ctx->restart);
+			return BLK_STS_DEV_RESOURCE;
+		}
+
 		atomic_inc(&ctx->cc_pending);
 
 		if (crypt_integrity_aead(cc))


