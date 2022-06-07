Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2C540AB9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351479AbiFGSXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352399AbiFGSRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E52620F43;
        Tue,  7 Jun 2022 10:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C62BB82366;
        Tue,  7 Jun 2022 17:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4F9C34115;
        Tue,  7 Jun 2022 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624297;
        bh=g0oaQyRmKjYxMqGZ54+Uxj1lpZP/JlxUKgiwTG+f6pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anKNJxWAgE9RXO83nVxO9jZfdCJ1c4LPqWlB8ziZIng17rwzr4/0qcDiab1jFZpZw
         3ZC9Gn6tJhbq8GR53p1SAIPvc3ysBERcxlKTwpsY3rMpTSQXp8FyN0910UI38rnZvL
         MXaGb9b/UEUXcQP+l1Dfc5TWvywPM6aXPcpPHw6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/667] spi: cadence-quadspi: fix Direct Access Mode disable for SoCFPGA
Date:   Tue,  7 Jun 2022 18:59:02 +0200
Message-Id: <20220607164943.093858303@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit f724c296f2f2cc3f9342b0fc26239635cbed856e ]

The Cadence QSPI compatible string required for the SoCFPGA platform
changed from the default "cdns,qspi-nor" to "intel,socfpga-qspi" with
the introduction of an additional quirk in
commit 98d948eb8331 ("spi: cadence-quadspi: fix write completion support").
However, that change did not preserve the previously used
quirk for this platform.  Reinstate the `CQSPI_DISABLE_DAC_MODE` quirk
for the SoCFPGA platform.

Fixes: 98d948eb8331 ("spi: cadence-quadspi: fix write completion support")
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20220427153446.10113-1-abbotti@mev.co.uk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 2714ba02b176..cda70de38330 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1660,7 +1660,7 @@ static const struct cqspi_driver_platdata intel_lgm_qspi = {
 };
 
 static const struct cqspi_driver_platdata socfpga_qspi = {
-	.quirks = CQSPI_NO_SUPPORT_WR_COMPLETION,
+	.quirks = CQSPI_DISABLE_DAC_MODE | CQSPI_NO_SUPPORT_WR_COMPLETION,
 };
 
 static const struct of_device_id cqspi_dt_ids[] = {
-- 
2.35.1



