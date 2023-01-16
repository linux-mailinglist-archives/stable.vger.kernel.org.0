Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF3566C5F9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjAPQMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjAPQME (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:12:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607372A9B0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FBC861042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE4AC433EF;
        Mon, 16 Jan 2023 16:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885251;
        bh=eQVr0K7v0KrrhjyB9kww9irxZa79+OLbC51x8UsQ6Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NDTRX6rLRyl+RBuIH0+Qp2qlfN2aFyA8o343VTXrS4jiOJd0MQw8E4bbxVd7Gx4L
         uqte2vkqK377l7TJDH5NefheqoakqX2CSDUejEyMaEUibjamuJ0ZijyAvWDR4zKZZT
         QQy67LojyQkFXKvnVXkKIlG1HdffBwwBW8X9+It0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Angela Czubak <aczubak@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/64] octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable
Date:   Mon, 16 Jan 2023 16:51:51 +0100
Message-Id: <20230116154745.093230981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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
index 1a8f5a039d50..c0a0a31272cc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -350,9 +350,9 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 
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
index bcfc3e5f66bb..e176a6c654ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -31,7 +31,6 @@
 #define CMR_P2X_SEL_SHIFT		59ULL
 #define CMR_P2X_SEL_NIX0		1ULL
 #define CMR_P2X_SEL_NIX1		2ULL
-#define CMR_EN				BIT_ULL(55)
 #define DATA_PKT_TX_EN			BIT_ULL(53)
 #define DATA_PKT_RX_EN			BIT_ULL(54)
 #define CGX_LMAC_TYPE_SHIFT		40
-- 
2.35.1



