Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA596505849
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbiDRN77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244661AbiDRN5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:57:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D7C2AE0F;
        Mon, 18 Apr 2022 06:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1C1760F16;
        Mon, 18 Apr 2022 13:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B1BC385A7;
        Mon, 18 Apr 2022 13:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287228;
        bh=YYBpXRePL8X7DjK5YTHKeCMw035l7zTM2kihcEQdxEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6zjl4t6BMIKaiRWaSoUx3HmfdK1EyKW7F9z5TtyVivZEjyDNwyVZ913hZ2J/qpnQ
         Eq8H8gc1DvCcXJ8AZft2fad/oLA9mGh83j7dG5myIiujOalmL7EkxoX85GmooVXv5k
         kQLat5fezI0Sdl1vTMdlxOfF4IlkFgow0H+hmbQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 097/218] mfd: mc13xxx: Add check for mc13xxx_irq_request
Date:   Mon, 18 Apr 2022 14:12:43 +0200
Message-Id: <20220418121202.380669745@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit e477e51a41cb5d6034f3c5ea85a71ad4613996b9 ]

As the potential failure of the devm_request_threaded_irq(),
it should be better to check the return value of the
mc13xxx_irq_request() and return error if fails.

Fixes: 8e00593557c3 ("mfd: Add mc13892 support to mc13xxx")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220224022331.3208275-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mc13xxx-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 75d52034f89d..5b4faebdcae2 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -313,8 +313,10 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 		adc1 |= MC13783_ADC1_ATOX;
 
 	dev_dbg(mc13xxx->dev, "%s: request irq\n", __func__);
-	mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
+	ret = mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
 			mc13xxx_handler_adcdone, __func__, &adcdone_data);
+	if (ret)
+		goto out;
 
 	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC0, adc0);
 	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC1, adc1);
-- 
2.34.1



