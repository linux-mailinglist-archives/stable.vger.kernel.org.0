Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08DA541A69
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379657AbiFGVc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380896AbiFGVb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D9622C44E;
        Tue,  7 Jun 2022 12:03:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F35C361807;
        Tue,  7 Jun 2022 19:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F148DC385A2;
        Tue,  7 Jun 2022 19:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628614;
        bh=ssLUR9TMlXPnR/sh14pMpOkCbowaveB5CZIUS3pgNww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtifdpmWNj054GHNfLQ5Tna7+xOLlt1qySkb4XCkWtGYbyoy2auYL08WkqOYA7XDZ
         9fzuEA/M7FilZfM+VJpp43HL+QH3psZB04pXmxVNuTJP3epHlR+6wvfJcn6+Bnsnj8
         R+pKG3LwJMKqaHk8ZtL2JSIQbSJbVoJmswp942RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 393/879] wl1251: dynamically allocate memory used for DMA
Date:   Tue,  7 Jun 2022 18:58:31 +0200
Message-Id: <20220607165014.271765130@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit 454744754cbf2c21b3fc7344e46e10bee2768094 ]

With introduction of vmap'ed stacks, stack parameters can no
longer be used for DMA and now leads to kernel panic.

It happens at several places for the wl1251 (e.g. when
accessed through SDIO) making it unuseable on e.g. the
OpenPandora.

We solve this by allocating temporary buffers or use wl1251_read32().

Tested on v5.18-rc5 with OpenPandora.

Fixes: a1c510d0adc6 ("ARM: implement support for vmap'ed stacks")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/event.c | 22 ++++++++++++++--------
 drivers/net/wireless/ti/wl1251/io.c    | 20 ++++++++++++++------
 drivers/net/wireless/ti/wl1251/tx.c    | 15 +++++++++++----
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index e6d426edab56..e945aafd88ee 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -169,11 +169,9 @@ int wl1251_event_wait(struct wl1251 *wl, u32 mask, int timeout_ms)
 		msleep(1);
 
 		/* read from both event fields */
-		wl1251_mem_read(wl, wl->mbox_ptr[0], &events_vector,
-				sizeof(events_vector));
+		events_vector = wl1251_mem_read32(wl, wl->mbox_ptr[0]);
 		event = events_vector & mask;
-		wl1251_mem_read(wl, wl->mbox_ptr[1], &events_vector,
-				sizeof(events_vector));
+		events_vector = wl1251_mem_read32(wl, wl->mbox_ptr[1]);
 		event |= events_vector & mask;
 	} while (!event);
 
@@ -202,7 +200,7 @@ void wl1251_event_mbox_config(struct wl1251 *wl)
 
 int wl1251_event_handle(struct wl1251 *wl, u8 mbox_num)
 {
-	struct event_mailbox mbox;
+	struct event_mailbox *mbox;
 	int ret;
 
 	wl1251_debug(DEBUG_EVENT, "EVENT on mbox %d", mbox_num);
@@ -210,12 +208,20 @@ int wl1251_event_handle(struct wl1251 *wl, u8 mbox_num)
 	if (mbox_num > 1)
 		return -EINVAL;
 
+	mbox = kmalloc(sizeof(*mbox), GFP_KERNEL);
+	if (!mbox) {
+		wl1251_error("can not allocate mbox buffer");
+		return -ENOMEM;
+	}
+
 	/* first we read the mbox descriptor */
-	wl1251_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
-			    sizeof(struct event_mailbox));
+	wl1251_mem_read(wl, wl->mbox_ptr[mbox_num], mbox,
+			sizeof(*mbox));
 
 	/* process the descriptor */
-	ret = wl1251_event_process(wl, &mbox);
+	ret = wl1251_event_process(wl, mbox);
+	kfree(mbox);
+
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/ti/wl1251/io.c b/drivers/net/wireless/ti/wl1251/io.c
index 5ebe7958ed5c..e8d567af74b4 100644
--- a/drivers/net/wireless/ti/wl1251/io.c
+++ b/drivers/net/wireless/ti/wl1251/io.c
@@ -121,7 +121,13 @@ void wl1251_set_partition(struct wl1251 *wl,
 			  u32 mem_start, u32 mem_size,
 			  u32 reg_start, u32 reg_size)
 {
-	struct wl1251_partition partition[2];
+	struct wl1251_partition_set *partition;
+
+	partition = kmalloc(sizeof(*partition), GFP_KERNEL);
+	if (!partition) {
+		wl1251_error("can not allocate partition buffer");
+		return;
+	}
 
 	wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
 		     mem_start, mem_size);
@@ -164,10 +170,10 @@ void wl1251_set_partition(struct wl1251 *wl,
 			     reg_start, reg_size);
 	}
 
-	partition[0].start = mem_start;
-	partition[0].size  = mem_size;
-	partition[1].start = reg_start;
-	partition[1].size  = reg_size;
+	partition->mem.start = mem_start;
+	partition->mem.size  = mem_size;
+	partition->reg.start = reg_start;
+	partition->reg.size  = reg_size;
 
 	wl->physical_mem_addr = mem_start;
 	wl->physical_reg_addr = reg_start;
@@ -176,5 +182,7 @@ void wl1251_set_partition(struct wl1251 *wl,
 	wl->virtual_reg_addr = mem_size;
 
 	wl->if_ops->write(wl, HW_ACCESS_PART0_SIZE_ADDR, partition,
-		sizeof(partition));
+		sizeof(*partition));
+
+	kfree(partition);
 }
diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 98cd39619d57..e9dc3c72bb11 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -443,19 +443,25 @@ static void wl1251_tx_packet_cb(struct wl1251 *wl,
 void wl1251_tx_complete(struct wl1251 *wl)
 {
 	int i, result_index, num_complete = 0, queue_len;
-	struct tx_result result[FW_TX_CMPLT_BLOCK_SIZE], *result_ptr;
+	struct tx_result *result, *result_ptr;
 	unsigned long flags;
 
 	if (unlikely(wl->state != WL1251_STATE_ON))
 		return;
 
+	result = kmalloc_array(FW_TX_CMPLT_BLOCK_SIZE, sizeof(*result), GFP_KERNEL);
+	if (!result) {
+		wl1251_error("can not allocate result buffer");
+		return;
+	}
+
 	/* First we read the result */
-	wl1251_mem_read(wl, wl->data_path->tx_complete_addr,
-			    result, sizeof(result));
+	wl1251_mem_read(wl, wl->data_path->tx_complete_addr, result,
+			FW_TX_CMPLT_BLOCK_SIZE * sizeof(*result));
 
 	result_index = wl->next_tx_complete;
 
-	for (i = 0; i < ARRAY_SIZE(result); i++) {
+	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++) {
 		result_ptr = &result[result_index];
 
 		if (result_ptr->done_1 == 1 &&
@@ -538,6 +544,7 @@ void wl1251_tx_complete(struct wl1251 *wl)
 
 	}
 
+	kfree(result);
 	wl->next_tx_complete = result_index;
 }
 
-- 
2.35.1



