Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DCA5A45C4
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 11:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiH2JLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 05:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiH2JLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 05:11:25 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F9D5A3ED;
        Mon, 29 Aug 2022 02:11:22 -0700 (PDT)
Received: from workstation5.fritz.box (ip-084-118-157-002.um23.pools.vodafone-ip.de [84.118.157.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id ED3753F3B8;
        Mon, 29 Aug 2022 09:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661764280;
        bh=MOqesf4u45zAtW+3BKe8GeSqrojsS9g/VBrPiha821c=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=KM2a6H02nXrKg48mpMsYY/V9tbJD+UXRsgPglsmTaHIqKkNKBBRiNW6fE7LTjSO1U
         NfkjFtKQjGZw3JqLuN7WUDnJvK9B1HzwKEpB0m9iqjhOO5DvIOkMNaKidB0S78Rtu3
         T94RxzpK3cQCArQaBgXV0MY+xHtvvqo7nyq/XUyc+5rKVSiglLptvtLG8tzYaPMDtL
         VR9qfHKTkT5kPxslwNobZGfpYiqhak/kbN8IkNb9mgg8ywYjfS5JaFp8nI8gf2wDGG
         0RAPSgteBVcEJcG8RGj66QG/IcLpLYP6ZbkU/Hv0y5Y4C3t4qbLPmDOWvczmJhJ53n
         8HHY3tpe1uaqw==
From:   Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Atish Patra <atish.patra@wdc.com>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Date:   Mon, 29 Aug 2022 11:10:34 +0200
Message-Id: <20220829091034.109258-1-heinrich.schuchardt@canonical.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of commit 34fc9cc3aebe to v5.15.

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

This manifests as an unusable system if the l2-cache driver is enabled,
as the wrong interrupt gets cleared & the handler prints errors to the
console ad infinitum.

Fixes: 0fa6107eca41 ("RISC-V: Initial DTS for Microchip ICICLE board")
CC: stable@vger.kernel.org # 5.15: e35b07a7df9b: riscv: dts: microchip: mpfs: Group tuples in interrupt properties
Link: https://lore.kernel.org/all/20220817132521.3159388-1-heinrich.schuchardt@canonical.com/
Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index 4ef4bcb74872..57989b2ac186 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -153,7 +153,7 @@ cache-controller@2010000 {
 			cache-size = <2097152>;
 			cache-unified;
 			interrupt-parent = <&plic>;
-			interrupts = <1 2 3>;
+			interrupts = <1>, <3>, <4>, <2>;
 			reg = <0x0 0x2010000 0x0 0x1000>;
 		};
 
-- 
2.37.2

