Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F08455CE56
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbiF0LkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbiF0LjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D7ABE20;
        Mon, 27 Jun 2022 04:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C92660C16;
        Mon, 27 Jun 2022 11:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98883C3411D;
        Mon, 27 Jun 2022 11:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329711;
        bh=TbJXaK1rbMB8btpOBGJnwp1o3DBVqNZI0GMIlKu8slk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy0+3oynILNLcdQTIaAk0mDvt1uXN4CquJfWSnYgsQC05xenXTudZ3Km0VAbHd52c
         azbPgZKGT/elYP3MlJ7BJe2IdMbr0kkZ9y9FEM9iLxwwCJU7zg+R5NpqAc/nAaICh/
         Dk+ah//frf7lS01iRNBkee/CEOjXPzuBzpExJMFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.15 090/135] dt-bindings: usb: ohci: Increase the number of PHYs
Date:   Mon, 27 Jun 2022 13:21:37 +0200
Message-Id: <20220627111940.771563749@linuxfoundation.org>
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


