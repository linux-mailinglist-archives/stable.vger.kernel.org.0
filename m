Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5A8568DDE
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiGFPiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbiGFPho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:37:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997582714C;
        Wed,  6 Jul 2022 08:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48545B81ADA;
        Wed,  6 Jul 2022 15:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194A1C341C8;
        Wed,  6 Jul 2022 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121653;
        bh=BN3QKHWBFOVmDNAdkhEZg41UokDP2Y1qURVWKR6ME3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hG+qz9x2+NafUyuuOm9V8JTXDpjKiVFhCczobHnEl1IWIYsUzspB27G2PkuYfSTGo
         TPD7Af/1XhC98QNSlWLRlsFowSwm6eAbiuqcYaUsTsfUqOhy16KuOmOh6dqr2XyFT8
         yCAH5MhLmnzBfYBr4QXEHh3jCEAvRYclC3fNmSPU31drhLk0KJYSM+yZCfy8CkleGU
         OOfh0+ebquYquUjZC2KBMFHd8n1T+lu+eEKckOQpq3VE8NGToOaVjs0sknQsAKtI3P
         7Uvi8CO9rCDBhDTxko6Nl1NbbdLIDN5UvD4WU5QgeJad5HMcR3nP4oIugT9qo3cQK6
         KNKjYbqhhQtNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mpe@ellerman.id.au, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 3/5] cpufreq: pmac32-cpufreq: Fix refcount leak bug
Date:   Wed,  6 Jul 2022 11:34:05 -0400
Message-Id: <20220706153407.1598915-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153407.1598915-1-sashal@kernel.org>
References: <20220706153407.1598915-1-sashal@kernel.org>
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
index 641f8021855a..62e86f7ca04a 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -473,6 +473,10 @@ static int pmac_cpufreq_init_MacRISC3(struct device_node *cpunode)
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

