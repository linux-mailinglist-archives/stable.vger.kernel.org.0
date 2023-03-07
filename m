Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167B56ADAAE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjCGJnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCGJn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:43:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FF33CE1A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:43:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 143C26126D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1F0C4339B;
        Tue,  7 Mar 2023 09:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182204;
        bh=XiPB9tA12RkjF1NQtgntS2ex6gRHQpjxjXH79W7Zsi4=;
        h=Subject:To:Cc:From:Date:From;
        b=fkI+EsXeSGnnDyDmbn5+hiVS4dY1AA5zFx5r9IVBJAgPp9eb/5G349roI2aYWjmlZ
         jh6IRyqNqp7Aksigc9IlABOKxkyhGZljjHWyUgZjJlNk5ZTItUnO4HBRGy4fY++yEY
         wClYrn/QG9DT0WvsKO3kX4pvMpSX8zl6+Yl6E77c=
Subject: FAILED: patch "[PATCH] ARM: dts: exynos: correct TMU phandle in Exynos5250" failed to apply to 4.19-stable tree
To:     krzysztof.kozlowski@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:43:13 +0100
Message-ID: <1678182193224134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 33e2c595e2e4016991ead44933a29d1ef93d5f26
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678182193224134@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

33e2c595e2e4 ("ARM: dts: exynos: correct TMU phandle in Exynos5250")
7e86ef5cc896 ("ARM: dts: exynos: Override thermal by label in Exynos5250")
be00300147ae ("ARM: dts: exynos: Move pmu and timer nodes out of soc")
670734f55810 ("ARM: dts: exynos: Add all CPUs in cooling maps")
eb9e16d8573e ("ARM: dts: exynos: Convert exynos5250.dtsi to opp-v2 bindings")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 33e2c595e2e4016991ead44933a29d1ef93d5f26 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 9 Feb 2023 11:58:38 +0100
Subject: [PATCH] ARM: dts: exynos: correct TMU phandle in Exynos5250

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.

Cc: <stable@vger.kernel.org>
Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Link: https://lore.kernel.org/r/20230209105841.779596-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 4708dcd575a7..01751706ff96 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1107,7 +1107,7 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
+	thermal-sensors = <&tmu>;
 
 	cooling-maps {
 		map0 {

