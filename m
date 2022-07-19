Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2665579B0F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbiGSMY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239728AbiGSMYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B226112F;
        Tue, 19 Jul 2022 05:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A35DD61790;
        Tue, 19 Jul 2022 12:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991E9C341C6;
        Tue, 19 Jul 2022 12:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232508;
        bh=h1wfxGz2vBToOZrZjVl2LDtbJkmq2Kug3U3SqP0uKRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4NW9cXBTRyCZTelml1NUM3uxlKclogcogfRah+K5XxfyYWvM2ODIAVd8x+BMIVCi
         oPSHd+gCII/N8dZdslRfN2e9X6+DWKpSGnktgugUxp+FmAPsqtDu2DdxD7duelHqtO
         WYe4mmH58h+Xp8pJwvA9W/vO2XZovzH5K/JUQMBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/112] cpufreq: pmac32-cpufreq: Fix refcount leak bug
Date:   Tue, 19 Jul 2022 13:54:14 +0200
Message-Id: <20220719114634.414028874@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



