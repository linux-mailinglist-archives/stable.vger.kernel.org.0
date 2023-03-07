Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910C36ADA90
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCGJml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCGJmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:42:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF58C4FF0B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:42:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5029761298
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44871C433D2;
        Tue,  7 Mar 2023 09:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182154;
        bh=PLsR2qTep+JyKhDi0OXMgxDM2G1LOuLmSTz5Djp5lV8=;
        h=Subject:To:Cc:From:Date:From;
        b=vhi1eYaP3yvbz8vb/8Wp8+K6jMuW8XC+793/G8JvRYNkg2Oid8p0GO7vDYMH7YZNu
         wPG5nbQ1cH2y6eR6JfoljVW1SIvZONyxzzhB1cOqAUQ1sXrZoPtRU6MgLO0ln9nNCE
         VAYQPPAkPyFEyfXNPeddbZAVbUUc/WvLDbOfEbq4=
Subject: FAILED: patch "[PATCH] ARM: dts: exynos: correct TMU phandle in Exynos4210" failed to apply to 5.4-stable tree
To:     krzysztof.kozlowski@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:42:31 +0100
Message-ID: <16781821519722@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 408ab6786dbf6dd696488054c9559681112ef994
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781821519722@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

408ab6786dbf ("ARM: dts: exynos: correct TMU phandle in Exynos4210")
1708f56081e2 ("ARM: dts: exynos: Override thermal by label in Exynos4210")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 408ab6786dbf6dd696488054c9559681112ef994 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 9 Feb 2023 11:58:37 +0100
Subject: [PATCH] ARM: dts: exynos: correct TMU phandle in Exynos4210

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property is
already defined in included exynos4-cpu-thermal.dtsi, drop it from
exynos4210.dtsi to fix the error and remoev redundancy.

Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 2c25cc37934e..f8c6c5d1906a 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -393,7 +393,6 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {

