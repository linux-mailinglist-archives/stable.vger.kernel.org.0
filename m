Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72965F299E
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJCHWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiJCHVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:21:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C6491F9;
        Mon,  3 Oct 2022 00:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFB9460FA6;
        Mon,  3 Oct 2022 07:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB100C433C1;
        Mon,  3 Oct 2022 07:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781365;
        bh=xRgycX1bdiD+Sa4ok5E1KEC3e5KRtZ1KznvcL7hwnVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jbb4B2TZYQDs2KQI1MeC2nfhismuh0tMRY5tDNa91g5KSrZxTGws52nfIBOYjU3TM
         C0XZrOOz23bueCEUSj/9iNkQRz9nxoLpVT46Yz+yGqIEHUv/Eh+FLbTM9lFo8/y3kl
         b8v5NN47piLe3MTVv4hswDHdGJKyUSgeSFWRt8fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Minqiang <ptpt52@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 095/101] net: ethernet: mtk_eth_soc: fix mask of RX_DMA_GET_SPORT{,_V2}
Date:   Mon,  3 Oct 2022 09:11:31 +0200
Message-Id: <20221003070726.797595336@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit c9da02bfb1112461e048d3b736afb1873f6f4ccf ]

The bitmasks applied in RX_DMA_GET_SPORT and RX_DMA_GET_SPORT_V2 macros
were swapped. Fix that.

Reported-by: Chen Minqiang <ptpt52@gmail.com>
Fixes: 160d3a9b192985 ("net: ethernet: mtk_eth_soc: introduce MTK_NETSYS_V2 support")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/YzMW+mg9UsaCdKRQ@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 98d6a6d047e3..c1fe1a2cb746 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -312,8 +312,8 @@
 #define MTK_RXD5_PPE_CPU_REASON	GENMASK(22, 18)
 #define MTK_RXD5_SRC_PORT	GENMASK(29, 26)
 
-#define RX_DMA_GET_SPORT(x)	(((x) >> 19) & 0xf)
-#define RX_DMA_GET_SPORT_V2(x)	(((x) >> 26) & 0x7)
+#define RX_DMA_GET_SPORT(x)	(((x) >> 19) & 0x7)
+#define RX_DMA_GET_SPORT_V2(x)	(((x) >> 26) & 0xf)
 
 /* PDMA V2 descriptor rxd3 */
 #define RX_DMA_VTAG_V2		BIT(0)
-- 
2.35.1



