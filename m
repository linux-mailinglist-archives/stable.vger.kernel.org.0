Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704EE6AE94F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjCGRWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjCGRW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722F511176
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 371E0B819AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CB3C4339B;
        Tue,  7 Mar 2023 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209476;
        bh=0vf/4xoCB5Yroh12yyptQGc0RduhudslgTiiKP3ZinE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7P8d+Fwk94ZDR7Maf9bUP77ke2B6Dr0FVYK6RdAyo7EqZMF/ARc9oJTi/QQdgXnH
         w7toYv7g92Iu7qzoeeWbQmQVFP5KTD43IMKXfGN8pF/lRC0YrmJi5mYFHvR20BUbID
         g2m6g6aYI+FDT9MRv6VB91y4yU1K+/8WHS4vJrfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0232/1001] can: rcar_canfd: Fix R-Car V3U CAN mode selection
Date:   Tue,  7 Mar 2023 17:50:04 +0100
Message-Id: <20230307170031.922922274@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0a016639ef92b28eb74ba4fed21bee1f1328513a ]

When adding support for R-Car V3U, the Global FD Configuration register
(CFDGFDCFG) and the Channel-specific CAN-FD Configuration Registers
(CFDCmFDCFG) were mixed up.  Use the correct register, and apply the
selected CAN mode to all available channels.

Annotate the corresponding register bits, to make it clear they do
not exist on older variants.

Fixes: 45721c406dcf50d4 ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/388ddf312917eb9f6cc460a481f68402a876f9b5.1674499048.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index f6fa7157b99b0..88de17d0bd79d 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -197,8 +197,8 @@
 #define RCANFD_DCFG_DBRP(x)		(((x) & 0xff) << 0)
 
 /* RSCFDnCFDCmFDCFG */
-#define RCANFD_FDCFG_CLOE		BIT(30)
-#define RCANFD_FDCFG_FDOE		BIT(28)
+#define RCANFD_V3U_FDCFG_CLOE		BIT(30)
+#define RCANFD_V3U_FDCFG_FDOE		BIT(28)
 #define RCANFD_FDCFG_TDCE		BIT(9)
 #define RCANFD_FDCFG_TDCOC		BIT(8)
 #define RCANFD_FDCFG_TDCO(x)		(((x) & 0x7f) >> 16)
@@ -429,8 +429,8 @@
 #define RCANFD_C_RPGACC(r)		(0x1900 + (0x04 * (r)))
 
 /* R-Car V3U Classical and CAN FD mode specific register map */
-#define RCANFD_V3U_CFDCFG		(0x1314)
 #define RCANFD_V3U_DCFG(m)		(0x1400 + (0x20 * (m)))
+#define RCANFD_V3U_FDCFG(m)		(0x1404 + (0x20 * (m)))
 
 #define RCANFD_V3U_GAFL_OFFSET		(0x1800)
 
@@ -689,12 +689,13 @@ static void rcar_canfd_tx_failure_cleanup(struct net_device *ndev)
 static void rcar_canfd_set_mode(struct rcar_canfd_global *gpriv)
 {
 	if (is_v3u(gpriv)) {
-		if (gpriv->fdmode)
-			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_CFDCFG,
-					   RCANFD_FDCFG_FDOE);
-		else
-			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_CFDCFG,
-					   RCANFD_FDCFG_CLOE);
+		u32 ch, val = gpriv->fdmode ? RCANFD_V3U_FDCFG_FDOE
+					    : RCANFD_V3U_FDCFG_CLOE;
+
+		for_each_set_bit(ch, &gpriv->channels_mask,
+				 gpriv->info->max_channels)
+			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_FDCFG(ch),
+					   val);
 	} else {
 		if (gpriv->fdmode)
 			rcar_canfd_set_bit(gpriv->base, RCANFD_GRMCFG,
-- 
2.39.2



