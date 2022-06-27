Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8CA55CE8C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbiF0Lky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbiF0Ljr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C574CBA5;
        Mon, 27 Jun 2022 04:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 462A060CA4;
        Mon, 27 Jun 2022 11:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5832EC3411D;
        Mon, 27 Jun 2022 11:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329713;
        bh=SPjt+EvEQ4079Mv+pWhVZgBzhL/o5jfkH6JC8grHV94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vo4IEbJkgY8uRVO1c5FHrbobJ/MJaHuxwJ1BZ1/YO16QkgFcuQu4NLatZ5xYosLeq
         e36oXi4TNr9qqOz9ClhU7vBYPxQHaoh6wyYgtPyHwDFHe01q3dCWH6LfNlCzC9a8x6
         tVL70VRH0Wl0cngJ05xFxXnerLnbNoFNasW9e5Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.15 091/135] dt-bindings: usb: ehci: Increase the number of PHYs
Date:   Mon, 27 Jun 2022 13:21:38 +0200
Message-Id: <20220627111940.800012609@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 9faa1c8f92f33daad9db96944139de225cefa199 upstream.

"make dtbs_check":

    arch/arm/boot/dts/r8a77470-iwg23s-sbc.dtb: usb@ee080100: phys: [[17, 0], [31]] is too long
	    From schema: Documentation/devicetree/bindings/usb/generic-ehci.yaml
    arch/arm/boot/dts/r8a77470-iwg23s-sbc.dtb: usb@ee0c0100: phys: [[17, 1], [33], [21, 0]] is too long
	    From schema: Documentation/devicetree/bindings/usb/generic-ehci.yaml

Some USB EHCI controllers (e.g. on the Renesas RZ/G1C SoC) have multiple
PHYs.  Increase the maximum number of PHYs to 3, which is sufficient for
now.

Fixes: 0499220d6dadafa5 ("dt-bindings: Add missing array size constraints")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/c5d19e2f9714f43effd90208798fc1936098078f.1655301043.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/generic-ehci.yaml |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
+++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
@@ -135,7 +135,8 @@ properties:
       Phandle of a companion.
 
   phys:
-    maxItems: 1
+    minItems: 1
+    maxItems: 3
 
   phy-names:
     const: usb


