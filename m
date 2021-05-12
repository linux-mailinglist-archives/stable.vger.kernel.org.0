Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FE337C208
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhELPGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhELPDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 734C3617C9;
        Wed, 12 May 2021 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831508;
        bh=uuW8gzK8zFcZuLfuvqIcczsoh4vWIEeC6LDJEvqkMfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omuynlmQXIKUNmeQgTz8DmxHzq9DehM9HQ038X+asP/Vz6Esqc2Gxfci+j5hs05hF
         UPIeMV9JYrdly+EHJsogLPm2tBbzt0piNfnNbEU2xSalEl0TRW1fWnu+KEqP4iFgER
         +o6OkEcVKMcRHl1S7E3C6jrI0uUwIKcZ+40o4Hfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Anders Trier Olesen <anders.trier.olesen@gmail.com>,
        Philip Soares <philips@netisense.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/244] cpufreq: armada-37xx: Fix driver cleanup when registration failed
Date:   Wed, 12 May 2021 16:48:11 +0200
Message-Id: <20210512144746.864239887@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 92963903a8e11b9576eb7249f8e81eefa93b6f96 ]

Commit 8db82563451f ("cpufreq: armada-37xx: fix frequency calculation for
opp") changed calculation of frequency passed to the dev_pm_opp_add()
function call. But the code for dev_pm_opp_remove() function call was not
updated, so the driver cleanup phase does not work when registration fails.

This fixes the issue by using the same frequency in both calls.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Tested-by: Anders Trier Olesen <anders.trier.olesen@gmail.com>
Tested-by: Philip Soares <philips@netisense.com>
Fixes: 8db82563451f ("cpufreq: armada-37xx: fix frequency calculation for opp")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-37xx-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index c7683d447b11..1ab2113daef5 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -521,7 +521,7 @@ disable_dvfs:
 remove_opp:
 	/* clean-up the already added opp before leaving */
 	while (load_lvl-- > ARMADA_37XX_DVFS_LOAD_0) {
-		freq = cur_frequency / dvfs->divider[load_lvl];
+		freq = base_frequency / dvfs->divider[load_lvl];
 		dev_pm_opp_remove(cpu_dev, freq);
 	}
 
-- 
2.30.2



