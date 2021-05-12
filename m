Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3A337C935
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbhELQPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235185AbhELQIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5E5A61C65;
        Wed, 12 May 2021 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833965;
        bh=VzURwon8NUEYzyv9nLyfGmon0Aw6bybOR2rs7eCOplU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaQwYeFCeNi/800qyt/3CbPTIdeeHW0QfNx1i8iOpBPyJzYD+rSbJoFyGwVHQo72I
         sZF9e4gXABQnOuTcKuiZbbmoX11lowGfcK1FGPD62unsiUkJlVJbh5L5wG4ypw8c+h
         k5WV6fBLXyZSODRp3soKGTOd6zTq5AdJcRkGSpDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 357/601] clk: zynqmp: pll: add set_pll_mode to check condition in zynqmp_pll_enable
Date:   Wed, 12 May 2021 16:47:14 +0200
Message-Id: <20210512144839.552521952@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 394cdb69a3c30b33524cf1204afe5cceaba69cdc ]

If there is a IOCTL_SET_PLL_FRAC_MODE request sent to ATF ever,
we shouldn't skip invoking PM_CLOCK_ENABLE fn even though this
pll has been enabled. In ATF implementation, it will only assign
the mode to the variable (struct pm_pll *)pll->mode when handling
IOCTL_SET_PLL_FRAC_MODE call. Invoking PM_CLOCK_ENABLE can force
ATF send request to PWU to set the pll mode to PLL's register.

There is a scenario that happens in enabling VPLL_INT(clk_id:96):
1) VPLL_INT has been enabled during booting.
2) A driver calls clk_set_rate and according to the rate, the VPLL_INT
   should be set to FRAC mode. Then zynqmp_pll_set_mode is called
   to pass IOCTL_SET_PLL_FRAC_MODE to ATF. Note that at this point
   ATF just stores the mode to a variable.
3) This driver calls clk_prepare_enable and zynqmp_pll_enable is
   called to try to enable VPLL_INT pll. Because of 1), the function
   zynqmp_pll_enable just returns without doing anything after checking
   that this pll has been enabled.

In the scenario above, the pll mode of VPLL_INT will never be set
successfully. So adding set_pll_mode to check condition to fix it.

Fixes: 3fde0e16d016 ("drivers: clk: Add ZynqMP clock driver")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20210406153131.601701-1-quanyang.wang@windriver.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/pll.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/zynqmp/pll.c b/drivers/clk/zynqmp/pll.c
index 03bfe62c1e62..abe6afbf3407 100644
--- a/drivers/clk/zynqmp/pll.c
+++ b/drivers/clk/zynqmp/pll.c
@@ -14,10 +14,12 @@
  * struct zynqmp_pll - PLL clock
  * @hw:		Handle between common and hardware-specific interfaces
  * @clk_id:	PLL clock ID
+ * @set_pll_mode:	Whether an IOCTL_SET_PLL_FRAC_MODE request be sent to ATF
  */
 struct zynqmp_pll {
 	struct clk_hw hw;
 	u32 clk_id;
+	bool set_pll_mode;
 };
 
 #define to_zynqmp_pll(_hw)	container_of(_hw, struct zynqmp_pll, hw)
@@ -81,6 +83,8 @@ static inline void zynqmp_pll_set_mode(struct clk_hw *hw, bool on)
 	if (ret)
 		pr_warn_once("%s() PLL set frac mode failed for %s, ret = %d\n",
 			     __func__, clk_name, ret);
+	else
+		clk->set_pll_mode = true;
 }
 
 /**
@@ -240,9 +244,15 @@ static int zynqmp_pll_enable(struct clk_hw *hw)
 	u32 clk_id = clk->clk_id;
 	int ret;
 
-	if (zynqmp_pll_is_enabled(hw))
+	/*
+	 * Don't skip enabling clock if there is an IOCTL_SET_PLL_FRAC_MODE request
+	 * that has been sent to ATF.
+	 */
+	if (zynqmp_pll_is_enabled(hw) && (!clk->set_pll_mode))
 		return 0;
 
+	clk->set_pll_mode = false;
+
 	ret = zynqmp_pm_clock_enable(clk_id);
 	if (ret)
 		pr_warn_once("%s() clock enable failed for %s, ret = %d\n",
-- 
2.30.2



