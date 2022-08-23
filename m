Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BAD59E0E5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354220AbiHWKYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355096AbiHWKWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:22:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D22782FBF;
        Tue, 23 Aug 2022 02:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B9B6B81C66;
        Tue, 23 Aug 2022 09:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5EBC433C1;
        Tue, 23 Aug 2022 09:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245444;
        bh=l18Qu+IXvPl5b9AOPNjTpkiodeySE+AZif4LocecDSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9jY2a/xxr4wUdJhuNTEF+887vuuBGgdyLiDPCY9H9TFTDEUMrF5+6EQK55PFRIE/
         BWMtoOzefdYlfFsoKug2epxaVw8SKrlQbw0147yF4E6VxEd4SkJyi1YsckBiViqQmL
         Jt5m4R2giH+MU6/bI+imC/0X+XO4HRWI4KZeLKO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/287] drm: bridge: sii8620: fix possible off-by-one
Date:   Tue, 23 Aug 2022 10:24:10 +0200
Message-Id: <20220823080103.001961180@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index ea433bb189ca..c72092319a53 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -607,7 +607,7 @@ static void *sii8620_burst_get_tx_buf(struct sii8620 *ctx, int len)
 	u8 *buf = &ctx->burst.tx_buf[ctx->burst.tx_count];
 	int size = len + 2;
 
-	if (ctx->burst.tx_count + size > ARRAY_SIZE(ctx->burst.tx_buf)) {
+	if (ctx->burst.tx_count + size >= ARRAY_SIZE(ctx->burst.tx_buf)) {
 		dev_err(ctx->dev, "TX-BLK buffer exhausted\n");
 		ctx->error = -EINVAL;
 		return NULL;
@@ -624,7 +624,7 @@ static u8 *sii8620_burst_get_rx_buf(struct sii8620 *ctx, int len)
 	u8 *buf = &ctx->burst.rx_buf[ctx->burst.rx_count];
 	int size = len + 1;
 
-	if (ctx->burst.tx_count + size > ARRAY_SIZE(ctx->burst.tx_buf)) {
+	if (ctx->burst.rx_count + size >= ARRAY_SIZE(ctx->burst.rx_buf)) {
 		dev_err(ctx->dev, "RX-BLK buffer exhausted\n");
 		ctx->error = -EINVAL;
 		return NULL;
-- 
2.35.1



