Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BE8360CA5
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhDOOwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234139AbhDOOvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:51:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A46613D8;
        Thu, 15 Apr 2021 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498277;
        bh=ZdS0g/Yni3cf1SWjqXa/h9rdeNHnb/Tuqe1EZnoWBSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nwaE4yVhTU3v+6b4wMJBl57ZB/zwIi11Kr7xevOvH+axxx8LP+ZqgTQ27ZrRT36r
         2EGe1cXXAG0UiRjetpdjDKgkK07fDRcPq7YHVtTDuTv2x9tB7Jp4aw6bMmN/hBHo7t
         o97aYEV3EQpvRlZLs/sdpUtVE085HoBjs3vmCGf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.9 26/47] clk: socfpga: fix iomem pointer cast on 64-bit
Date:   Thu, 15 Apr 2021 16:47:18 +0200
Message-Id: <20210415144414.296601848@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 2867b9746cef78745c594894aece6f8ef826e0b4 upstream.

Pointers should be cast with uintptr_t instead of integer.  This fixes
warning when compile testing on ARM64:

  drivers/clk/socfpga/clk-gate.c: In function ‘socfpga_clk_recalc_rate’:
  drivers/clk/socfpga/clk-gate.c:102:7: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Fixes: b7cec13f082f ("clk: socfpga: Look for the GPIO_DB_CLK by its offset")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210314110709.32599-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/socfpga/clk-gate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/socfpga/clk-gate.c
+++ b/drivers/clk/socfpga/clk-gate.c
@@ -107,7 +107,7 @@ static unsigned long socfpga_clk_recalc_
 		val = readl(socfpgaclk->div_reg) >> socfpgaclk->shift;
 		val &= GENMASK(socfpgaclk->width - 1, 0);
 		/* Check for GPIO_DB_CLK by its offset */
-		if ((int) socfpgaclk->div_reg & SOCFPGA_GPIO_DB_CLK_OFFSET)
+		if ((uintptr_t) socfpgaclk->div_reg & SOCFPGA_GPIO_DB_CLK_OFFSET)
 			div = val + 1;
 		else
 			div = (1 << val);


