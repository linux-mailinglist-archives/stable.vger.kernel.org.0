Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0475A6B41F2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjCJN6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjCJN6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:58:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A938168AF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:58:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7744BB822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE4CC4339B;
        Fri, 10 Mar 2023 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456678;
        bh=Bqq13GJ0RrJRkDyXIzePBxHdJWcN/44R6Id0IGAHTZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Twr/tUjG1otiVSvhdsHcqwHH+dcUGcbjtZIeus6haRNvcc2Fo2vuF+fGXHXUnRLSe
         BhYrOsnEexhY0lckU5OjMkWfeAsRF7+tvFnP+7s+x/5FNowUZ20gygK5+ReO9a+ACx
         jcp8dcOeXXYC2Ln1EI/MRaXOAOtwGaufEX8oa3GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 086/211] spi: tegra210-quad: Fix validate combined sequence
Date:   Fri, 10 Mar 2023 14:37:46 +0100
Message-Id: <20230310133721.404601899@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit 047ee71ae4f412d8819e39e4b08c588fa299cfc2 ]

Check for non dma transfers that do not fit in FIFO has issue and skips
combined sequence for Tegra234 & Tegra241 which does not have GPCDMA.

Fixes: 1b8342cc4a38 ("spi: tegra210-quad: combined sequence mode")

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/20230224164034.56933-1-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 9f356612ba7e5..6498948e150a5 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1297,7 +1297,7 @@ static bool tegra_qspi_validate_cmb_seq(struct tegra_qspi *tqspi,
 	if (xfer->len > 4 || xfer->len < 3)
 		return false;
 	xfer = list_next_entry(xfer, transfer_list);
-	if (!tqspi->soc_data->has_dma || xfer->len > (QSPI_FIFO_DEPTH << 2))
+	if (!tqspi->soc_data->has_dma && xfer->len > (QSPI_FIFO_DEPTH << 2))
 		return false;
 
 	return true;
-- 
2.39.2



