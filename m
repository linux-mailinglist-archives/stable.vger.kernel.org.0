Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250B96ADAA2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCGJnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjCGJnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:43:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A8A25963
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:43:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F379BB815B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE5AC433EF;
        Tue,  7 Mar 2023 09:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182195;
        bh=YMA+D2DcQnEsuOpyRXRdLfv5jUW/y9Tg854mncH3ZzM=;
        h=Subject:To:Cc:From:Date:From;
        b=PbwQefLw3X8ZP+H1uZkE1CS+YMIuGSdS1duv+O9itS1RJxsdlMQ5LpV6WQlmgzUyI
         ZanE6M7rIZ+waPdWsqbgLS70G0yiDjRs8AW/gllIlc73K1L0fLcXPNRT4WGfhlOeIk
         bGGGgk5qCqE+R2ZWqUzlyQpxr5hpYLTBC7FNzLEU=
Subject: FAILED: patch "[PATCH] ARM: dts: exynos: correct TMU phandle in Exynos5250" failed to apply to 5.4-stable tree
To:     krzysztof.kozlowski@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:43:12 +0100
Message-ID: <167818219214813@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 33e2c595e2e4016991ead44933a29d1ef93d5f26
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167818219214813@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

33e2c595e2e4 ("ARM: dts: exynos: correct TMU phandle in Exynos5250")
7e86ef5cc896 ("ARM: dts: exynos: Override thermal by label in Exynos5250")

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

