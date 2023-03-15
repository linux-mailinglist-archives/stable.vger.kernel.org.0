Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F696BB054
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjCOMRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCOMRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186BA93119
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7948661D44
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623BCC433EF;
        Wed, 15 Mar 2023 12:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882622;
        bh=GZo1/HfV69uSctWybylEbuTrnOdmp0VEt15Un82YHPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCb1LFqws2JGnNs5usKr6n7BzEROjqsCRLfW33SA/BHSlzXKfPUr/jmBlmX9rgbmI
         xtIwjlOkN/O+WdOM8//U9SshurP6QEgyD+TnGhk0cc7o3ybZ9jKLi54dTbWWNBc7e+
         q17dlz+A9gFuMeSv3ChqvHxwRn9c3htKvmygFR88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/39] ARM: dts: exynos: correct TMU phandle in Exynos4210
Date:   Wed, 15 Mar 2023 13:12:30 +0100
Message-Id: <20230315115721.836485041@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 408ab6786dbf6dd696488054c9559681112ef994 ]

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property is
already defined in included exynos4-cpu-thermal.dtsi, drop it from
exynos4210.dtsi to fix the error and remoev redundancy.

Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4210.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 2ec6c01550564..24bea84034af2 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -387,7 +387,6 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {
-- 
2.39.2



