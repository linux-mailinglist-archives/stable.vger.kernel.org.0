Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009B7499E47
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1588268AbiAXWbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584597AbiAXWV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC54C0424E7;
        Mon, 24 Jan 2022 12:52:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76509B81218;
        Mon, 24 Jan 2022 20:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A030C340E5;
        Mon, 24 Jan 2022 20:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057519;
        bh=RwgNWwgC6tm4OmIYkTg6If1aFsmpPow52E85Zp5Xwvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEVoA2hFwIKhYwJp/dSeVtIgHAoQP1WZs/I5TmLSQV3qlHjFBlb5XpIeZcuPPqcwE
         a5z9DhU6OqYtr1fudBe1wa1VOqPC9LKvhk3YgyNMI84KbYrEiI2IyovSC7C2LlgeKx
         Umgl5X5BUDoM5ROm6/jzJMlb5S8/ctl4vTtsdBkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Rob Herring <robh@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.15 840/846] dt-bindings: watchdog: Require samsung,syscon-phandle for Exynos7
Date:   Mon, 24 Jan 2022 19:45:57 +0100
Message-Id: <20220124184129.880609350@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Protsenko <semen.protsenko@linaro.org>

commit 33950f9a36aca55c2b1e6062d9b29f3e97f91c40 upstream.

Exynos7 watchdog driver is clearly indicating that its dts node must
define syscon phandle property. That was probably forgotten, so add it.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Fixes: 2b9366b66967 ("watchdog: s3c2410_wdt: Add support for Watchdog device on Exynos7")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20211107202943.8859-2-semen.protsenko@linaro.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml
+++ b/Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml
@@ -39,8 +39,8 @@ properties:
   samsung,syscon-phandle:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-      Phandle to the PMU system controller node (in case of Exynos5250
-      and Exynos5420).
+      Phandle to the PMU system controller node (in case of Exynos5250,
+      Exynos5420 and Exynos7).
 
 required:
   - compatible
@@ -58,6 +58,7 @@ allOf:
             enum:
               - samsung,exynos5250-wdt
               - samsung,exynos5420-wdt
+              - samsung,exynos7-wdt
     then:
       required:
         - samsung,syscon-phandle


