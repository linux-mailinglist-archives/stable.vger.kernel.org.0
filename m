Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F0C22661B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbgGTQAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732380AbgGTQAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:00:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E09020578;
        Mon, 20 Jul 2020 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260818;
        bh=v524NkExBB2dE3saBgiSvQ5ty8mbFAC4Cg1ZB04RqxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDSjJJZPTS7oDhKxyGOsYczCUM9E9rxGH2fcj2pUN1ExLrI1yn2UaeoXrQGpLFcpL
         VYQ8Dey/0yhMm3Lm5HMFUURmj+SoUJFl9LUEwUv6n5CCog6gC8obOTT1f7eIZk5IoK
         7RLL36OjMHeFs5hP/bVL7nUTc1UC01q37puilCKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/215] clk: mvebu: ARMADA_AP_CPU_CLK needs to select ARMADA_AP_CP_HELPER
Date:   Mon, 20 Jul 2020 17:36:30 +0200
Message-Id: <20200720152825.338642575@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 8e3709d7e3a67e2d3f42bd1fc2052353a5678944 ]

When building arm32 allmodconfig:

ld.lld: error: undefined symbol: ap_cp_unique_name
>>> referenced by ap-cpu-clk.c
>>>               clk/mvebu/ap-cpu-clk.o:(ap_cpu_clock_probe) in archive drivers/built-in.a

ap_cp_unique_name is only compiled into the kernel image when
CONFIG_ARMADA_AP_CP_HELPER is selected (as it is not user selectable).
However, CONFIG_ARMADA_AP_CPU_CLK does not select it.

This has been a problem since the driver was added to the kernel but it
was not built before commit c318ea261749 ("cpufreq: ap806: fix cpufreq
driver needs ap cpu clk") so it was never noticed.

Fixes: f756e362d938 ("clk: mvebu: add CPU clock driver for Armada 7K/8K")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20200701201128.2448427-1-natechancellor@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mvebu/Kconfig b/drivers/clk/mvebu/Kconfig
index 415e6906a113f..76cd06f4ed62a 100644
--- a/drivers/clk/mvebu/Kconfig
+++ b/drivers/clk/mvebu/Kconfig
@@ -42,6 +42,7 @@ config ARMADA_AP806_SYSCON
 
 config ARMADA_AP_CPU_CLK
 	bool
+	select ARMADA_AP_CP_HELPER
 
 config ARMADA_CP110_SYSCON
 	bool
-- 
2.25.1



