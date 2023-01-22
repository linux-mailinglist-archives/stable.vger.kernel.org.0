Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A05676F73
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjAVPWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjAVPWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840A9227AB
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF49760C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4361C433D2;
        Sun, 22 Jan 2023 15:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400886;
        bh=hdDctq0OIG8Qzl/XRIjTOmR9EYtDx7UQopSoOZrtagA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQnRzWG2TsR0Sp7yemIPNypvD9QV5czIEHrtI1tK38bWMFrMeFGxc/u2lNlePrNe2
         pHWYqcQhxKT9ZWwZbI0tJ4hNnMbHeMLL4YYlVM1PzEd926ZBZDur9LODXaXloLKPL5
         0vw0u84rdEE1V/tpuVJN/nEgE0ZzapkenkkxfclA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/193] of: fdt: Honor CONFIG_CMDLINE* even without /chosen node, take 2
Date:   Sun, 22 Jan 2023 16:02:37 +0100
Message-Id: <20230122150247.676152452@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 064e32dc5b03114d0767893fecdaf7b5dfd8c286 ]

I do not read a strict requirement on /chosen node in either ePAPR or in
Documentation/devicetree. Help text for CONFIG_CMDLINE and
CONFIG_CMDLINE_EXTEND doesn't make their behavior explicitly dependent on
the presence of /chosen or the presense of /chosen/bootargs.

However the early check for /chosen and bailing out in
early_init_dt_scan_chosen() skips CONFIG_CMDLINE handling which is not
really related to /chosen node or the particular method of passing cmdline
from bootloader.

This leads to counterintuitive combinations (assuming
CONFIG_CMDLINE_EXTEND=y):

a) bootargs="foo", CONFIG_CMDLINE="bar" => cmdline=="foo bar"
b) /chosen missing, CONFIG_CMDLINE="bar" => cmdline==""
c) bootargs="", CONFIG_CMDLINE="bar" => cmdline==" bar"

Rework early_init_dt_scan_chosen() so that the cmdline config options are
always handled.

[commit msg written by Alexander Sverdlin]

Cc: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Tested-by: Geoff Levand <geoff@infradead.org>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://lore.kernel.org/r/20230103-dt-cmdline-fix-v1-2-7038e88b18b6@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 4f88e8bbdd27..f08b25195ae7 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1163,18 +1163,32 @@ int __init early_init_dt_scan_chosen(char *cmdline)
 	if (node < 0)
 		node = fdt_path_offset(fdt, "/chosen@0");
 	if (node < 0)
-		return -ENOENT;
+		/* Handle the cmdline config options even if no /chosen node */
+		goto handle_cmdline;
 
 	chosen_node_offset = node;
 
 	early_init_dt_check_for_initrd(node);
 	early_init_dt_check_for_elfcorehdr(node);
 
+	rng_seed = of_get_flat_dt_prop(node, "rng-seed", &l);
+	if (rng_seed && l > 0) {
+		add_bootloader_randomness(rng_seed, l);
+
+		/* try to clear seed so it won't be found. */
+		fdt_nop_property(initial_boot_params, node, "rng-seed");
+
+		/* update CRC check value */
+		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
+	}
+
 	/* Retrieve command line */
 	p = of_get_flat_dt_prop(node, "bootargs", &l);
 	if (p != NULL && l > 0)
 		strscpy(cmdline, p, min(l, COMMAND_LINE_SIZE));
 
+handle_cmdline:
 	/*
 	 * CONFIG_CMDLINE is meant to be a default in case nothing else
 	 * managed to set the command line, unless CONFIG_CMDLINE_FORCE
@@ -1195,18 +1209,6 @@ int __init early_init_dt_scan_chosen(char *cmdline)
 
 	pr_debug("Command line is: %s\n", (char *)cmdline);
 
-	rng_seed = of_get_flat_dt_prop(node, "rng-seed", &l);
-	if (rng_seed && l > 0) {
-		add_bootloader_randomness(rng_seed, l);
-
-		/* try to clear seed so it won't be found. */
-		fdt_nop_property(initial_boot_params, node, "rng-seed");
-
-		/* update CRC check value */
-		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
-	}
-
 	return 0;
 }
 
-- 
2.35.1



