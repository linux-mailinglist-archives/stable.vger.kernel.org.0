Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC17593980
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243965AbiHOSwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244662AbiHOSvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FF646DBD;
        Mon, 15 Aug 2022 11:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C6260F23;
        Mon, 15 Aug 2022 18:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54AFC433D7;
        Mon, 15 Aug 2022 18:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588168;
        bh=LZk7gSWpaSoUsHd/k9TE2xG/PGVAIeKrKwCihr/MDmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrJXdSSGVH9Lsoji0c8fujkuPgYPeNbVNAH/hcScH9z1rtsqDyOTDA7ng8LB2SbgZ
         sV2IeaI1Ic4ed2Lv8wzr8ocwJ1T0Swii0QIyFlD1cYKfhBLuVvrZmLH3fCqiPJsVYk
         yPnEOObvQe9LwNreY4WORUBErCghprbtrjXRUOmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/779] drm: bridge: sii8620: fix possible off-by-one
Date:   Mon, 15 Aug 2022 19:59:20 +0200
Message-Id: <20220815180350.788189441@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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



