Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5996A5B6FAE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiIMOOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiIMON6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:13:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F5C606BD;
        Tue, 13 Sep 2022 07:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9B8CB80EF7;
        Tue, 13 Sep 2022 14:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E57C433D6;
        Tue, 13 Sep 2022 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078240;
        bh=2e8DGinRPwln+bx/cYQ+p2GpkgxOWCvNc5B0LerR980=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niQpdwwjEASEfLsZwzDrt7T2ChxAl64llPJ9jcfbMdWeKBGEK8jwkRL7X4+vA9Crl
         1cDf3tqg5NdX+YFSEiMT3PX3Z337bAqd2xWjrYY5Nvmj8G7raO/gJzpOqHSVQh7lMw
         2q1vNTwVctKgNukvD0XwXW7NRdg5poGHN/4bCJYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 064/192] spi: bitbang: Fix lsb-first Rx
Date:   Tue, 13 Sep 2022 16:02:50 +0200
Message-Id: <20220913140413.152339198@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 46f7ac3d7892e808c9ba01c39da6bb85cda26ecd ]

Shifting the recieved bit by "bits" inserts it at the top of the
*currently remaining* Tx data, so we end up accumulating the whole
transfer into bit 0 of the output word. Oops.

For the algorithm to work as intended, we need to remember where the
top of the *original* word was, and shift Rx to there.

Fixes: 1847e3046c52 ("spi: gpio: Implement LSB First bitbang support")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/28324d8622da80461cce35a82859b003d6f6c4b0.1659538737.git.robin.murphy@arm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bitbang-txrx.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-bitbang-txrx.h b/drivers/spi/spi-bitbang-txrx.h
index 267342dfa7388..2dcbe166df63e 100644
--- a/drivers/spi/spi-bitbang-txrx.h
+++ b/drivers/spi/spi-bitbang-txrx.h
@@ -116,6 +116,7 @@ bitbang_txrx_le_cpha0(struct spi_device *spi,
 {
 	/* if (cpol == 0) this is SPI_MODE_0; else this is SPI_MODE_2 */
 
+	u8 rxbit = bits - 1;
 	u32 oldbit = !(word & 1);
 	/* clock starts at inactive polarity */
 	for (; likely(bits); bits--) {
@@ -135,7 +136,7 @@ bitbang_txrx_le_cpha0(struct spi_device *spi,
 		/* sample LSB (from slave) on leading edge */
 		word >>= 1;
 		if ((flags & SPI_MASTER_NO_RX) == 0)
-			word |= getmiso(spi) << (bits - 1);
+			word |= getmiso(spi) << rxbit;
 		setsck(spi, cpol);
 	}
 	return word;
@@ -148,6 +149,7 @@ bitbang_txrx_le_cpha1(struct spi_device *spi,
 {
 	/* if (cpol == 0) this is SPI_MODE_1; else this is SPI_MODE_3 */
 
+	u8 rxbit = bits - 1;
 	u32 oldbit = !(word & 1);
 	/* clock starts at inactive polarity */
 	for (; likely(bits); bits--) {
@@ -168,7 +170,7 @@ bitbang_txrx_le_cpha1(struct spi_device *spi,
 		/* sample LSB (from slave) on trailing edge */
 		word >>= 1;
 		if ((flags & SPI_MASTER_NO_RX) == 0)
-			word |= getmiso(spi) << (bits - 1);
+			word |= getmiso(spi) << rxbit;
 	}
 	return word;
 }
-- 
2.35.1



