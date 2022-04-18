Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF247505619
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241994AbiDRNcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242287AbiDRN1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:27:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1343EB8C;
        Mon, 18 Apr 2022 05:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52818B80E4E;
        Mon, 18 Apr 2022 12:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754DFC385A1;
        Mon, 18 Apr 2022 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286395;
        bh=YYBpXRePL8X7DjK5YTHKeCMw035l7zTM2kihcEQdxEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeKj9NAFgQ7HyLMMIYe6rsYG18yQNxH2CDJQHKW6+xTXAh1ChmxanTYLMzDz1Ugc2
         hf4yJX+Sv4/J0fWV3JWx8FdcaHjaNu3kMAAftHo2beZng7R3loPaNlUZeh/XmV86LQ
         R1ocVMY9JMMZui6Kd9Di07JtaRR5W78RSq9deQQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 120/284] mfd: mc13xxx: Add check for mc13xxx_irq_request
Date:   Mon, 18 Apr 2022 14:11:41 +0200
Message-Id: <20220418121214.522120160@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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



