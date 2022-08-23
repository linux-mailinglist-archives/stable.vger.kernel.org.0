Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AC659DC3C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349831AbiHWLSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357463AbiHWLRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599477FE79;
        Tue, 23 Aug 2022 02:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5E57608D5;
        Tue, 23 Aug 2022 09:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E93C433D7;
        Tue, 23 Aug 2022 09:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246458;
        bh=xhWZwq/HUtoLagsr8FhoEe1WFz99DlirWBij+9n3rrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EExflo9u+7BXW/Lha0FaP05UuW1XnYcsVYG4cwk87ocZ/idxBnQqU9SqTovayZNSb
         B5xEX8WeAVyNeexNKJzh+ZBiuzhHOaIWKOdYPJNWEM8Dd6N/nk+b0SDlWdVwJM+cY5
         Htqap8d0vBb24LUcJCJpbh/yE7j1N7/jK7Z11chY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/389] drm: bridge: sii8620: fix possible off-by-one
Date:   Tue, 23 Aug 2022 10:23:14 +0200
Message-Id: <20220823080120.461751167@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index fb0b64c965b7..970bc00d2aaf 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -604,7 +604,7 @@ static void *sii8620_burst_get_tx_buf(struct sii8620 *ctx, int len)
 	u8 *buf = &ctx->burst.tx_buf[ctx->burst.tx_count];
 	int size = len + 2;
 
-	if (ctx->burst.tx_count + size > ARRAY_SIZE(ctx->burst.tx_buf)) {
+	if (ctx->burst.tx_count + size >= ARRAY_SIZE(ctx->burst.tx_buf)) {
 		dev_err(ctx->dev, "TX-BLK buffer exhausted\n");
 		ctx->error = -EINVAL;
 		return NULL;
@@ -621,7 +621,7 @@ static u8 *sii8620_burst_get_rx_buf(struct sii8620 *ctx, int len)
 	u8 *buf = &ctx->burst.rx_buf[ctx->burst.rx_count];
 	int size = len + 1;
 
-	if (ctx->burst.tx_count + size > ARRAY_SIZE(ctx->burst.tx_buf)) {
+	if (ctx->burst.rx_count + size >= ARRAY_SIZE(ctx->burst.rx_buf)) {
 		dev_err(ctx->dev, "RX-BLK buffer exhausted\n");
 		ctx->error = -EINVAL;
 		return NULL;
-- 
2.35.1



