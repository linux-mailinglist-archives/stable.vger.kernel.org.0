Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0C21676A9
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbgBUIFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731748AbgBUIFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E70224670;
        Fri, 21 Feb 2020 08:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272304;
        bh=BvI1Wvm5Gi7agi+XZRfqk2PKyoFwI1R06nXhT/Qs+S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+IA/FIviTZlfp5k+Y3sGO2W0MuBk4V0JindT1MWoFwg19P3i9qgscPv5Rriy+Kdd
         FVUaYwojNzKFQk17sA11NvZlYe4u2ajbghh2iiLREXJsBRmmApez2C5CK38nSk/qyA
         Kf8QZ/IGON+ulU6WSNrfF5zgc73n3OCxMiTGriSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/344] clk: qcom: rcg2: Dont crash if our parent cant be found; return an error
Date:   Fri, 21 Feb 2020 08:38:11 +0100
Message-Id: <20200221072357.319340100@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 908b050114d8fefdddc57ec9fbc213c3690e7f5f ]

When I got my clock parenting slightly wrong I ended up with a crash
that looked like this:

  Unable to handle kernel NULL pointer dereference at virtual
  address 0000000000000000
  ...
  pc : clk_hw_get_rate+0x14/0x44
  ...
  Call trace:
   clk_hw_get_rate+0x14/0x44
   _freq_tbl_determine_rate+0x94/0xfc
   clk_rcg2_determine_rate+0x2c/0x38
   clk_core_determine_round_nolock+0x4c/0x88
   clk_core_round_rate_nolock+0x6c/0xa8
   clk_core_round_rate_nolock+0x9c/0xa8
   clk_core_set_rate_nolock+0x70/0x180
   clk_set_rate+0x3c/0x6c
   of_clk_set_defaults+0x254/0x360
   platform_drv_probe+0x28/0xb0
   really_probe+0x120/0x2dc
   driver_probe_device+0x64/0xfc
   device_driver_attach+0x4c/0x6c
   __driver_attach+0xac/0xc0
   bus_for_each_dev+0x84/0xcc
   driver_attach+0x2c/0x38
   bus_add_driver+0xfc/0x1d0
   driver_register+0x64/0xf8
   __platform_driver_register+0x4c/0x58
   msm_drm_register+0x5c/0x60
   ...

It turned out that clk_hw_get_parent_by_index() was returning NULL and
we weren't checking.  Let's check it so that we don't crash.

Fixes: ac269395cdd8 ("clk: qcom: Convert to clk_hw based provider APIs")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lkml.kernel.org/r/20200203103049.v4.1.I7487325fe8e701a68a07d3be8a6a4b571eca9cfa@changeid
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 5174222cbfab2..a88101480e337 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -217,6 +217,9 @@ static int _freq_tbl_determine_rate(struct clk_hw *hw, const struct freq_tbl *f,
 
 	clk_flags = clk_hw_get_flags(hw);
 	p = clk_hw_get_parent_by_index(hw, index);
+	if (!p)
+		return -EINVAL;
+
 	if (clk_flags & CLK_SET_RATE_PARENT) {
 		rate = f->freq;
 		if (f->pre_div) {
-- 
2.20.1



