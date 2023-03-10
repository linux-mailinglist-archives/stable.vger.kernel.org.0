Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D946B498B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjCJPNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbjCJPNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:13:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6E3139D21
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:04:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3DDA61A73
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5C6C433D2;
        Fri, 10 Mar 2023 15:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460605;
        bh=YQFDISbfZVv8vwZmuiogaISbE9fiefzSNORpVxiaHg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBgxapP470zfWb/kkBJOyrjRAFFgGiEaFX0V5B5oZL+4yGPr+aSP9cYWj0uxaFO3+
         rUw5OyWb+PGjiFrdWHd1nBjxjfbcfODyqCxjZ+I4CffxuGnzebM4TSU6UxHQEN1fbu
         RiKvdRZkm7PmhHWQXCcjSuJ6nOYioYpfK9WV/D0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.10 391/529] ARM: dts: exynos: correct TMU phandle in Exynos4210
Date:   Fri, 10 Mar 2023 14:38:54 +0100
Message-Id: <20230310133823.131501184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 408ab6786dbf6dd696488054c9559681112ef994 upstream.

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property is
already defined in included exynos4-cpu-thermal.dtsi, drop it from
exynos4210.dtsi to fix the error and remoev redundancy.

Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos4210.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -382,7 +382,6 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {


