Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4D538A3C6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhETJ4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234859AbhETJyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AACA613AF;
        Thu, 20 May 2021 09:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503420;
        bh=IWhuYujvcH09tMcgER42SSgdvRl43EpvttrdkUtxCA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrVnJq0TM2zjqo6AZ61dZ7LEj/I78qQqRnlaW9qnjESPQ77LrU6T35u3FRGSbiZrE
         xDAbeiqPtDPDoHpDMY0gNXodrmf5IFbWeuWTFGuGVESj9k8kYM3RR/Ys7HQX7Tax21
         wEn+bmx569hUjNS4SPw17A2ztvQUJo3InIwcv/Ks=
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
Subject: [PATCH 4.19 212/425] cpufreq: armada-37xx: Fix determining base CPU frequency
Date:   Thu, 20 May 2021 11:19:41 +0200
Message-Id: <20210520092138.383550952@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 8bad3bf23cbc40abe1d24cec08a114df6facf858 ]

When current CPU load is not L0 then loading armada-37xx-cpufreq.ko driver
fails with following error:

    # modprobe armada-37xx-cpufreq
    [  502.702097] Unsupported CPU frequency 250 MHz

This issue was partially fixed by commit 8db82563451f ("cpufreq:
armada-37xx: fix frequency calculation for opp"), but only for calculating
CPU frequency for opp.

Fix this also for determination of base CPU frequency.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Tested-by: Anders Trier Olesen <anders.trier.olesen@gmail.com>
Tested-by: Philip Soares <philips@netisense.com>
Fixes: 92ce45fb875d ("cpufreq: Add DVFS support for Armada 37xx")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-37xx-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index 6a4ac26ac6a8..a36452bd9612 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -471,7 +471,7 @@ static int __init armada37xx_cpufreq_driver_init(void)
 		return -EINVAL;
 	}
 
-	dvfs = armada_37xx_cpu_freq_info_get(cur_frequency);
+	dvfs = armada_37xx_cpu_freq_info_get(base_frequency);
 	if (!dvfs) {
 		clk_put(clk);
 		return -EINVAL;
-- 
2.30.2



