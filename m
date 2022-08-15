Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2841B593F7B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243341AbiHOVIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346816AbiHOVGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:06:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6FCEBC;
        Mon, 15 Aug 2022 12:15:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 244E3B81117;
        Mon, 15 Aug 2022 19:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF42C433B5;
        Mon, 15 Aug 2022 19:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590920;
        bh=LZk7gSWpaSoUsHd/k9TE2xG/PGVAIeKrKwCihr/MDmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeIDs53IdbKSgIin9lET7/04KynHYe12j5W4D0vSFJmLu11uYlXZVRxqBqiIOzNHi
         PN3nZue8av674riY8iUyifflFogCKMvaD7bqTb2tpJvqhwwqS+P7+uT+sj2Kx4rloE
         9JFT0AQkfu0iy1tH237KxoGSbFKaF6/3crUbsr3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0414/1095] drm: bridge: sii8620: fix possible off-by-one
Date:   Mon, 15 Aug 2022 19:56:53 +0200
Message-Id: <20220815180446.823025815@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 21779cc21c732c5eff8ea1624be6590450baa30f ]

The next call to sii8620_burst_get_tx_buf will result in off-by-one
When ctx->burst.tx_count + size == ARRAY_SIZE(ctx->burst.tx_buf). The same
thing happens in sii8620_burst_get_rx_buf.

This patch also change tx_count and tx_buf to rx_count and rx_buf in
sii8620_burst_get_rx_buf. It is unreasonable to check tx_buf's size and
use rx_buf.

Fixes: e19e9c692f81 ("drm/bridge/sii8620: add support for burst eMSC transmissions")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220518065856.18936-1-hbh25y@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sil-sii8620.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
index ec7745c31da0..ab0bce4a988c 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -605,7 +605,7 @@ static void *sii8620_burst_get_tx_buf(struct sii8620 *ctx, int len)
 	u8 *buf = &ctx->burst.tx_buf[ctx->burst.tx_count];
 	int size = len + 2;
 
-	if (ctx->burst.tx_count + size > ARRAY_SIZE(ctx->burst.tx_buf)) {
+	if (ctx->burst.tx_count + size >= ARRAY_SIZE(ctx->burst.tx_buf)) {
 		dev_err(ctx->dev, "TX-BLK buffer exhausted\n");
 		ctx->error = -EINVAL;
 		return NULL;
@@ -622,7 +622,7 @@ static u8 *sii8620_burst_get_rx_buf(struct sii8620 *ctx, int len)
 	u8 *buf = &ctx->burst.rx_buf[ctx->burst.rx_count];
 	int size = len + 1;
 
-	if (ctx->burst.tx_count + size > ARRAY_SIZE(ctx->burst.tx_buf)) {
+	if (ctx->burst.rx_count + size >= ARRAY_SIZE(ctx->burst.rx_buf)) {
 		dev_err(ctx->dev, "RX-BLK buffer exhausted\n");
 		ctx->error = -EINVAL;
 		return NULL;
-- 
2.35.1



