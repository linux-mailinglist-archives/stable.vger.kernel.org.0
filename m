Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22B7273059
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgIUREY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728897AbgIUQfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:35:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E325223719;
        Mon, 21 Sep 2020 16:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706147;
        bh=AMqtlpsYg4TJy2YB6BCrJGQtQGK/sI2Yjn0FBPjPJPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqD5OntlqRa6rljWE5/EZtTW5hZ5dbxDBmYpSwqu+vTLlAiZS0OQsYJpldSKb/bXp
         NNW1oDe+XYV85bdN6UwszpHkfcV5UVrfj3xliWzbZ0jjQfHCFcFpcMZzByNtLY36ee
         HWYCLdTQezxo6nh00M+vT3Yw1dDRWMQcZeFxsIf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 56/70] clk: rockchip: Fix initialization of mux_pll_src_4plls_p
Date:   Mon, 21 Sep 2020 18:27:56 +0200
Message-Id: <20200921162037.702038002@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit e9c006bc782c488f485ffe50de20b44e1e3daa18 ]

A new warning in Clang points out that the initialization of
mux_pll_src_4plls_p appears incorrect:

../drivers/clk/rockchip/clk-rk3228.c:140:58: warning: suspicious
concatenation of string literals in an array initialization; did you
mean to separate the elements with a comma? [-Wstring-concatenation]
PNAME(mux_pll_src_4plls_p)      = { "cpll", "gpll", "hdmiphy" "usb480m" };
                                                              ^
                                                             ,
../drivers/clk/rockchip/clk-rk3228.c:140:48: note: place parentheses
around the string literal to silence warning
PNAME(mux_pll_src_4plls_p)      = { "cpll", "gpll", "hdmiphy" "usb480m" };
                                                    ^
1 warning generated.

Given the name of the variable and the same variable name in rv1108, it
seems that this should have been four distinct elements. Fix it up by
adding the comma as suggested.

Fixes: 307a2e9ac524 ("clk: rockchip: add clock controller for rk3228")
Link: https://github.com/ClangBuiltLinux/linux/issues/1123
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20200810044020.2063350-1-natechancellor@gmail.com
Reviewed-by: Heiko Stübner <heiko@sntech.de>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3228.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3228.c b/drivers/clk/rockchip/clk-rk3228.c
index 53f16efbb8f4f..31785b3abac50 100644
--- a/drivers/clk/rockchip/clk-rk3228.c
+++ b/drivers/clk/rockchip/clk-rk3228.c
@@ -126,7 +126,7 @@ PNAME(mux_usb480m_p)		= { "usb480m_phy", "xin24m" };
 PNAME(mux_hdmiphy_p)		= { "hdmiphy_phy", "xin24m" };
 PNAME(mux_aclk_cpu_src_p)	= { "cpll_aclk_cpu", "gpll_aclk_cpu", "hdmiphy_aclk_cpu" };
 
-PNAME(mux_pll_src_4plls_p)	= { "cpll", "gpll", "hdmiphy" "usb480m" };
+PNAME(mux_pll_src_4plls_p)	= { "cpll", "gpll", "hdmiphy", "usb480m" };
 PNAME(mux_pll_src_3plls_p)	= { "cpll", "gpll", "hdmiphy" };
 PNAME(mux_pll_src_2plls_p)	= { "cpll", "gpll" };
 PNAME(mux_sclk_hdmi_cec_p)	= { "cpll", "gpll", "xin24m" };
-- 
2.25.1



