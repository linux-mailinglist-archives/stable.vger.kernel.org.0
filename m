Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE4D593B66
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiHOUNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346373AbiHOULP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:11:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBD42B63D;
        Mon, 15 Aug 2022 11:57:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B01AFB810CC;
        Mon, 15 Aug 2022 18:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA187C433C1;
        Mon, 15 Aug 2022 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589854;
        bh=MqXDXlZKe82M+ZSR3HvDR2TXSZqOQYNlIWIzz4zgi5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYN4Cuqjz/HC3wkXNBs6lCKviGkRpsKrBw+4ftuqkq1qb3QNRPqDE4iGRToKRPG9R
         p457fbm/1PEMtoLKsNtys19u4xyfSIPrrq+z14R3jHamm1/h8c4HvqdR7SUIiUCz8P
         lkOMLyAKIvsp2/RRKUg0PYs+lBHT33AnC4aKj2iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atul Khare <atulkhare@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.18 0062/1095] dt-bindings: riscv: fix SiFive l2-caches cache-sets
Date:   Mon, 15 Aug 2022 19:51:01 +0200
Message-Id: <20220815180432.066936189@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Conor Dooley <conor.dooley@microchip.com>

commit b60cf8e59e61133b6c9514ff8d8c8d7049d040ef upstream.

Fix device tree schema validation error messages for the SiFive
Unmatched: ' cache-sets:0:0: 1024 was expected'.

The existing bindings allow for just 1024 cache-sets but the fu740 on
Unmatched the has 2048 cache-sets. The ISA itself permits any arbitrary
power of two, however this is not supported by dt-schema. The RTL for
the IP, to which the number of cache-sets is a tunable parameter, has
been released publicly so speculatively adding a small number of
"reasonable" values seems unwise also.

Instead, as the binding only supports two distinct controllers: add 2048
and explicitly lock it to the fu740's l2 cache while limiting 1024 to
the l2 cache on the fu540.

Fixes: af951c3a113b ("dt-bindings: riscv: Update l2 cache DT documentation to add support for SiFive FU740")
Reported-by: Atul Khare <atulkhare@rivosinc.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220803185359.942928-1-mail@conchuod.ie
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
+++ b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
@@ -46,7 +46,7 @@ properties:
     const: 2
 
   cache-sets:
-    const: 1024
+    enum: [1024, 2048]
 
   cache-size:
     const: 2097152
@@ -84,6 +84,8 @@ then:
       description: |
         Must contain entries for DirError, DataError and DataFail signals.
       maxItems: 3
+    cache-sets:
+      const: 1024
 
 else:
   properties:
@@ -91,6 +93,8 @@ else:
       description: |
         Must contain entries for DirError, DataError, DataFail, DirFail signals.
       minItems: 4
+    cache-sets:
+      const: 2048
 
 additionalProperties: false
 


