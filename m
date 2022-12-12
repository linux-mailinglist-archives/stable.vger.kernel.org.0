Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2BA64A199
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiLLNnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiLLNms (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:42:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B58614D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:41:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE148B80D4F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9A3C433D2;
        Mon, 12 Dec 2022 13:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852492;
        bh=UlQIcF4anpMd3SXMOJR9lMJ5nuI4m1Q6Q73lBoy8zfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Cfm8HJoDuznTsiyzr4hBNxlkxmlx0xLJ9BkxV2h9hV7kpPgE8+3FxHHhQI3DPy08
         G7AUtucmNM2lW0oGHTMTGv7xaeoHUuSThL8qBdhquRwgZqISvW6Rj6JwFrfqJTTIma
         xUQVgOVDeq6Hivm002M5QxfuK+C/cRTi4/Vh3KZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haiyang Zhang <haiyangz@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.0 065/157] net: mana: Fix race on per-CQ variable napi work_done
Date:   Mon, 12 Dec 2022 14:16:53 +0100
Message-Id: <20221212130937.188521672@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 18010ff776fa42340efc428b3ea6d19b3e7c7b21 upstream.

After calling napi_complete_done(), the NAPIF_STATE_SCHED bit may be
cleared, and another CPU can start napi thread and access per-CQ variable,
cq->work_done. If the other thread (for example, from busy_poll) sets
it to a value >= budget, this thread will continue to run when it should
stop, and cause memory corruption and panic.

To fix this issue, save the per-CQ work_done variable in a local variable
before napi_complete_done(), so it won't be corrupted by a possible
concurrent thread after napi_complete_done().

Also, add a flag bit to advertise to the NIC firmware: the NAPI work_done
variable race is fixed, so the driver is able to reliably support features
like busy_poll.

Cc: stable@vger.kernel.org
Fixes: e1b5683ff62e ("net: mana: Move NAPI from EQ to CQ")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/1670010190-28595-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/gdma.h    |    9 ++++++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c |   16 +++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -498,7 +498,14 @@ enum {
 
 #define GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT BIT(0)
 
-#define GDMA_DRV_CAP_FLAGS1 GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT
+/* Advertise to the NIC firmware: the NAPI work_done variable race is fixed,
+ * so the driver is able to reliably support features like busy_poll.
+ */
+#define GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX BIT(2)
+
+#define GDMA_DRV_CAP_FLAGS1 \
+	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
+	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1303,10 +1303,11 @@ static void mana_poll_rx_cq(struct mana_
 		xdp_do_flush();
 }
 
-static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
+static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
 	u8 arm_bit;
+	int w;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
 
@@ -1315,26 +1316,31 @@ static void mana_cq_handler(void *contex
 	else
 		mana_poll_tx_cq(cq);
 
-	if (cq->work_done < cq->budget &&
-	    napi_complete_done(&cq->napi, cq->work_done)) {
+	w = cq->work_done;
+
+	if (w < cq->budget &&
+	    napi_complete_done(&cq->napi, w)) {
 		arm_bit = SET_ARM_BIT;
 	} else {
 		arm_bit = 0;
 	}
 
 	mana_gd_ring_cq(gdma_queue, arm_bit);
+
+	return w;
 }
 
 static int mana_poll(struct napi_struct *napi, int budget)
 {
 	struct mana_cq *cq = container_of(napi, struct mana_cq, napi);
+	int w;
 
 	cq->work_done = 0;
 	cq->budget = budget;
 
-	mana_cq_handler(cq, cq->gdma_cq);
+	w = mana_cq_handler(cq, cq->gdma_cq);
 
-	return min(cq->work_done, budget);
+	return min(w, budget);
 }
 
 static void mana_schedule_napi(void *context, struct gdma_queue *gdma_queue)


