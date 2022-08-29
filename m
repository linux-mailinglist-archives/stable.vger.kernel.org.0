Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6101E5A4A87
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiH2Llm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiH2LlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC215F9B5;
        Mon, 29 Aug 2022 04:25:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE5F1B80F98;
        Mon, 29 Aug 2022 11:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF19C433D6;
        Mon, 29 Aug 2022 11:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771887;
        bh=o/HNSoSVRYqLb9w4klxap5MlomTwg5zz/toUw3fcwuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1EMbmsf0qu84nuIEtK4rfkvw6/IszNEG5z8dRKBq5ji7H5uyT2ikyO7Xx/sOhYEW
         yAuuZcIq/9nU1TqRyEeENgB237Qj00wgfyODPNBOAPEIVk8bpcXFAwN4Wf0A3755xS
         0s5BGhjH91ZbtZPA3/pFR0qUzD6tbMtFLQzv2Rzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 5.19 131/158] riscv: dts: microchip: correct L2 cache interrupts
Date:   Mon, 29 Aug 2022 12:59:41 +0200
Message-Id: <20220829105814.583123387@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>

commit 34fc9cc3aebe8b9e27d3bc821543dd482dc686ca upstream.

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

[Conor]
This manifests as an unusable system if the l2-cache driver is enabled,
as the wrong interrupt gets cleared & the handler prints errors to the
console ad infinitum.

Fixes: 0fa6107eca41 ("RISC-V: Initial DTS for Microchip ICICLE board")
CC: stable@vger.kernel.org # 5.15: e35b07a7df9b: riscv: dts: microchip: mpfs: Group tuples in interrupt properties
Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/microchip/mpfs.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/boot/dts/microchip/mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/mpfs.dtsi
@@ -169,7 +169,7 @@
 			cache-size = <2097152>;
 			cache-unified;
 			interrupt-parent = <&plic>;
-			interrupts = <1>, <2>, <3>;
+			interrupts = <1>, <3>, <4>, <2>;
 		};
 
 		clint: clint@2000000 {


