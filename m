Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A38537FF3
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbiE3OJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240135AbiE3OGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:06:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9383B2BF;
        Mon, 30 May 2022 06:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9407460F9E;
        Mon, 30 May 2022 13:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A9BC3411E;
        Mon, 30 May 2022 13:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918120;
        bh=63KEk9VLTggDHYa7uCWhw1ThCahBRf68liu0x9+Y4Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTcW2MYvIkbIbrzn/OE2PDUCuW3r3PB2V0fSjrYachInBVGD695908LeEbx1X/c1v
         RIjTN/XRGQLJDs8zr+jm0OGr7C3rL4UO5lEMNKd8Oudd7OIzlckkPXKIB6xogxAwxU
         QlqIVImJ3wxbHn5MGu9bmuiyivq6K9YvdscAxV1a63JyLychr8SvBZz3piV4DTVOcH
         Cvrn4vYOR+xoyy4D9cNQHmyvGUONbuYJ6LC1iP/tIIWxLOWH51O7bbE43ob98t124K
         aRuwNrBQXF4ir9BBVbmPTnn82tsejVOTmZ28yjkkC60E3rI9Kq+e1DhVdDsjrTM6CS
         lHZscwjPDH9JA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrice Chotard <patrice.chotard@foss.st.com>,
        eberhard.stoll@kontron.de, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, linux-spi@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 068/109] spi: stm32-qspi: Fix wait_cmd timeout in APM mode
Date:   Mon, 30 May 2022 09:37:44 -0400
Message-Id: <20220530133825.1933431-68-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

[ Upstream commit d83d89ea68b4726700fa87b22db075e4217e691c ]

In APM mode, TCF and TEF flags are not set. To avoid timeout in
stm32_qspi_wait_cmd(), don't check if TCF/TEF are set.

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Reported-by: eberhard.stoll@kontron.de
Link: https://lore.kernel.org/r/20220511074644.558874-2-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32-qspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32-qspi.c b/drivers/spi/spi-stm32-qspi.c
index ffdc55f87e82..dd38cb8ffbc2 100644
--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -308,7 +308,8 @@ static int stm32_qspi_wait_cmd(struct stm32_qspi *qspi,
 	if (!op->data.nbytes)
 		goto wait_nobusy;
 
-	if (readl_relaxed(qspi->io_base + QSPI_SR) & SR_TCF)
+	if ((readl_relaxed(qspi->io_base + QSPI_SR) & SR_TCF) ||
+	    qspi->fmode == CCR_FMODE_APM)
 		goto out;
 
 	reinit_completion(&qspi->data_completion);
-- 
2.35.1

