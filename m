Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE46541C67
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382795AbiFGV7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382810AbiFGVv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E11323E820;
        Tue,  7 Jun 2022 12:09:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B49FB823AF;
        Tue,  7 Jun 2022 19:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A37AC385A5;
        Tue,  7 Jun 2022 19:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628975;
        bh=VT+orIzbW0yg3j05zWzFaQ7qL2FfDI5uldUGWuWUFPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqRb2mY85dbcEQiM6L3b+GfefJb4QfmRsdjWtAMUzCkGGmGTnofosu2PM+4xafP5O
         UGKp+9bUYlECplpAWi6jKJZt9MMQAie7Sv7QAOoOIEFpVJ3b0O/09jMljvZrbYX0K2
         Wup+bONnV8zUF3AuHlQ1z26L/YaAD5DE14yA7aJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 524/879] dpaa2-eth: use the correct software annotation field
Date:   Tue,  7 Jun 2022 19:00:42 +0200
Message-Id: <20220607165018.085635379@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit d5f4e19a85670b4e5697654f4a4e086e064f8a47 ]

The incorrect software annotation field was being used, swa->sg.sgt_size
instead of swa->tso.sgt_size, which meant that the SGT buffer was
unmapped with a wrong size.
This is also confirmed by the DMA API debug prints which showed the
following:

[   38.962434] DMA-API: fsl_dpaa2_eth dpni.2: device driver frees DMA memory with different size [device address=0x0000fffffafba740] [map size=224 bytes] [unmap size=0 bytes]
[   38.980496] WARNING: CPU: 11 PID: 1131 at kernel/dma/debug.c:973 check_unmap+0x58c/0x9b0
[   38.988586] Modules linked in:
[   38.991631] CPU: 11 PID: 1131 Comm: iperf3 Not tainted 5.18.0-rc7-00117-g59130eeb2b8f #1972
[   38.999970] Hardware name: NXP Layerscape LX2160ARDB (DT)

Fixes: 3dc709e0cd47 ("dpaa2-eth: add support for software TSO")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 766391310d1b..f1f140277184 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1148,7 +1148,7 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 						 dpaa2_sg_get_len(&sgt[i]), DMA_TO_DEVICE);
 
 			/* Unmap the SGT buffer */
-			dma_unmap_single(dev, fd_addr, swa->sg.sgt_size,
+			dma_unmap_single(dev, fd_addr, swa->tso.sgt_size,
 					 DMA_BIDIRECTIONAL);
 
 			if (!swa->tso.is_last_fd)
-- 
2.35.1



