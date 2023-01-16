Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5833A66C572
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjAPQGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjAPQFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:05:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC47B279B2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CDF761047
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CF4C433D2;
        Mon, 16 Jan 2023 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885044;
        bh=HhZ9+tqs7ktiVVN2M3IDau8hFHZy5p/CbaXeroKkM7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CK0XgZQjdg0YgTTjfmqkPBWp6fWcs5rzThONyglFnJPjBriVh0Zy1grQiHxbAa0rT
         Rj+x3y0aZYNYne40dlc1onMAsvnKT2s19N8d8RiAKXFanY6Kk77gFAxdq3So3Y0X1I
         3eFQUnhr1f9OykJyJ4QeKCA+78UZ7zaEa8LMSD94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Angela Czubak <aczubak@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 53/86] octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable
Date:   Mon, 16 Jan 2023 16:51:27 +0100
Message-Id: <20230116154749.263103155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Angela Czubak <aczubak@marvell.com>

[ Upstream commit b4e9b8763e417db31c7088103cc557d55cb7a8f5 ]

PF netdev can request AF to enable or disable reception and transmission
on assigned CGX::LMAC. The current code instead of disabling or enabling
'reception and transmission' also disables/enable the LMAC. This patch
fixes this issue.

Fixes: 1435f66a28b4 ("octeontx2-af: CGX Rx/Tx enable/disable mbox handlers")
Signed-off-by: Angela Czubak <aczubak@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230105160107.17638-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 6b335139abe7..fd0a31bf94fe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -695,9 +695,9 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
 	if (enable)
-		cfg |= CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN;
+		cfg |= DATA_PKT_RX_EN | DATA_PKT_TX_EN;
 	else
-		cfg &= ~(CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN);
+		cfg &= ~(DATA_PKT_RX_EN | DATA_PKT_TX_EN);
 	cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index ab1e4abdea38..5714280a4252 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -30,7 +30,6 @@
 #define CMR_P2X_SEL_SHIFT		59ULL
 #define CMR_P2X_SEL_NIX0		1ULL
 #define CMR_P2X_SEL_NIX1		2ULL
-#define CMR_EN				BIT_ULL(55)
 #define DATA_PKT_TX_EN			BIT_ULL(53)
 #define DATA_PKT_RX_EN			BIT_ULL(54)
 #define CGX_LMAC_TYPE_SHIFT		40
-- 
2.35.1



