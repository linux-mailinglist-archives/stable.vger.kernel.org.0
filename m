Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E93612F0AC
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgABWTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:19:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgABWTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:19:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB2121582;
        Thu,  2 Jan 2020 22:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003581;
        bh=mhhFsvZD7JJ4GBURdn8QBsD1PYSlO46h7vMKzJUHME0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5XQwFE7b4OVHlTHjFn/YQpb4R0xZUd8ekzPfPj0dGRSAOjtmDAsmxHUAJZyLF70Y
         jJghbntW0XbSNl3qbseF/HC6gHI9zbQB03ck0ckXiekrkiSTHUfZOASsTvA2I4xm/Q
         aBs6GDGUfRYyEVXky9FbgCs1nLl1dJUyG+NtNGbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/114] clk: clk-gpio: propagate rate change to parent
Date:   Thu,  2 Jan 2020 23:06:41 +0100
Message-Id: <20200102220032.059523763@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

[ Upstream commit fc59462c5ce60da119568fac325c92fc6b7c6175 ]

For an external clock source, which is gated via a GPIO, the
rate change should typically be propagated to the parent clock.

The situation where we are requiring this propagation, is when an
external clock is connected to override an internal clock (which typically
has a fixed rate). The external clock can have a different rate than the
internal one, and may also be variable, thus requiring the rate
propagation.

This rate change wasn't propagated until now, and it's unclear about cases
where this shouldn't be propagated. Thus, it's unclear whether this is
fixing a bug, or extending the current driver behavior. Also, it's unsure
about whether this may break any existing setups; in the case that it does,
a device-tree property may be added to disable this flag.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lkml.kernel.org/r/20191108071718.17985-1-alexandru.ardelean@analog.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-gpio.c b/drivers/clk/clk-gpio.c
index 40af4fbab4d2..af9cc00d2d92 100644
--- a/drivers/clk/clk-gpio.c
+++ b/drivers/clk/clk-gpio.c
@@ -248,7 +248,7 @@ static int gpio_clk_driver_probe(struct platform_device *pdev)
 	else
 		clk = clk_register_gpio_gate(&pdev->dev, node->name,
 				parent_names ?  parent_names[0] : NULL, gpiod,
-				0);
+				CLK_SET_RATE_PARENT);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-- 
2.20.1



