Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AC25011AD
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiDNNdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244898AbiDNN2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E172091557;
        Thu, 14 Apr 2022 06:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97B7DB82910;
        Thu, 14 Apr 2022 13:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09458C385A5;
        Thu, 14 Apr 2022 13:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942474;
        bh=vyCVv6qJIsnjkSaHv0zFcCe681Rag8sg95z3AiB6Fuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUyUmTV8RyFy1D1yZ1kohxIwHlM1JHKmjcHoXjmqau3e7CAhvN9DWagdeAcAX1FVt
         5AkwNn5l3Ldbuj98nN7NbxXnYqUrjaYBGM2KA2c1H4shJP4VO6N3U2ne1jK8RTMBl0
         F3zMFkhz/jbH6t9/gDKqb/3TZFYPDbMLQxqjaseo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/338] mfd: mc13xxx: Add check for mc13xxx_irq_request
Date:   Thu, 14 Apr 2022 15:10:50 +0200
Message-Id: <20220414110843.088144094@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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
index d0bf50e3568d..dcbb969af5f4 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -326,8 +326,10 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
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



