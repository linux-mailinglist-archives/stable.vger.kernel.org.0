Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608C24F2A98
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345110AbiDEJyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243237AbiDEJIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853849F6C0;
        Tue,  5 Apr 2022 01:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 067AEB80DA1;
        Tue,  5 Apr 2022 08:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5453DC385AA;
        Tue,  5 Apr 2022 08:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149067;
        bh=fTO4FNgiYK0sHRgMdAu5LNK4LHTq4UV5MSEOC31Srdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9hmgdLLx0gcajiLykU/J1bpJrQWkx2Zk+f9OXFKDxjOdsT4cX0pHJJn4Szwvr98f
         25i0kIH42+VSbLlmpQ8UWkN5XH6n+kJH3rX9e8ouhIuswQwFThF9old/Juwg0s9yST
         X2uxZ8kxp5z7NUDeqMvxCrhclrGSvca9TR1YtFl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0581/1017] mfd: mc13xxx: Add check for mc13xxx_irq_request
Date:   Tue,  5 Apr 2022 09:24:54 +0200
Message-Id: <20220405070411.525227578@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 8a4f1d90dcfd..1000572761a8 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -323,8 +323,10 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
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



