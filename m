Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E772F5BC
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbfE3Eti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728401AbfE3DLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:10 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F310C24476;
        Thu, 30 May 2019 03:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185870;
        bh=PDSOmHvRNjoz1b2d9autjhaMFPH4WSNsyzQs/WTlYD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swokf1enbCHakbjFZjrBDtCGzBScMu7YX4CY7fp9P7vJ/Bcld6M9WK8SMTMxjRzFj
         7sCTRIyew2cVuz6pJ5siy1/bUONziM8Of7ZV4iIWUumVSHBjTTCoPRqW0yRnBseIHm
         9NLBa9jZZGqXM6uL05s5iVHeuWSoxNVGGPthHnQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        Randy Li <ayaka@soulik.info>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 211/405] clk: rockchip: Fix video codec clocks on rk3288
Date:   Wed, 29 May 2019 20:03:29 -0700
Message-Id: <20190530030551.780911131@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 00c0cd9e59d265b393553e9afa54fee8b10e8158 ]

It appears that there is a typo in the rk3288 TRM.  For
GRF_SOC_CON0[7] it says that 0 means "vepu" and 1 means "vdpu".  It's
the other way around.

How do I know?  Here's my evidence:

1. Prior to commit 4d3e84f99628 ("clk: rockchip: describe aclk_vcodec
   using the new muxgrf type on rk3288") we always pretended that we
   were using "aclk_vdpu" and the comment in the code said that this
   matched the default setting in the system.  In fact the default
   setting is 0 according to the TRM and according to reading memory
   at bootup.  In addition rk3288-based Chromebooks ran like this and
   the video codecs worked.
2. With the existing clock code if you boot up and try to enable the
   new VIDEO_ROCKCHIP_VPU as a module (and without "clk_ignore_unused"
   on the command line), you get errors like "failed to get ack on
   domain 'pd_video', val=0x80208".  After flipping vepu/vdpu things
   init OK.
3. If I export and add both the vepu and vdpu to the list of clocks
   for RK3288_PD_VIDEO I can get past the power domain errors, but now
   I freeze when the vpu_mmu gets initted.
4. If I just mark the "vdpu" as IGNORE_UNUSED then everything boots up
   and probes OK showing that somehow the "vdpu" was important to keep
   enabled.  This is because we were actually using it as a parent.
5. After this change I can hack "aclk_vcodec_pre" to parent from
   "aclk_vepu" using assigned-clocks and the video codec still probes
   OK.
6. Rockchip has said so on the mailing list [1].

...so let's fix it.

Let's also add CLK_SET_RATE_PARENT to "aclk_vcodec_pre" as suggested
by Jonas Karlman.  Prior to the same commit you could do
clk_set_rate() on "aclk_vcodec" and it would change "aclk_vdpu".
That's because "aclk_vcodec" was a simple gate clock (always gets
CLK_SET_RATE_PARENT) and its direct parent was "aclk_vdpu".  After
that commit "aclk_vcodec_pre" gets in the way so we need to add
CLK_SET_RATE_PARENT to it too.

[1] https://lkml.kernel.org/r/1d17b015-9e17-34b9-baf8-c285dc1957aa@rock-chips.com

Fixes: 4d3e84f99628 ("clk: rockchip: describe aclk_vcodec using the new muxgrf type on rk3288")
Suggested-by: Jonas Karlman <jonas@kwiboo.se>
Suggested-by: Randy Li <ayaka@soulik.info>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index f3bbcdfa88ead..623c5f684987c 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -219,7 +219,7 @@ PNAME(mux_hsadcout_p)	= { "hsadc_src", "ext_hsadc" };
 PNAME(mux_edp_24m_p)	= { "ext_edp_24m", "xin24m" };
 PNAME(mux_tspout_p)	= { "cpll", "gpll", "npll", "xin27m" };
 
-PNAME(mux_aclk_vcodec_pre_p)	= { "aclk_vepu", "aclk_vdpu" };
+PNAME(mux_aclk_vcodec_pre_p)	= { "aclk_vdpu", "aclk_vepu" };
 PNAME(mux_usbphy480m_p)		= { "sclk_otgphy1_480m", "sclk_otgphy2_480m",
 				    "sclk_otgphy0_480m" };
 PNAME(mux_hsicphy480m_p)	= { "cpll", "gpll", "usbphy480m_src" };
@@ -420,7 +420,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE(0, "aclk_vdpu", mux_pll_src_cpll_gpll_usb480m_p, 0,
 			RK3288_CLKSEL_CON(32), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 11, GFLAGS),
-	MUXGRF(0, "aclk_vcodec_pre", mux_aclk_vcodec_pre_p, 0,
+	MUXGRF(0, "aclk_vcodec_pre", mux_aclk_vcodec_pre_p, CLK_SET_RATE_PARENT,
 			RK3288_GRF_SOC_CON(0), 7, 1, MFLAGS),
 	GATE(ACLK_VCODEC, "aclk_vcodec", "aclk_vcodec_pre", 0,
 		RK3288_CLKGATE_CON(9), 0, GFLAGS),
-- 
2.20.1



