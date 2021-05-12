Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8BC37CD45
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbhELQxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243746AbhELQmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 889F861971;
        Wed, 12 May 2021 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835585;
        bh=VzURwon8NUEYzyv9nLyfGmon0Aw6bybOR2rs7eCOplU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjgDdJiIO2SObCdXYCkqO395gynfivhbpHIJwxWumYdWenlCvV9XMDlpw6ekDAtW4
         GFTZS0HidLXax67lMAPvQsCuduA3F3Nnu6PjeKgnddZxcxNs1q8vPDU3ufQ6HjpO1L
         XVQoudF6I7IfwbPg4vbEav/xKYmNDjV3eBow9MxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 402/677] clk: zynqmp: pll: add set_pll_mode to check condition in zynqmp_pll_enable
Date:   Wed, 12 May 2021 16:47:28 +0200
Message-Id: <20210512144850.693925668@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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



