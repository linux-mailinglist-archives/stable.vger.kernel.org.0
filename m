Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7A855E290
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbiF0Lvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbiF0Lua (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21100101E;
        Mon, 27 Jun 2022 04:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F6861240;
        Mon, 27 Jun 2022 11:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C026BC3411D;
        Mon, 27 Jun 2022 11:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330221;
        bh=SPjt+EvEQ4079Mv+pWhVZgBzhL/o5jfkH6JC8grHV94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/rtqP6xiOLZrnXZ3HJBwZf5TR8GmyT2V/Af+1JWoKN9jNCaTlaIP7/oIqYtLUxm4
         x35VTG1Mq/p2qtC2jdDtXtqNpYbbW0vVzgeKQPSsRpU9Zer48jxRmdahbO/UrT5idR
         98FF4HXF+NDPByvPwAlIfLTe0/XKMexs1X0ctbh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.18 123/181] dt-bindings: usb: ehci: Increase the number of PHYs
Date:   Mon, 27 Jun 2022 13:21:36 +0200
Message-Id: <20220627111948.260032848@linuxfoundation.org>
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


