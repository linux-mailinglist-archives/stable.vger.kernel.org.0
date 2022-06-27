Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25F55D858
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbiF0Lva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbiF0Lu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:50:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CFE2196;
        Mon, 27 Jun 2022 04:43:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 644CDB80E32;
        Mon, 27 Jun 2022 11:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA463C3411D;
        Mon, 27 Jun 2022 11:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330218;
        bh=TbJXaK1rbMB8btpOBGJnwp1o3DBVqNZI0GMIlKu8slk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYEy+fWlxWfPFEBmHzAgkaQEx5t8PwqxyzjTObZsoJ1zoclJPKkuf17u0EhmYbnjm
         uoWpAowC927pm9IPW9TWsoSUAbrWk9YjKi6vbDgTO5/cz9CbujQjb7G4XySWtta3Lk
         4jc1DVL61oe1+uGnnyNlnpo2LhnsTtabFearM0Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.18 122/181] dt-bindings: usb: ohci: Increase the number of PHYs
Date:   Mon, 27 Jun 2022 13:21:35 +0200
Message-Id: <20220627111948.231950197@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

commit 0f074c1c95ea496dc91279b6c4b9845a337517fa upstream.

"make dtbs_check":

    arch/arm/boot/dts/r8a77470-iwg23s-sbc.dtb: usb@ee080000: phys: [[17, 0], [31]] is too long
	    From schema: Documentation/devicetree/bindings/usb/generic-ohci.yaml
    arch/arm/boot/dts/r8a77470-iwg23s-sbc.dtb: usb@ee0c0000: phys: [[17, 1], [33], [21, 0]] is too long
	    From schema: Documentation/devicetree/bindings/usb/generic-ohci.yaml

Some USB OHCI controllers (e.g. on the Renesas RZ/G1C SoC) have multiple
PHYs.  Increase the maximum number of PHYs to 3, which is sufficient for
now.

Fixes: 0499220d6dadafa5 ("dt-bindings: Add missing array size constraints")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/0112f9c8881513cb33bf7b66bc743dd08b35a2f5.1655301203.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/generic-ohci.yaml |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/generic-ohci.yaml
+++ b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
@@ -102,7 +102,8 @@ properties:
       Overrides the detected port count
 
   phys:
-    maxItems: 1
+    minItems: 1
+    maxItems: 3
 
   phy-names:
     const: usb


