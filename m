Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D7910BE4F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfK0VfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbfK0Utt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:49:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7CFE2158A;
        Wed, 27 Nov 2019 20:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887789;
        bh=oMoPkCwY6kDzGS2Li0xLQGa17DHyFG0V1ZNnzIwiQfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1IVXbK4WslTwk3YrHfDz/0TV0oWgGGvMiwut7oyKF4WhPDuJAF0vFDvuhe4QddkS
         ByIexcHdFTRd0SE4JQxu9FQNbyIbBpPZIKhVhKlieV2urTtPwkkv69ADlrJ101k/YL
         EKHpyMYc0hlABv5ukq82DvU66ZdoJ7NHzKfy43e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/211] clk: at91: audio-pll: fix audio pmc type
Date:   Wed, 27 Nov 2019 21:29:45 +0100
Message-Id: <20191127203058.982189454@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 7fa75007b7d7421aea59ff2b12ab1bd65a5abfa6 ]

The allocation for the audio pmc is using the size of struct clk_audio_pad
instead of struct clk_audio_pmc. This works fine because the former is
larger than the latter but it is safer to be correct.

Fixes: ("0865805d82d4 clk: at91: add audio pll clock drivers")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-audio-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-audio-pll.c b/drivers/clk/at91/clk-audio-pll.c
index da7bafcfbe706..b3eaf654fac98 100644
--- a/drivers/clk/at91/clk-audio-pll.c
+++ b/drivers/clk/at91/clk-audio-pll.c
@@ -509,7 +509,7 @@ static void __init of_sama5d2_clk_audio_pll_pad_setup(struct device_node *np)
 
 static void __init of_sama5d2_clk_audio_pll_pmc_setup(struct device_node *np)
 {
-	struct clk_audio_pad *apmc_ck;
+	struct clk_audio_pmc *apmc_ck;
 	struct clk_init_data init = {};
 
 	apmc_ck = kzalloc(sizeof(*apmc_ck), GFP_KERNEL);
-- 
2.20.1



