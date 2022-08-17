Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07B8596FE0
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 15:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbiHQN0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 09:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239891AbiHQNZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 09:25:41 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16C9901BE;
        Wed, 17 Aug 2022 06:25:37 -0700 (PDT)
Received: from workstation5.fritz.box (ip-084-118-157-002.um23.pools.vodafone-ip.de [84.118.157.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id ED6B23F13E;
        Wed, 17 Aug 2022 13:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660742735;
        bh=PxzTNJ1Jg6c7i4yTxrytPCVQW1rkcheSbZD8jwdGcYI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=j2pDzobDmxNvAVvYyJbu2Vl1EvIZ7pnXFfOkDamLxkIHQfGDwxOkJQ/Y15fcnJe3l
         1lt/nt+R8sMlXZBQdzCwzdRfQ+XaxXqG8VS5afEmrjI0wvp+2efrUoJLXB8oToS2q2
         Z5I6ON6iipTTPxrwtx1idt3Zk7RqkwkhSfOs6DHzaVy5iOrktPu0NHUVnGGqxHvDZx
         3yfRyC50swVTR6nV77lh7VV6v7at6WTziEY9p2D8Ly8MrC8ZqmvqtD1eXIjJCdtCJR
         3BX7xLLklP/pFyzhU28Dqh9khonVQ2nb0l3YAevzKV7loXkmJfe/r7e1i4a/0eeXJs
         FQpmNnz2nWKZQ==
From:   Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Atish Patra <atish.patra@wdc.com>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        devicetree@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Date:   Wed, 17 Aug 2022 15:25:21 +0200
Message-Id: <20220817132521.3159388-1-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "PolarFire SoC MSS Technical Reference Manual" documents the
following PLIC interrupts:

1 - L2 Cache Controller Signals when a metadata correction event occurs
2 - L2 Cache Controller Signals when an uncorrectable metadata event occurs
3 - L2 Cache Controller Signals when a data correction event occurs
4 - L2 Cache Controller Signals when an uncorrectable data event occurs

This differs from the SiFive FU540 which only has three L2 cache related
interrupts.

The sequence in the device tree is defined by an enum:

    enum {
            DIR_CORR = 0,
            DATA_CORR,
            DATA_UNCORR,
            DIR_UNCORR,
    };

So the correct sequence of the L2 cache interrupts is

    interrupts = <1>, <3>, <4>, <2>;

Fixes: e35b07a7df9b ("riscv: dts: microchip: mpfs: Group tuples in interrupt properties")
Fixes: 0fa6107eca41 ("RISC-V: Initial DTS for Microchip ICICLE board")
Cc: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 arch/riscv/boot/dts/microchip/mpfs.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs.dtsi b/arch/riscv/boot/dts/microchip/mpfs.dtsi
index 496d3b7642bd..ec1de6344be9 100644
--- a/arch/riscv/boot/dts/microchip/mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/mpfs.dtsi
@@ -169,7 +169,7 @@ cctrllr: cache-controller@2010000 {
 			cache-size = <2097152>;
 			cache-unified;
 			interrupt-parent = <&plic>;
-			interrupts = <1>, <2>, <3>;
+			interrupts = <1>, <3>, <4>, <2>;
 		};
 
 		clint: clint@2000000 {
-- 
2.36.1

