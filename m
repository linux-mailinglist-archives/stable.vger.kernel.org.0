Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54A59A120
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351500AbiHSQPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351590AbiHSQOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:14:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574E42AC72;
        Fri, 19 Aug 2022 08:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D572616B3;
        Fri, 19 Aug 2022 15:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143ABC433C1;
        Fri, 19 Aug 2022 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924681;
        bh=rLnha+yGvCixSUaSx40UzLgLQJ7eMXQtpPXkNkmbCFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBr7WaH1ynl+pPkz/1J9DsiOzsWJMvMz5YkxJ9/x+zO6bpZsf16esxjONtIPfOoqW
         mhLlbQjnnsnjCX3Eoust7h2Rro+9eg4jCacrI9AyNes8wLn1tIMtHkIvUFEyjxQejE
         Xsh3/Hzpvd/f4+FdJ5J5VQWMndFZF3rNNjXspdsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/545] crypto: hisilicon/sec - dont sleep when in softirq
Date:   Fri, 19 Aug 2022 17:39:49 +0200
Message-Id: <20220819153839.158717004@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 02884a4f12de11f54d4ca67a07dd1f111d96fdbd ]

When kunpeng920 encryption driver is used to deencrypt and decrypt
packets during the softirq, it is not allowed to use mutex lock. The
kernel will report the following error:

BUG: scheduling while atomic: swapper/57/0/0x00000300
Call trace:
dump_backtrace+0x0/0x1e4
show_stack+0x20/0x2c
dump_stack+0xd8/0x140
__schedule_bug+0x68/0x80
__schedule+0x728/0x840
schedule+0x50/0xe0
schedule_preempt_disabled+0x18/0x24
__mutex_lock.constprop.0+0x594/0x5dc
__mutex_lock_slowpath+0x1c/0x30
mutex_lock+0x50/0x60
sec_request_init+0x8c/0x1a0 [hisi_sec2]
sec_process+0x28/0x1ac [hisi_sec2]
sec_skcipher_crypto+0xf4/0x1d4 [hisi_sec2]
sec_skcipher_encrypt+0x1c/0x30 [hisi_sec2]
crypto_skcipher_encrypt+0x2c/0x40
crypto_authenc_encrypt+0xc8/0xfc [authenc]
crypto_aead_encrypt+0x2c/0x40
echainiv_encrypt+0x144/0x1a0 [echainiv]
crypto_aead_encrypt+0x2c/0x40
esp_output_tail+0x348/0x5c0 [esp4]
esp_output+0x120/0x19c [esp4]
xfrm_output_one+0x25c/0x4d4
xfrm_output_resume+0x6c/0x1fc
xfrm_output+0xac/0x3c0
xfrm4_output+0x64/0x130
ip_build_and_send_pkt+0x158/0x20c
tcp_v4_send_synack+0xdc/0x1f0
tcp_conn_request+0x7d0/0x994
tcp_v4_conn_request+0x58/0x6c
tcp_v6_conn_request+0xf0/0x100
tcp_rcv_state_process+0x1cc/0xd60
tcp_v4_do_rcv+0x10c/0x250
tcp_v4_rcv+0xfc4/0x10a4
ip_protocol_deliver_rcu+0xf4/0x200
ip_local_deliver_finish+0x58/0x70
ip_local_deliver+0x68/0x120
ip_sublist_rcv_finish+0x70/0x94
ip_list_rcv_finish.constprop.0+0x17c/0x1d0
ip_sublist_rcv+0x40/0xb0
ip_list_rcv+0x140/0x1dc
__netif_receive_skb_list_core+0x154/0x28c
__netif_receive_skb_list+0x120/0x1a0
netif_receive_skb_list_internal+0xe4/0x1f0
napi_complete_done+0x70/0x1f0
gro_cell_poll+0x9c/0xb0
napi_poll+0xcc/0x264
net_rx_action+0xd4/0x21c
__do_softirq+0x130/0x358
irq_exit+0x11c/0x13c
__handle_domain_irq+0x88/0xf0
gic_handle_irq+0x78/0x2c0
el1_irq+0xb8/0x140
arch_cpu_idle+0x18/0x40
default_idle_call+0x5c/0x1c0
cpuidle_idle_call+0x174/0x1b0
do_idle+0xc8/0x160
cpu_startup_entry+0x30/0x11c
secondary_start_kernel+0x158/0x1e4
softirq: huh, entered softirq 3 NET_RX 0000000093774ee4 with
preempt_count 00000100, exited with fffffe00?

Fixes: 416d82204df4 ("crypto: hisilicon - add HiSilicon SEC V2 driver")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 5c35043f980f..249735b7ceca 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -103,7 +103,7 @@ struct sec_qp_ctx {
 	struct idr req_idr;
 	struct sec_alg_res res[QM_Q_DEPTH];
 	struct sec_ctx *ctx;
-	struct mutex req_lock;
+	spinlock_t req_lock;
 	struct list_head backlog;
 	struct hisi_acc_sgl_pool *c_in_pool;
 	struct hisi_acc_sgl_pool *c_out_pool;
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 0b674a771ee0..39d2af84d953 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -88,11 +88,11 @@ static int sec_alloc_req_id(struct sec_req *req, struct sec_qp_ctx *qp_ctx)
 {
 	int req_id;
 
-	mutex_lock(&qp_ctx->req_lock);
+	spin_lock_bh(&qp_ctx->req_lock);
 
 	req_id = idr_alloc_cyclic(&qp_ctx->req_idr, NULL,
 				  0, QM_Q_DEPTH, GFP_ATOMIC);
-	mutex_unlock(&qp_ctx->req_lock);
+	spin_unlock_bh(&qp_ctx->req_lock);
 	if (unlikely(req_id < 0)) {
 		dev_err(req->ctx->dev, "alloc req id fail!\n");
 		return req_id;
@@ -116,9 +116,9 @@ static void sec_free_req_id(struct sec_req *req)
 	qp_ctx->req_list[req_id] = NULL;
 	req->qp_ctx = NULL;
 
-	mutex_lock(&qp_ctx->req_lock);
+	spin_lock_bh(&qp_ctx->req_lock);
 	idr_remove(&qp_ctx->req_idr, req_id);
-	mutex_unlock(&qp_ctx->req_lock);
+	spin_unlock_bh(&qp_ctx->req_lock);
 }
 
 static int sec_aead_verify(struct sec_req *req)
@@ -201,7 +201,7 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 	    !(req->flag & CRYPTO_TFM_REQ_MAY_BACKLOG))
 		return -EBUSY;
 
-	mutex_lock(&qp_ctx->req_lock);
+	spin_lock_bh(&qp_ctx->req_lock);
 	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
 
 	if (ctx->fake_req_limit <=
@@ -209,10 +209,10 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 		list_add_tail(&req->backlog_head, &qp_ctx->backlog);
 		atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
 		atomic64_inc(&ctx->sec->debug.dfx.send_busy_cnt);
-		mutex_unlock(&qp_ctx->req_lock);
+		spin_unlock_bh(&qp_ctx->req_lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&qp_ctx->req_lock);
+	spin_unlock_bh(&qp_ctx->req_lock);
 
 	if (unlikely(ret == -EBUSY))
 		return -ENOBUFS;
@@ -382,7 +382,7 @@ static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 	qp_ctx->qp = qp;
 	qp_ctx->ctx = ctx;
 
-	mutex_init(&qp_ctx->req_lock);
+	spin_lock_init(&qp_ctx->req_lock);
 	idr_init(&qp_ctx->req_idr);
 	INIT_LIST_HEAD(&qp_ctx->backlog);
 
@@ -1067,7 +1067,7 @@ static struct sec_req *sec_back_req_clear(struct sec_ctx *ctx,
 {
 	struct sec_req *backlog_req = NULL;
 
-	mutex_lock(&qp_ctx->req_lock);
+	spin_lock_bh(&qp_ctx->req_lock);
 	if (ctx->fake_req_limit >=
 	    atomic_read(&qp_ctx->qp->qp_status.used) &&
 	    !list_empty(&qp_ctx->backlog)) {
@@ -1075,7 +1075,7 @@ static struct sec_req *sec_back_req_clear(struct sec_ctx *ctx,
 				typeof(*backlog_req), backlog_head);
 		list_del(&backlog_req->backlog_head);
 	}
-	mutex_unlock(&qp_ctx->req_lock);
+	spin_unlock_bh(&qp_ctx->req_lock);
 
 	return backlog_req;
 }
-- 
2.35.1



