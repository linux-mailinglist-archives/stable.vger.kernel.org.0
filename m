Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6F943FAC
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389754AbfFMP66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbfFMItz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:49:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 758E6206BA;
        Thu, 13 Jun 2019 08:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415795;
        bh=IwLjCkQVR7JyIw0Tu6rfzQmaBLe/AQ7PaEB7IlDfThI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1g/Wk/twBPOJPEuGuDyKecGTo82N+1WoubFY3mdnDkWNuo+HFEhyQpxgxkE5eWqZ
         oZxHXQIcqfi76hNGkvHRGbkbqvw5yfFypBP+g9B6wR2rco7m4Sw6XdAXwbnnirKqz5
         1fJAhWFMeX2pGyKsRdmAUkFQujKA5ejEuAAY0m/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Elaine Zhang <zhangqing@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 100/155] clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288
Date:   Thu, 13 Jun 2019 10:33:32 +0200
Message-Id: <20190613075658.631320957@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 57a20248ef3e429dc822f0774bc4e00136c46c83 ]

Experimentally it can be seen that going into deep sleep (specifically
setting PMU_CLR_DMA and PMU_CLR_BUS in RK3288_PMU_PWRMODE_CON1)
appears to fail unless "aclk_dmac1" is on.  The failure is that the
system never signals that it made it into suspend on the GLOBAL_PWROFF
pin and it just hangs.

NOTE that it's confirmed that it's the actual suspend that fails, not
one of the earlier calls to read/write registers.  Specifically if you
comment out the "PMU_GLOBAL_INT_DISABLE" setting in
rk3288_slp_mode_set() and then comment out the "cpu_do_idle()" call in
rockchip_lpmode_enter() then you can exercise the whole suspend path
without any crashing.

This is currently not a problem with suspend upstream because there is
no current way to exercise the deep suspend code.  However, anyone
trying to make it work will run into this issue.

This was not a problem on shipping rk3288-based Chromebooks because
those devices all ran on an old kernel based on 3.14.  On that kernel
"aclk_dmac1" appears to be left on all the time.

There are several ways to skin this problem.

A) We could add "aclk_dmac1" to the list of critical clocks and that
apperas to work, but presumably that wastes power.

B) We could keep a list of "struct clk" objects to enable at suspend
time in clk-rk3288.c and use the standard clock APIs.

C) We could make the rk3288-pmu driver keep a list of clocks to enable
at suspend time.  Presumably this would require a dts and bindings
change.

D) We could just whack the clock on in the existing syscore suspend
function where we whack a bunch of other clocks.  This is particularly
easy because we know for sure that the clock's only parent
("aclk_cpu") is a critical clock so we don't need to do anything more
than ungate it.

In this case I have chosen D) because it seemed like the least work,
but any of the other options would presumably also work fine.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Elaine Zhang <zhangqing@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 355d6a3611db..18460e0993bc 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -856,6 +856,9 @@ static const int rk3288_saved_cru_reg_ids[] = {
 	RK3288_CLKSEL_CON(10),
 	RK3288_CLKSEL_CON(33),
 	RK3288_CLKSEL_CON(37),
+
+	/* We turn aclk_dmac1 on for suspend; this will restore it */
+	RK3288_CLKGATE_CON(10),
 };
 
 static u32 rk3288_saved_cru_regs[ARRAY_SIZE(rk3288_saved_cru_reg_ids)];
@@ -871,6 +874,14 @@ static int rk3288_clk_suspend(void)
 				readl_relaxed(rk3288_cru_base + reg_id);
 	}
 
+	/*
+	 * Going into deep sleep (specifically setting PMU_CLR_DMA in
+	 * RK3288_PMU_PWRMODE_CON1) appears to fail unless
+	 * "aclk_dmac1" is on.
+	 */
+	writel_relaxed(1 << (12 + 16),
+		       rk3288_cru_base + RK3288_CLKGATE_CON(10));
+
 	/*
 	 * Switch PLLs other than DPLL (for SDRAM) to slow mode to
 	 * avoid crashes on resume. The Mask ROM on the system will
-- 
2.20.1



