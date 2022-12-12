Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E9C64A03A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiLLNWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiLLNWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:22:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39F1BF4
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:22:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70DA461042
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BB0C433F0;
        Mon, 12 Dec 2022 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851321;
        bh=MTVEl/eVAJqBrcHA5eO5rmojqkMRaNsSTr5K5+E3JWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9pcU5hET+mm8+tcmsMe7a1cmHAL4zkRK3/cwSVaMZzlGlnSyLnASMfg0a2TpW9TN
         2mIMJxoGKKjwaKWwFTSqzOM1u6AGow+lWffKpUVBZ6+yHRChp3xXpu5oYQbUJGkVus
         M7SC0nkvVr7MCTgctW+qcLK5ONYh1RsL3y4g/kEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/67] regulator: slg51000: Wait after asserting CS pin
Date:   Mon, 12 Dec 2022 14:16:44 +0100
Message-Id: <20221212130918.077792727@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 0b24dfa587c6cc7484cfb170da5c7dd73451f670 ]

Sony's downstream driver [1], among some other changes, adds a
seemingly random 10ms usleep_range, which turned out to be necessary
for the hardware to function properly on at least Sony Xperia 1 IV.
Without this, I2C transactions with the SLG51000 straight up fail.

Relax (10-10ms -> 10-11ms) and add the aforementioned sleep to make
sure the hardware has some time to wake up.

(nagara-2.0.0-mlc/vendor/semc/hardware/camera-kernel-module/)
[1] https://developer.sony.com/file/download/open-source-archive-for-64-0-m-4-29/

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20221118131035.54874-1-konrad.dybcio@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/slg51000-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/slg51000-regulator.c b/drivers/regulator/slg51000-regulator.c
index a0565daecace..5a18d7e620a5 100644
--- a/drivers/regulator/slg51000-regulator.c
+++ b/drivers/regulator/slg51000-regulator.c
@@ -465,6 +465,8 @@ static int slg51000_i2c_probe(struct i2c_client *client,
 		chip->cs_gpiod = cs_gpiod;
 	}
 
+	usleep_range(10000, 11000);
+
 	i2c_set_clientdata(client, chip);
 	chip->chip_irq = client->irq;
 	chip->dev = dev;
-- 
2.35.1



