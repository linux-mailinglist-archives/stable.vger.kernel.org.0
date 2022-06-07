Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43613541C68
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376927AbiFGV7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382793AbiFGVvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB8623E82B;
        Tue,  7 Jun 2022 12:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 474F3B81F6D;
        Tue,  7 Jun 2022 19:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8213C3411C;
        Tue,  7 Jun 2022 19:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628973;
        bh=3WkLGgrPgXyt6niNQshuTYXlUyoQOPiPks9fVvqPlt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5SwWJcSkBfxuJyijW4LCgLX3Zs5bSVuPyl4QL/opX0QWlsYp/aDYP4RuEa9VoGQt
         x1yyDXu8zYTPl5Ve2n5+8oPClnUnKDLrkOudRtygMLqfbBMFL0cIoi/N2tOS1aR/Nk
         j+BmiQsMjOUsOWNmx8x9aNWYd/dcg8NwzfbE031k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 523/879] dpaa2-eth: retrieve the virtual address before dma_unmap
Date:   Tue,  7 Jun 2022 19:00:41 +0200
Message-Id: <20220607165018.057656305@linuxfoundation.org>
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

[ Upstream commit 06d129946a71f3159b3b40ee95549183edf2c79d ]

The TSO header was DMA unmapped before the virtual address was retrieved
and then used to free the buffer. This meant that we were actually
removing the DMA map and then trying to search for it to help in
retrieving the virtual address. This lead to a invalid virtual address
being used in the kfree call.

Fix this by calling dpaa2_iova_to_virt() prior to the dma_unmap call.

[  487.231819] Unable to handle kernel paging request at virtual address fffffd9807000008

(...)

[  487.354061] Hardware name: SolidRun LX2160A Honeycomb (DT)
[  487.359535] pstate: a0400005 (NzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  487.366485] pc : kfree+0xac/0x304
[  487.369799] lr : kfree+0x204/0x304
[  487.373191] sp : ffff80000c4eb120
[  487.376493] x29: ffff80000c4eb120 x28: ffff662240c46400 x27: 0000000000000001
[  487.383621] x26: 0000000000000001 x25: ffff662246da0cc0 x24: ffff66224af78000
[  487.390748] x23: ffffad184f4ce008 x22: ffffad1850185000 x21: ffffad1838d13cec
[  487.397874] x20: ffff6601c0000000 x19: fffffd9807000000 x18: 0000000000000000
[  487.405000] x17: ffffb910cdc49000 x16: ffffad184d7d9080 x15: 0000000000004000
[  487.412126] x14: 0000000000000008 x13: 000000000000ffff x12: 0000000000000000
[  487.419252] x11: 0000000000000004 x10: 0000000000000001 x9 : ffffad184d7d927c
[  487.426379] x8 : 0000000000000000 x7 : 0000000ffffffd1d x6 : ffff662240a94900
[  487.433505] x5 : 0000000000000003 x4 : 0000000000000009 x3 : ffffad184f4ce008
[  487.440632] x2 : ffff662243eec000 x1 : 0000000100000100 x0 : fffffc0000000000
[  487.447758] Call trace:
[  487.450194]  kfree+0xac/0x304
[  487.453151]  dpaa2_eth_free_tx_fd.isra.0+0x33c/0x3e0 [fsl_dpaa2_eth]
[  487.459507]  dpaa2_eth_tx_conf+0x100/0x2e0 [fsl_dpaa2_eth]
[  487.464989]  dpaa2_eth_poll+0xdc/0x380 [fsl_dpaa2_eth]

Fixes: 3dc709e0cd47 ("dpaa2-eth: add support for software TSO")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215886
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 4b047255d928..766391310d1b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1097,6 +1097,7 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 	u32 fd_len = dpaa2_fd_get_len(fd);
 	struct dpaa2_sg_entry *sgt;
 	int should_free_skb = 1;
+	void *tso_hdr;
 	int i;
 
 	fd_addr = dpaa2_fd_get_addr(fd);
@@ -1136,9 +1137,10 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 							priv->tx_data_offset);
 
 			/* Unmap and free the header */
+			tso_hdr = dpaa2_iova_to_virt(priv->iommu_domain, dpaa2_sg_get_addr(sgt));
 			dma_unmap_single(dev, dpaa2_sg_get_addr(sgt), TSO_HEADER_SIZE,
 					 DMA_TO_DEVICE);
-			kfree(dpaa2_iova_to_virt(priv->iommu_domain, dpaa2_sg_get_addr(sgt)));
+			kfree(tso_hdr);
 
 			/* Unmap the other SG entries for the data */
 			for (i = 1; i < swa->tso.num_sg; i++)
-- 
2.35.1



