Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724441B3CB9
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgDVKIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbgDVKIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:08:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489132076C;
        Wed, 22 Apr 2020 10:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550086;
        bh=S6wAKXdXmDJgv7u1+X6ARKowSlSQupWIYsmGHU1DPC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeIpvu765E9U0SRHoDh81FuLn9r8aSsY8hah1G7Jzd/cxvXHe13x2qOniLutnuR6F
         gIDNFgL3SzRGv1+L7J6W0nj4EXXND8S/gSi6JIXDrLn9t99iI1y8G5b5h2ElQS2lka
         277vCGY2HmFLBXRn48Yix2USfsHUwYVLDhdNTSbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 103/125] clk: at91: usb: continue if clk_hw_round_rate() return zero
Date:   Wed, 22 Apr 2020 11:57:00 +0200
Message-Id: <20200422095049.604355084@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit b0ecf1c6c6e82da4847900fad0272abfd014666d ]

clk_hw_round_rate() may call round rate function of its parents. In case
of SAM9X60 two of USB parrents are PLLA and UPLL. These clocks are
controlled by clk-sam9x60-pll.c driver. The round rate function for this
driver is sam9x60_pll_round_rate() which call in turn
sam9x60_pll_get_best_div_mul(). In case the requested rate is not in the
proper range (rate < characteristics->output[0].min &&
rate > characteristics->output[0].max) the sam9x60_pll_round_rate() will
return a negative number to its caller (called by
clk_core_round_rate_nolock()). clk_hw_round_rate() will return zero in
case a negative number is returned by clk_core_round_rate_nolock(). With
this, the USB clock will continue its rate computation even caller of
clk_hw_round_rate() returned an error. With this, the USB clock on SAM9X60
may not chose the best parent. I detected this after a suspend/resume
cycle on SAM9X60.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lkml.kernel.org/r/1579261009-4573-2-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/at91/clk-usb.c b/drivers/clk/at91/clk-usb.c
index 791770a563fcc..6fac6383d024e 100644
--- a/drivers/clk/at91/clk-usb.c
+++ b/drivers/clk/at91/clk-usb.c
@@ -78,6 +78,9 @@ static int at91sam9x5_clk_usb_determine_rate(struct clk_hw *hw,
 			tmp_parent_rate = req->rate * div;
 			tmp_parent_rate = clk_hw_round_rate(parent,
 							   tmp_parent_rate);
+			if (!tmp_parent_rate)
+				continue;
+
 			tmp_rate = DIV_ROUND_CLOSEST(tmp_parent_rate, div);
 			if (tmp_rate < req->rate)
 				tmp_diff = req->rate - tmp_rate;
-- 
2.20.1



