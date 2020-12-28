Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0B82E411C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408125AbgL1PCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439960AbgL1OMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46F7A22AAA;
        Mon, 28 Dec 2020 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164753;
        bh=dV46qeBfPLQJJtP+a2mxDy22q/gjmHpFLrDFTHvHiS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLFsseufUZdrgfUTEKMCwaYPhBNvad8gBO2t4t3aiwR1uDWeR/U8a1iTRaDmawP0C
         NqcYYGA6iEmPd6+yjmhMZK6Wsezuj8DUGGa7PAK08H1BJf1ahR7SjGTrvshUmEkwu9
         qMJgmcK4urWKpYzPtyWv3Zhc3MIDb5clUZXkIR+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Cercueil <paul@crapouillou.net>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/717] clocksource/drivers/ingenic: Fix section mismatch
Date:   Mon, 28 Dec 2020 13:44:45 +0100
Message-Id: <20201228125034.780980192@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 5bd7cb29eceb52e4b108917786fdbf2a2c2048ef ]

The function ingenic_tcu_get_clock() is annotated for the __init
section but it is actually called from the online cpu callback.

That will lead to a crash if a CPU is hotplugged after boot time.

Remove the __init annotation for the ingenic_tcu_get_clock()
function.

Fixes: f19d838d08fc (clocksource/drivers/ingenic: Add high resolution timer support for SMP/SMT)
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Link: https://lore.kernel.org/r/20201125102346.1816310-1-daniel.lezcano@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/ingenic-timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/ingenic-timer.c b/drivers/clocksource/ingenic-timer.c
index 58fd9189fab7f..905fd6b163a81 100644
--- a/drivers/clocksource/ingenic-timer.c
+++ b/drivers/clocksource/ingenic-timer.c
@@ -127,7 +127,7 @@ static irqreturn_t ingenic_tcu_cevt_cb(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct clk * __init ingenic_tcu_get_clock(struct device_node *np, int id)
+static struct clk *ingenic_tcu_get_clock(struct device_node *np, int id)
 {
 	struct of_phandle_args args;
 
-- 
2.27.0



