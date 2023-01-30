Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C832680F75
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbjA3Nx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjA3Nxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:53:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BE21EFE2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:53:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DF2A61026
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796BDC4339B;
        Mon, 30 Jan 2023 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086832;
        bh=ZzJRYHJfZyGBwy3PU925A2YpXBMtYEX2hVJ9+bHgeJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRyZMpmKnnLOWtITi5uuvViki7NWqxDUPNa9rqVEc/ItJKk2yohZ9eoTppBleLNaW
         VcOOdrI4d/BWUyvGrHwF2mtJV5SP5CWeXmezTUE9frnhwNNbOZJ+A8VzZmoUUZu6Hl
         EppNBYjS/lbVVBbcTLSBkdajaBIrp8DNWElA0ex0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/313] dmaengine: qcom: gpi: Set link_rx bit on GO TRE for rx operation
Date:   Mon, 30 Jan 2023 14:47:20 +0100
Message-Id: <20230130134336.894777436@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>

[ Upstream commit 25e8ac233d24051e2c4ff64c34f60609b0988568 ]

Rx operation on SPI GSI DMA is currently not working.
As per GSI spec, link_rx bit is to be set on GO TRE on tx
channel whenever there is going to be a DMA TRE on rx
channel. This is currently set for duplex operation only.

Set the bit for rx operation as well.
This is part of changes required to bring up Rx.

Fixes: 94b8f0e58fa1 ("dmaengine: qcom: gpi: set chain and link flag for duplex")
Signed-off-by: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/1671212293-14767-1-git-send-email-quic_vnivarth@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/gpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/qcom/gpi.c b/drivers/dma/qcom/gpi.c
index 3f56514bbef8..98d45ee4b4e3 100644
--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -1756,6 +1756,7 @@ static int gpi_create_spi_tre(struct gchan *chan, struct gpi_desc *desc,
 		tre->dword[3] = u32_encode_bits(TRE_TYPE_GO, TRE_FLAGS_TYPE);
 		if (spi->cmd == SPI_RX) {
 			tre->dword[3] |= u32_encode_bits(1, TRE_FLAGS_IEOB);
+			tre->dword[3] |= u32_encode_bits(1, TRE_FLAGS_LINK);
 		} else if (spi->cmd == SPI_TX) {
 			tre->dword[3] |= u32_encode_bits(1, TRE_FLAGS_CHAIN);
 		} else { /* SPI_DUPLEX */
-- 
2.39.0



