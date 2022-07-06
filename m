Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A0B568DCB
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiGFPga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbiGFPfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:35:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECCE296;
        Wed,  6 Jul 2022 08:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3439BCE2080;
        Wed,  6 Jul 2022 15:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C91C3411C;
        Wed,  6 Jul 2022 15:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121604;
        bh=h1wfxGz2vBToOZrZjVl2LDtbJkmq2Kug3U3SqP0uKRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXacmzXzp/5DjmhPA8BDskhe14cDrp/0+0yxSXHqxCMQDc3II5JPB0xqBExRozIZk
         MQ5FZOWEUW50rpEzo0ohOSjWjE7TPKF09l3FwpCIEEeC5FXCQA6s6rnX3n+436qHPg
         J56QHgzoGAdX+M+pe5b90TXvHwDhSO9/ZSZSi8NN8QeqoB7ueRb0MhxSkB64oMSH10
         W7FwhXvqQn5nWbOaI2tKaG49+8WPyDgzwIzJP8niMl4r+3ASt8yJJdcdITvI0SQxBS
         3ugfhEs3Tadt9bsvBaH+stQE479LTh3mkrLKMQz4eneh+Erxw9fsjlAearsfrpLkb0
         sxeYidYOTl2eA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mpe@ellerman.id.au, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 4/9] cpufreq: pmac32-cpufreq: Fix refcount leak bug
Date:   Wed,  6 Jul 2022 11:33:10 -0400
Message-Id: <20220706153316.1598554-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153316.1598554-1-sashal@kernel.org>
References: <20220706153316.1598554-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit ccd7567d4b6cf187fdfa55f003a9e461ee629e36 ]

In pmac_cpufreq_init_MacRISC3(), we need to add corresponding
of_node_put() for the three node pointers whose refcount have
been incremented by of_find_node_by_name().

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/pmac32-cpufreq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 73621bc11976..3704476bb83a 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -471,6 +471,10 @@ static int pmac_cpufreq_init_MacRISC3(struct device_node *cpunode)
 	if (slew_done_gpio_np)
 		slew_done_gpio = read_gpio(slew_done_gpio_np);
 
+	of_node_put(volt_gpio_np);
+	of_node_put(freq_gpio_np);
+	of_node_put(slew_done_gpio_np);
+
 	/* If we use the frequency GPIOs, calculate the min/max speeds based
 	 * on the bus frequencies
 	 */
-- 
2.35.1

