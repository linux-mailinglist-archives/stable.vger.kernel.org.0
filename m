Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BBF4C959E
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbiCAUPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237752AbiCAUPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:15:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7262F7562F;
        Tue,  1 Mar 2022 12:14:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D10DC61713;
        Tue,  1 Mar 2022 20:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AC7C340EE;
        Tue,  1 Mar 2022 20:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165673;
        bh=HbSeXkCCNcIiCPTKco1bU66sLMchExDVmSqGybBsPP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDFS6KKgaxylDtMgtTw+ufHMumZEX8OEasU/5PtISb+cPks2+f4EQ+aTiXjVLOLEE
         3gy4GIdoAeufsMXW2B4Uzj0JPRnULfyWh1xP7IpH4t4vYyl1T5GhpcPgCrONmXb1Si
         vjxqa6Jzq2+fBiA3+kP/KZrVw1X3KLaipDSIrunBf8EMQKdkTQb3x7IVEnR2ushYlI
         jhZPj2qxWOOSO4QXzyuxfZU26MXmt3smM1P1ZGTvPodX0JuTUKnkdAxJJb8Afucu/k
         FDX+MKgqdwiESVxk0A7J7gLUXPDJFydxKNA2jHZWd1HM1xvWWZ9IL0ZPZlhGpZBAQp
         mq0umspHMIDEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Lin <jon.lin@rock-chips.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 09/28] spi: rockchip: terminate dma transmission when slave abort
Date:   Tue,  1 Mar 2022 15:13:14 -0500
Message-Id: <20220301201344.18191-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Lin <jon.lin@rock-chips.com>

[ Upstream commit 80808768e41324d2e23de89972b5406c1020e6e4 ]

After slave abort, all DMA should be stopped, or it will affect the
next transmission and maybe abort again.

Signed-off-by: Jon Lin <jon.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20220216014028.8123-3-jon.lin@rock-chips.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 4f65ba3dd19c2..c6a1bb09be056 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -585,6 +585,12 @@ static int rockchip_spi_slave_abort(struct spi_controller *ctlr)
 {
 	struct rockchip_spi *rs = spi_controller_get_devdata(ctlr);
 
+	if (atomic_read(&rs->state) & RXDMA)
+		dmaengine_terminate_sync(ctlr->dma_rx);
+	if (atomic_read(&rs->state) & TXDMA)
+		dmaengine_terminate_sync(ctlr->dma_tx);
+	atomic_set(&rs->state, 0);
+	spi_enable_chip(rs, false);
 	rs->slave_abort = true;
 	spi_finalize_current_transfer(ctlr);
 
-- 
2.34.1

