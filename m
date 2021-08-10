Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA91A3E7FA8
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhHJRlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235687AbhHJRkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:40:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E8C7611CC;
        Tue, 10 Aug 2021 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617065;
        bh=3ihHMwQvn2DdlpJlq6E81HVnWvEcO0GnNoVmNItOAA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0y1Yci16Hvqn3ucI/bovA0+V2AivUPqtwK29hOeOAXvFqMLaLiAmiSIRr2LITLLZ
         Y+LqP3aLda8ocB1f9Ro9MfG/Glv2ydXGP9+Q6sMq1tkb5AX9JkYt2fn0rmVBdxkBwY
         4TqKbqh+G4OM4Uv/wfQGx9IwroOf04yVMGrkLy8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Borleis <jbe@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/135] dmaengine: imx-dma: configure the generic DMA type to make it work
Date:   Tue, 10 Aug 2021 19:29:23 +0200
Message-Id: <20210810172956.662322349@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
index 670db04b0757..52e361ed43e3 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -831,6 +831,8 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 		dma_length += sg_dma_len(sg);
 	}
 
+	imxdma_config_write(chan, &imxdmac->config, direction);
+
 	switch (imxdmac->word_size) {
 	case DMA_SLAVE_BUSWIDTH_4_BYTES:
 		if (sg_dma_len(sgl) & 3 || sgl->dma_address & 3)
-- 
2.30.2



