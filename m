Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033133DC2D5
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 05:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbhGaDAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 23:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhGaDAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 23:00:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282BBC0613D3
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 20:00:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so17069175pjh.3
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 20:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7zBw9j8ybMQuBdxwfQuqsf44R15K6SeWh2IGwK7jYag=;
        b=AFeGOzugL2CydbYFfVBGXeQsERjhKiOR7cLKK9mH1vwwDKVlzEQrfLwYulqpIyTi4e
         8t+OKJflW7gNEp3XrrsYuKxs23+p/YpIArovmBT32hzRfdFn+1LPhzfp27KCOEdl+3v5
         LE22Hk5y+g6DFeMSX5Yx+saYUhR6PlEOPM6Kc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7zBw9j8ybMQuBdxwfQuqsf44R15K6SeWh2IGwK7jYag=;
        b=SxC7IwSAlsDLx6KMYAsniHHoWEsiVqmGIaPuCRlfJ9pLCGaHs00R7e3rNoJISCK/Ra
         Qz5aKVu/dZQLkHLBNfmnCXRHlfKK9HW2KzfqRKnectq6SR3Mh1FLOGdkGgfxwwOi95zL
         MH+hlSD/TLTDj40fUjrRIalMBzbUMtapRdymWWr+7sZsMwJkUHHqqj1nZBNnOW3/HO2L
         HqQRW+i20qIsiPo0ks33fbmeX7Yk2ojuHthyJcSwhMCiYdlOiVomjp2XL5nEowBO5oKh
         yxNzsEmq/jydIoTR4Y7dpSEV+gbI6PLUKCTqLN1s8qGfvSXjTozPl91rRF2EId2p5mNi
         Ci+g==
X-Gm-Message-State: AOAM5312lHo703PSGyIDgg6zcwkWxMVk3W8YAyc30nyPkyLa4VYGn08B
        Tpv/gG7RdarZZQxH9u0J7+H0yg==
X-Google-Smtp-Source: ABdhPJyw54CZg0S63WEjJqxwTtP1chxHRehf4lfBegCGvCSHFX0+TM/K7LN3lD50p8VFWCNIF/ZR5w==
X-Received: by 2002:a62:ab0a:0:b029:33b:6d08:2a45 with SMTP id p10-20020a62ab0a0000b029033b6d082a45mr5767695pff.38.1627700403643;
        Fri, 30 Jul 2021 20:00:03 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:d273:6afe:a426:39e7])
        by smtp.gmail.com with ESMTPSA id l14sm3825416pfd.58.2021.07.30.20.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 20:00:03 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     linux-clk@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dong Aisheng <aisheng.dong@nxp.com>, stable@vger.kernel.org
Subject: [PATCH] clk: fix leak on devm_clk_bulk_get_all() unwind
Date:   Fri, 30 Jul 2021 19:59:50 -0700
Message-Id: <20210731025950.2238582-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

clk_bulk_get_all() allocates an array of struct clk_bulk data for us
(unlike clk_bulk_get()), so we need to free it. Let's use the
clk_bulk_put_all() helper.

kmemleak complains, on an RK3399 Gru/Kevin system:

unreferenced object 0xffffff80045def00 (size 128):
  comm "swapper/0", pid 1, jiffies 4294667682 (age 86.394s)
  hex dump (first 32 bytes):
    44 32 60 fe fe ff ff ff 00 00 00 00 00 00 00 00  D2`.............
    48 32 60 fe fe ff ff ff 00 00 00 00 00 00 00 00  H2`.............
  backtrace:
    [<00000000742860d6>] __kmalloc+0x22c/0x39c
    [<00000000b0493f2c>] clk_bulk_get_all+0x64/0x188
    [<00000000325f5900>] devm_clk_bulk_get_all+0x58/0xa8
    [<00000000175b9bc5>] dwc3_probe+0x8ac/0xb5c
    [<000000009169e2f9>] platform_drv_probe+0x9c/0xbc
    [<000000005c51e2ee>] really_probe+0x13c/0x378
    [<00000000c47b1f24>] driver_probe_device+0x84/0xc0
    [<00000000f870fcfb>] __device_attach_driver+0x94/0xb0
    [<000000004d1b92ae>] bus_for_each_drv+0x8c/0xd8
    [<00000000481d60c3>] __device_attach+0xc4/0x150
    [<00000000a163bd36>] device_initial_probe+0x1c/0x28
    [<00000000accb6bad>] bus_probe_device+0x3c/0x9c
    [<000000001a199f89>] device_add+0x218/0x3cc
    [<000000001bd84952>] of_device_add+0x40/0x50
    [<000000009c658c29>] of_platform_device_create_pdata+0xac/0x100
    [<0000000021c69ba4>] of_platform_bus_create+0x190/0x224

Fixes: f08c2e2865f6 ("clk: add managed version of clk_bulk_get_all")
Cc: Dong Aisheng <aisheng.dong@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
Never mind that kmemleak appears broken on 5.14-rc3+... but I caught the
leak on an earlier kernel.

 drivers/clk/clk-devres.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index be160764911b..f9d5b7334341 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -92,13 +92,20 @@ int __must_check devm_clk_bulk_get_optional(struct device *dev, int num_clks,
 }
 EXPORT_SYMBOL_GPL(devm_clk_bulk_get_optional);
 
+static void devm_clk_bulk_release_all(struct device *dev, void *res)
+{
+	struct clk_bulk_devres *devres = res;
+
+	clk_bulk_put_all(devres->num_clks, devres->clks);
+}
+
 int __must_check devm_clk_bulk_get_all(struct device *dev,
 				       struct clk_bulk_data **clks)
 {
 	struct clk_bulk_devres *devres;
 	int ret;
 
-	devres = devres_alloc(devm_clk_bulk_release,
+	devres = devres_alloc(devm_clk_bulk_release_all,
 			      sizeof(*devres), GFP_KERNEL);
 	if (!devres)
 		return -ENOMEM;
-- 
2.32.0.554.ge1b32706d8-goog

