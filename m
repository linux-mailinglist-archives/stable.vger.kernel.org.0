Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0286E541239
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357201AbiFGTom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357976AbiFGTmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561A6237E5;
        Tue,  7 Jun 2022 11:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 284B7CE244F;
        Tue,  7 Jun 2022 18:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAC0C385A5;
        Tue,  7 Jun 2022 18:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625857;
        bh=63KEk9VLTggDHYa7uCWhw1ThCahBRf68liu0x9+Y4Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+GMxdkbz3GpjzryiT3HlD6chHB4lXcKUXLBVIR/9OLN71hFqMpbnx0lXvlO0/zyx
         pKKTQ8VrrlDfUG1S95Q+tDEt9qrnztxdrPgKnZPbTt2o0OIvznTIOREMzZUc8VXQLH
         1bneB3FmizpRtPLW0vtRCVYgU6kA7U57d9bGiDoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        eberhard.stoll@kontron.de, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 129/772] spi: stm32-qspi: Fix wait_cmd timeout in APM mode
Date:   Tue,  7 Jun 2022 18:55:21 +0200
Message-Id: <20220607164952.845897605@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



