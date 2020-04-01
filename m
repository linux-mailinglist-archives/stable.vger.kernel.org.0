Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E8F19B448
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732842AbgDAQV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732839AbgDAQV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:21:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6DC820658;
        Wed,  1 Apr 2020 16:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758116;
        bh=2HWcueEfTNlE8Ex8w0UbtPN8RR9ULSYgszf7n7vXJsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tn42aJxdSqA/AmfBFXRpKS00CrwiykpLkN6pKEhwkCMbcw4xGAwN8r6s9S82UYgOB
         zvYn9ViK8KjObvvx0TE0xB3St3WksX/CR/ZlNYEZMCCl+S5h9bbDAGvWkQM+rof+8H
         qlqIL0Jm3htljVmYI2Af6uMVnqoJGwSqwrECOm9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Tero Kristo <t-kristo@ti.com>, Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 17/27] clk: ti: am43xx: Fix clock parent for RTC clock
Date:   Wed,  1 Apr 2020 18:17:45 +0200
Message-Id: <20200401161428.655179743@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 5f3d9b07b9bb4679922f0b2e2baa770e74a6bbd3 upstream.

Currently enabling clkctrl clock on am4 can fail for RTC as the clock
parent is wrong for RTC.

Fixes: 76a1049b84dd ("clk: ti: am43xx: add new clkctrl data for am43xx")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lkml.kernel.org/r/20200221171030.39326-1-tony@atomide.com
Acked-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ti/clk-43xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/ti/clk-43xx.c
+++ b/drivers/clk/ti/clk-43xx.c
@@ -78,7 +78,7 @@ static const struct omap_clkctrl_reg_dat
 };
 
 static const struct omap_clkctrl_reg_data am4_l4_rtc_clkctrl_regs[] __initconst = {
-	{ AM4_L4_RTC_RTC_CLKCTRL, NULL, CLKF_SW_SUP, "clk_32768_ck" },
+	{ AM4_L4_RTC_RTC_CLKCTRL, NULL, CLKF_SW_SUP, "clkdiv32k_ick" },
 	{ 0 },
 };
 


