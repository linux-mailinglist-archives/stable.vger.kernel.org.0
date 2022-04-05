Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786554F29EC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238072AbiDEIno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241204AbiDEIcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2D217A81;
        Tue,  5 Apr 2022 01:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A1CC609D0;
        Tue,  5 Apr 2022 08:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C175C385A2;
        Tue,  5 Apr 2022 08:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147362;
        bh=Fm93SfOtVMca980+6uyVenif6pThe6aO6Z2kp7al95w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyZedaN3ujqrRYFTVzLInBcrZ1dlscSbXIvZw6wUNR+fsjpjGYDk37CShByF4QZG7
         bW/c2YzT1SqvMYmCyVPxuFut+H/m4Pk5iAmgjQtF6p5G746/nBYL+pyO1VkzEyOcRO
         Z12jDzlTFNcC4h+fdIJhxuPq2e2inR4zHpUx9/20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.17 1098/1126] dt-bindings: pinctrl: pinctrl-microchip-sgpio: Fix example
Date:   Tue,  5 Apr 2022 09:30:45 +0200
Message-Id: <20220405070439.670306654@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

commit a6ff90f3fbd4d902aad8777f0329cef3a2768bde upstream.

The blamed commit adds support for irq, but the reqisters for irq are
outside of the memory size. They are at address 0x108. Therefore update
the memory size to cover all the registers used by the device.

Fixes: 01a9350bdd49fb ("dt-bindings: pinctrl: pinctrl-microchip-sgpio: Add irq support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20220204153535.465827-2-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml
@@ -145,7 +145,7 @@ examples:
       clocks = <&sys_clk>;
       pinctrl-0 = <&sgpio2_pins>;
       pinctrl-names = "default";
-      reg = <0x1101059c 0x100>;
+      reg = <0x1101059c 0x118>;
       microchip,sgpio-port-ranges = <0 0>, <16 18>, <28 31>;
       bus-frequency = <25000000>;
       sgpio_in2: gpio@0 {


