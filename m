Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED761585E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKBCuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiKBCuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D83209A7
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6605617CA
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763B8C433D6;
        Wed,  2 Nov 2022 02:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357437;
        bh=XvApASpnBaHnOKvRcgjBm7nInIxXt4w7Q/G8fSB7EH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLP8CklVsG+aCPsibL/m0ttQewV7Vg38dPvTlqYcJEchV/PN9iogWUcvk2wEKiHbZ
         UYAu0RPAIqqdfj2FTJKLDdhfc2w93+hqWCfzuU18hG7CJzQE8IgMvyFJ3/gMYVZpBH
         bjNNLdP/1dIsCv8MYe4r4YFhs0LnWmf0/0Nh72ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Joel Stanley <joel@jms.id.au>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 152/240] spi: aspeed: Fix window offset of CE1
Date:   Wed,  2 Nov 2022 03:32:07 +0100
Message-Id: <20221102022114.817755256@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit f8aa6c895d482847c9b799dcdac8bbdb56cb8e04 ]

The offset value of the mapping window in the kernel structure is
calculated using the value of the previous window offset. This doesn't
reflect how the HW is configured and can lead to erroneous setting of
the second flash device (CE1).

Cc: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>
Fixes: e3228ed92893 ("spi: spi-mem: Convert Aspeed SMC driver to spi-mem")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20221016155722.3520802-1-clg@kaod.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-aspeed-smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-aspeed-smc.c b/drivers/spi/spi-aspeed-smc.c
index 3e891bf22470..5a995b5653f1 100644
--- a/drivers/spi/spi-aspeed-smc.c
+++ b/drivers/spi/spi-aspeed-smc.c
@@ -398,7 +398,7 @@ static void aspeed_spi_get_windows(struct aspeed_spi *aspi,
 		windows[cs].cs = cs;
 		windows[cs].size = data->segment_end(aspi, reg_val) -
 			data->segment_start(aspi, reg_val);
-		windows[cs].offset = cs ? windows[cs - 1].offset + windows[cs - 1].size : 0;
+		windows[cs].offset = data->segment_start(aspi, reg_val) - aspi->ahb_base_phy;
 		dev_vdbg(aspi->dev, "CE%d offset=0x%.8x size=0x%x\n", cs,
 			 windows[cs].offset, windows[cs].size);
 	}
-- 
2.35.1



