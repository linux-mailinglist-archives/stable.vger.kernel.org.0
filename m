Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584C73EC611
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 01:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbhHNX5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 19:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbhHNX5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 19:57:53 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7264C0613CF
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 16:57:23 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g13so27024075lfj.12
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 16:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AdCTBaA9Glsngsdr3pyqLLw8trkmQt1Ycmzpqp2rJpw=;
        b=e/lW3SLNmsYpcYIc6GcDc7pvq+Q6mq7u2fMlYfmvNMnyuJXZ2xHzVqUHrw56mZ5FDG
         TkUFNCiD67GNgfiGQpjVVWhq7BLlwbPkjF0/xwk7Wyq874cWU4wF1o9vleD3BLxeEwr8
         b9hb0JZsZQzLyBGtuWgkcX267qIYr6X6O4DE/vkBxAXLvtGikHBngeWp+8xJ7OeHOSyt
         dXfBLnWqaaToDTNWFa6CPgtEsW9owDENSwByRvfi+fMNA1txKtZ6/r4nSJLH1GaY5bDa
         CP4+T08/TWZE3ZngvkKIKt4cw73QEC28dAcUJOjGV3ShintdAgOW039XyIFtNd8gLfct
         7H6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AdCTBaA9Glsngsdr3pyqLLw8trkmQt1Ycmzpqp2rJpw=;
        b=Ho41GiS+LZzFtrIflR57ql3OV3styc3m3w0JoeU9uYabqSFHRKOT/Ax/uzaEnWm7t4
         I8ZuNraIMeBDWa7kfPJU6UaSPboUTuMopPgTqRp3vaBk8T53ugG4q4PTh+sAnU179m0H
         e1ORmaav4EV98MhXMjprDi+Kb8VWVny9EpMG56yqo4vNi+ad9MZTPXtce8ssbxhYOq2o
         RSfbrAuhas8RplziVHO9nouRHBRHvjfnNzwzG9oc73Q5Y5i6sHVJ7cSVxmEEmGea5V7R
         gG79Osj3gm1x5hrzouqO2w0omUMfwga5/hpEjd9EN56Gp5GCI4xcxXPV34zy0wF5Ewvs
         MT/g==
X-Gm-Message-State: AOAM531UDjj8NTm8t+EUSSRtdKQ+C9Wr+rb++pa6ghidAP6Ud2DOojTc
        dRVOz5m77vidqccDPqJdk4Ic6A==
X-Google-Smtp-Source: ABdhPJzRYfv9UC4yMQI18Os6alKkBllw2NKdWdS6zHwQqviF6jL9LueVoa7ThERx4a6dz17oo6KTZg==
X-Received: by 2002:a05:6512:3c9d:: with SMTP id h29mr6561804lfv.600.1628985442064;
        Sat, 14 Aug 2021 16:57:22 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id 13sm441727ljf.110.2021.08.14.16.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 16:57:21 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     linux-clk@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH] clk: kirkwood: Fix a clocking boot regression
Date:   Sun, 15 Aug 2021 01:55:14 +0200
Message-Id: <20210814235514.403426-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since a few kernel releases the Pogoplug 4 has crashed like this
during boot:

Unable to handle kernel NULL pointer dereference at virtual address 00000002
(...)
[<c04116ec>] (strlen) from [<c00ead80>] (kstrdup+0x1c/0x4c)
[<c00ead80>] (kstrdup) from [<c04591d8>] (__clk_register+0x44/0x37c)
[<c04591d8>] (__clk_register) from [<c04595ec>] (clk_hw_register+0x20/0x44)
[<c04595ec>] (clk_hw_register) from [<c045bfa8>] (__clk_hw_register_mux+0x198/0x1e4)
[<c045bfa8>] (__clk_hw_register_mux) from [<c045c050>] (clk_register_mux_table+0x5c/0x6c)
[<c045c050>] (clk_register_mux_table) from [<c0acf3e0>] (kirkwood_clk_muxing_setup.constprop.0+0x13c/0x1ac)
[<c0acf3e0>] (kirkwood_clk_muxing_setup.constprop.0) from [<c0aceae0>] (of_clk_init+0x12c/0x214)
[<c0aceae0>] (of_clk_init) from [<c0ab576c>] (time_init+0x20/0x2c)
[<c0ab576c>] (time_init) from [<c0ab3d18>] (start_kernel+0x3dc/0x56c)
[<c0ab3d18>] (start_kernel) from [<00000000>] (0x0)
Code: e3130020 1afffffb e12fff1e c08a1078 (e5d03000)

This is because the "powersave" mux clock 0 was provided in an unterminated
array, which is required by the loop in the driver:

        /* Count, allocate, and register clock muxes */
        for (n = 0; desc[n].name;)
                n++;

Here n will go out of bounds and then call clk_register_mux() on random
memory contents after the mux clock.

Fix this by terminating the array with a blank entry.

Fixes: 105299381d87 ("cpufreq: kirkwood: use the powersave multiplexer")
Cc: stable@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/clk/mvebu/kirkwood.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
index 47680237d0be..43b31af3a2ce 100644
--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -265,6 +265,7 @@ static const char *powersave_parents[] = {
 static const struct clk_muxing_soc_desc kirkwood_mux_desc[] __initconst = {
 	{ "powersave", powersave_parents, ARRAY_SIZE(powersave_parents),
 		11, 1, 0 },
+	{ },
 };
 
 static struct clk *clk_muxing_get_src(
-- 
2.31.1

