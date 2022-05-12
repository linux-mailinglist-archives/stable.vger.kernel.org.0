Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC64D524FF7
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344674AbiELO3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 10:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355273AbiELO3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 10:29:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A52FEAB96;
        Thu, 12 May 2022 07:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0168B827C1;
        Thu, 12 May 2022 14:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1FDC385B8;
        Thu, 12 May 2022 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652365760;
        bh=UQMDPXWTKe2AYEse52NreOXMC/Gsdx93y7zUmCZMQ9M=;
        h=From:To:Cc:Subject:Date:From;
        b=OQRa1+WZVeBNTfsplKzqy7K5jqwmNxLyYl2hWSDvuOkQiOYQgUpQN0gsTp/gd+MM0
         EYy9XqCHXLYZW5WdLbZoZkj+UB4iYJPWNEHZvKAEhoI5lnos+IpfJgIcKRCvVkP1MO
         WJvFSJKBEzwBylrZbJHhVKRV5qoGSyCtokUdqWaI/TrbWOiY88r5Tt5MP2bQ5Emf65
         u8TQdi8719jevmzwjDHPgTMyGTypWxMmECB3V8eoXvFnkHadFqPT96Piv125ki5kvj
         A87cuA2Yj9PzK77SbKrRsvjL6uY4h10Fj3gNTsXVeK3+29qadauj3xxUSod1+HLfeQ
         MObZ2y2m7EAhQ==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linus.walleij@linaro.org
Cc:     dinguyen@kernel.org, brgl@bgdev.pl, robh+dt@kernel.org,
        krzk+dt@kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] dt-bindings: gpio: altera: correct interrupt-cells
Date:   Thu, 12 May 2022 09:29:10 -0500
Message-Id: <20220512142910.328995-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

update documentation to correctly state the interrupt-cells to be 2.

Cc: stable@vger.kernel.org
Fixes: 4fd9bbc6e071 ("drivers/gpio: Altera soft IP GPIO driver devicetree binding")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 Documentation/devicetree/bindings/gpio/gpio-altera.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-altera.txt b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
index 146e554b3c67..2a80e272cd66 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-altera.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
@@ -9,8 +9,9 @@ Required properties:
   - The second cell is reserved and is currently unused.
 - gpio-controller : Marks the device node as a GPIO controller.
 - interrupt-controller: Mark the device node as an interrupt controller
-- #interrupt-cells : Should be 1. The interrupt type is fixed in the hardware.
+- #interrupt-cells : Should be 2. The interrupt type is fixed in the hardware.
   - The first cell is the GPIO offset number within the GPIO controller.
+  - The second cell is the interrupt trigger type and level flags.
 - interrupts: Specify the interrupt.
 - altr,interrupt-type: Specifies the interrupt trigger type the GPIO
   hardware is synthesized. This field is required if the Altera GPIO controller
@@ -38,6 +39,6 @@ gpio_altr: gpio@ff200000 {
 	altr,interrupt-type = <IRQ_TYPE_EDGE_RISING>;
 	#gpio-cells = <2>;
 	gpio-controller;
-	#interrupt-cells = <1>;
+	#interrupt-cells = <2>;
 	interrupt-controller;
 };
-- 
2.25.1

