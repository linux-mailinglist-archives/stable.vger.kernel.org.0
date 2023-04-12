Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301586DEFA7
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjDLIwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjDLIwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E3BA248
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4605563194
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD37C433EF;
        Wed, 12 Apr 2023 08:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289493;
        bh=Mlzu3wJeZf8CiVQrU0lclGtYgaf1eR0IgB1h9jt/vlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qT4OcqrzUYuOsOuZTZPWLyqQ4fHPQTumkkemwySFoXIMW62bfRGk+wcPBS7G5fGmV
         Zel5AsJwtnx+4t8QKO5ccka/91eQTMc3fWI8sHsWix3J9qXF1D5LCDnwWP3DUUzggx
         /bOnSWFjYnexcZhqlziwien9/IEZQoQTfxdNPfHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.2 091/173] dt-bindings: serial: renesas,scif: Fix 4th IRQ for 4-IRQ SCIFs
Date:   Wed, 12 Apr 2023 10:33:37 +0200
Message-Id: <20230412082841.733437891@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 7b21f329ae0ab6361c0aebfc094db95821490cd1 upstream.

The fourth interrupt on SCIF variants with four interrupts (RZ/A1) is
the Break interrupt, not the Transmit End interrupt (like on SCI(g)).
Update the description and interrupt name to fix this.

Fixes: 384d00fae8e51f8f ("dt-bindings: serial: sh-sci: Convert to json-schema")
Cc: stable <stable@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/719d1582e0ebbe3d674e3a48fc26295e1475a4c3.1679046394.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/renesas,scif.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
+++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
@@ -92,7 +92,7 @@ properties:
           - description: Error interrupt
           - description: Receive buffer full interrupt
           - description: Transmit buffer empty interrupt
-          - description: Transmit End interrupt
+          - description: Break interrupt
       - items:
           - description: Error interrupt
           - description: Receive buffer full interrupt
@@ -107,7 +107,7 @@ properties:
           - const: eri
           - const: rxi
           - const: txi
-          - const: tei
+          - const: bri
       - items:
           - const: eri
           - const: rxi


