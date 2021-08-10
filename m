Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915B03E7F26
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhHJRhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233929AbhHJRgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06DFC6109E;
        Tue, 10 Aug 2021 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616926;
        bh=y2+c8XsQ8jhIs4D/0So4ptsNLxlVEF447SXCrcOBZ4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okXyuC4iNQ6ix+Fbhk15SbUfxwdBiApGisUYUmXoXpFOy9jcmsyzxnDB0+zLNrhUd
         L2rNIwuspuGXbwSusAdPUJO/XCRCnkgK0FUg09CPWxffp6aKcTKyESnTQlkbfTHB+3
         kykvBnWQ9mCBQex5uzi7CtVro2T5BC7NRaWIDiSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Borleis <jbe@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/85] dmaengine: imx-dma: configure the generic DMA type to make it work
Date:   Tue, 10 Aug 2021 19:29:52 +0200
Message-Id: <20210810172948.845655318@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Borleis <jbe@pengutronix.de>

[ Upstream commit 7199ddede9f0f2f68d41e6928e1c6c4bca9c39c0 ]

Commit dea7a9fbb009 ("dmaengine: imx-dma: remove dma_slave_config
direction usage") changes the method from a "configuration when called"
to an "configuration when used". Due to this, only the cyclic DMA type
gets configured correctly, while the generic DMA type is left
non-configured.

Without this additional call, the struct imxdma_channel::word_size member
is stuck at DMA_SLAVE_BUSWIDTH_UNDEFINED and imxdma_prep_slave_sg() always
returns NULL.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
Fixes: dea7a9fbb009 ("dmaengine: imx-dma: remove dma_slave_config direction usage")
Link: https://lore.kernel.org/r/20210729071821.9857-1-jbe@pengutronix.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 5c0fb3134825..5265182674eb 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -832,6 +832,8 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 		dma_length += sg_dma_len(sg);
 	}
 
+	imxdma_config_write(chan, &imxdmac->config, direction);
+
 	switch (imxdmac->word_size) {
 	case DMA_SLAVE_BUSWIDTH_4_BYTES:
 		if (sg_dma_len(sgl) & 3 || sgl->dma_address & 3)
-- 
2.30.2



