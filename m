Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCA438A7D8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbhETKnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237479AbhETKlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7971D61406;
        Thu, 20 May 2021 09:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504560;
        bh=iXgKiE9R8jdkGoaGr2EyzBtoQ+G1t82TOnZlung0k0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uos4A73YIxCBbRZRFxjM9Ff9d0UZmnUvXxNlNOLxFcmry1U1+P39tM4k9sgILVCRj
         IF27NBxKREtwc7ENAWTPu+C/pmFBTb633MM//c/tQ6OYKzqoH7SzoRHga1dc5Av7GA
         PAY1j7ZDPtKZKPkI7STYkNimG30EJO1A6FPOlj0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4.14 301/323] clk: exynos7: Mark aclk_fsys1_200 as critical
Date:   Thu, 20 May 2021 11:23:13 +0200
Message-Id: <20210520092130.547040763@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>

commit 34138a59b92c1a30649a18ec442d2e61f3bc34dd upstream.

This clock must be always enabled to allow access to any registers in
fsys1 CMU. Until proper solution based on runtime PM is applied
(similar to what was done for Exynos5433), mark that clock as critical
so it won't be disabled.

It was observed on Samsung Galaxy S6 device (based on Exynos7420), where
UFS module is probed before pmic used to power that device.
In this case defer probe was happening and that clock was disabled by
UFS driver, causing whole boot to hang on next CMU access.

Fixes: 753195a749a6 ("clk: samsung: exynos7: Correct CMU_FSYS1 clocks names")
Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/linux-clk/20201024154346.9589-1-pawel.mikolaj.chmiel@gmail.com
[s.nawrocki: Added comment in the code]
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-exynos7.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-exynos7.c
+++ b/drivers/clk/samsung/clk-exynos7.c
@@ -541,8 +541,13 @@ static const struct samsung_gate_clock t
 	GATE(CLK_ACLK_FSYS0_200, "aclk_fsys0_200", "dout_aclk_fsys0_200",
 		ENABLE_ACLK_TOP13, 28, CLK_SET_RATE_PARENT |
 		CLK_IS_CRITICAL, 0),
+	/*
+	 * This clock is required for the CMU_FSYS1 registers access, keep it
+	 * enabled permanently until proper runtime PM support is added.
+	 */
 	GATE(CLK_ACLK_FSYS1_200, "aclk_fsys1_200", "dout_aclk_fsys1_200",
-		ENABLE_ACLK_TOP13, 24, CLK_SET_RATE_PARENT, 0),
+		ENABLE_ACLK_TOP13, 24, CLK_SET_RATE_PARENT |
+		CLK_IS_CRITICAL, 0),
 
 	GATE(CLK_SCLK_PHY_FSYS1_26M, "sclk_phy_fsys1_26m",
 		"dout_sclk_phy_fsys1_26m", ENABLE_SCLK_TOP1_FSYS11,


