Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22D84ABBAF
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384714AbiBGL3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383285AbiBGLWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:22:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5840C043181;
        Mon,  7 Feb 2022 03:21:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2101DB8111C;
        Mon,  7 Feb 2022 11:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45864C004E1;
        Mon,  7 Feb 2022 11:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232916;
        bh=a1TA4DjCl7tuLyxVDLt6AImdyWK9X+Cg1+2ZI88Iork=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7v/OAyH7t37A8jqMFgbJ8QNrX01lPtrkzh5SsPJA3kUJH67lMTTlh0UqMLEE4i+3
         C/4aN+29kIRRb2NZawXGmlJpxiQJkYXRcqHeOloRRGZN7chyhDnvzQFLHK4Rh38hx3
         ny96AWkIJ+s4OO8ujVzcjYEJWtiwHJVDdmvT3Qos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 33/74] spi: mediatek: Avoid NULL pointer crash in interrupt
Date:   Mon,  7 Feb 2022 12:06:31 +0100
Message-Id: <20220207103758.323000692@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

commit f83a96e5f033fbbd21764705cb9c04234b96218e upstream.

In some case, like after a transfer timeout, master->cur_msg pointer
is NULL which led to a kernel crash when trying to use master->cur_msg->spi.
mtk_spi_can_dma(), pointed by master->can_dma, doesn't use this parameter
avoid the problem by setting NULL as second parameter.

Fixes: a568231f46322 ("spi: mediatek: Add spi bus for Mediatek MT8173")
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Link: https://lore.kernel.org/r/20220131141708.888710-1-benjamin.gaignard@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mt65xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -540,7 +540,7 @@ static irqreturn_t mtk_spi_interrupt(int
 	else
 		mdata->state = MTK_SPI_IDLE;
 
-	if (!master->can_dma(master, master->cur_msg->spi, trans)) {
+	if (!master->can_dma(master, NULL, trans)) {
 		if (trans->rx_buf) {
 			cnt = mdata->xfer_len / 4;
 			ioread32_rep(mdata->base + SPI_RX_DATA_REG,


