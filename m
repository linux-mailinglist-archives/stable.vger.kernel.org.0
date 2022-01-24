Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4DC49A054
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843818AbiAXXGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382562AbiAXW6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:58:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B0EC02B742;
        Mon, 24 Jan 2022 13:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFD5FB8122A;
        Mon, 24 Jan 2022 21:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6214C340E5;
        Mon, 24 Jan 2022 21:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058791;
        bh=1nFGUXS5uHMg5lFL3K/RPXk6Rgm9bRxx6BTr9LD/yQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzA2QvwqLtIk8l6BmVKnZPvCQqBt2LTV9cFtLXACODwAsScw6msWlZwMVc5/7Cf9O
         UEoMfNwMzkNewsbnmhQyQz/XMdD5NWJctgVrkFLteFuDvNl6SbuZIgD6uywYgLJkbn
         Os9INxLbbQe37LSWI5cytpc6ME/JH0rGbwrkaqzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0402/1039] spi: qcom: geni: set the error code for gpi transfer
Date:   Mon, 24 Jan 2022 19:36:31 +0100
Message-Id: <20220124184138.825523450@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 74b86d6af81be73bb74995ebeba74417e84b6b6f ]

Before we invoke spi_finalize_current_transfer() in
spi_gsi_callback_result() we should set the spi->cur_msg->status as
appropriate (0 for success, error otherwise).

The helps to return error on transfer and not wait till it timesout on
error

Fixes: b59c122484ec ("spi: spi-geni-qcom: Add support for GPI dma")
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220103071118.27220-1-vkoul@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index e2affaee4e769..69e71aac85129 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -350,17 +350,21 @@ spi_gsi_callback_result(void *cb, const struct dmaengine_result *result)
 {
 	struct spi_master *spi = cb;
 
+	spi->cur_msg->status = -EIO;
 	if (result->result != DMA_TRANS_NOERROR) {
 		dev_err(&spi->dev, "DMA txn failed: %d\n", result->result);
+		spi_finalize_current_transfer(spi);
 		return;
 	}
 
 	if (!result->residue) {
+		spi->cur_msg->status = 0;
 		dev_dbg(&spi->dev, "DMA txn completed\n");
-		spi_finalize_current_transfer(spi);
 	} else {
 		dev_err(&spi->dev, "DMA xfer has pending: %d\n", result->residue);
 	}
+
+	spi_finalize_current_transfer(spi);
 }
 
 static int setup_gsi_xfer(struct spi_transfer *xfer, struct spi_geni_master *mas,
-- 
2.34.1



