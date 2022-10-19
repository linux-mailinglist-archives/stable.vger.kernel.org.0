Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C902D603DEB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiJSJIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiJSJG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:06:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276DE1EED2;
        Wed, 19 Oct 2022 01:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 995DF61865;
        Wed, 19 Oct 2022 08:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB859C433D7;
        Wed, 19 Oct 2022 08:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169509;
        bh=t3dMiH4XJXVQqT24zBIQwudtQaBoBJjPnA3eH7aaObo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXMrPg+jqF6UZY0OWp9zRhhJTJXB0LS1Y/f4YHju9f8fljTkLh1m3OyRLueih/wpV
         UNMX25UT/MRH7p/Yoaw10VLtn/uS0a4z8Qx9AQJpK4WWS/OjhWb8FBDHE1tC3uumXL
         oYi/rOvbBM6VJugxZpJGZorXaKu4W9pXTjWoxPsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 270/862] spi: meson-spicc: do not rely on busy flag in pow2 clk ops
Date:   Wed, 19 Oct 2022 10:25:57 +0200
Message-Id: <20221019083301.955710850@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 36acf80fc0c4b5ebe6fa010b524d442ee7f08fd3 ]

Since [1], controller's busy flag isn't set anymore when the
__spi_transfer_message_noqueue() is used instead of the
__spi_pump_transfer_message() logic for spi_sync transfers.

Since the pow2 clock ops were limited to only be available when a
transfer is ongoing (between prepare_transfer_hardware and
unprepare_transfer_hardware callbacks), the only way to track this
down is to check for the controller cur_msg.

[1] ae7d2346dc89 ("spi: Don't use the message queue if possible in spi_sync")

Fixes: 09992025dacd ("spi: meson-spicc: add local pow2 clock ops to preserve rate between messages")
Fixes: ae7d2346dc89 ("spi: Don't use the message queue if possible in spi_sync")
Reported-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Tested-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/r/20220908121803.919943-1-narmstrong@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index e4cb52e1fe26..6974a1c947aa 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -537,7 +537,7 @@ static unsigned long meson_spicc_pow2_recalc_rate(struct clk_hw *hw,
 	struct clk_divider *divider = to_clk_divider(hw);
 	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
 
-	if (!spicc->master->cur_msg || !spicc->master->busy)
+	if (!spicc->master->cur_msg)
 		return 0;
 
 	return clk_divider_ops.recalc_rate(hw, parent_rate);
@@ -549,7 +549,7 @@ static int meson_spicc_pow2_determine_rate(struct clk_hw *hw,
 	struct clk_divider *divider = to_clk_divider(hw);
 	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
 
-	if (!spicc->master->cur_msg || !spicc->master->busy)
+	if (!spicc->master->cur_msg)
 		return -EINVAL;
 
 	return clk_divider_ops.determine_rate(hw, req);
@@ -561,7 +561,7 @@ static int meson_spicc_pow2_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_divider *divider = to_clk_divider(hw);
 	struct meson_spicc_device *spicc = pow2_clk_to_spicc(divider);
 
-	if (!spicc->master->cur_msg || !spicc->master->busy)
+	if (!spicc->master->cur_msg)
 		return -EINVAL;
 
 	return clk_divider_ops.set_rate(hw, rate, parent_rate);
-- 
2.35.1



