Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD625A4410
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiH2Hne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiH2Hnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:43:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C797F4F190
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:43:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 660AE61135
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5515FC433D6;
        Mon, 29 Aug 2022 07:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661759011;
        bh=r2lnOa5CFOlLcexq1454XzLoSOkCDZ4SPoJZ6Ccf/Aw=;
        h=Subject:To:Cc:From:Date:From;
        b=cXadYag8Kujs3NjdDnnxmIcdsj+4Gb4w3x1b0oUZjP/by7I2Sz9MNohgbCltAAB0h
         3RfgCK0/b4TMCZbdWx+/OiepYYwa+0mlLcGO2va5Da5i2310yAuhiyHhMnfj9iPNWc
         lz956GS5uy0a9E/B5KbKKZ20ofpDAkTbdyf9S1j0=
Subject: FAILED: patch "[PATCH] riscv: dts: microchip: correct L2 cache interrupts" failed to apply to 5.15-stable tree
To:     heinrich.schuchardt@canonical.com, conor.dooley@microchip.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:43:28 +0200
Message-ID: <1661759008195128@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 34fc9cc3aebe8b9e27d3bc821543dd482dc686ca Mon Sep 17 00:00:00 2001
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Date: Wed, 17 Aug 2022 15:25:21 +0200
Subject: [PATCH] riscv: dts: microchip: correct L2 cache interrupts
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/arch/riscv/boot/dts/microchip/mpfs.dtsi b/arch/riscv/boot/dts/microchip/mpfs.dtsi
index 499c2e63ad35..0a6ad5b9ff8d 100644
--- a/arch/riscv/boot/dts/microchip/mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/mpfs.dtsi
@@ -193,7 +193,7 @@
 			cache-size = <2097152>;
 			cache-unified;
 			interrupt-parent = <&plic>;
-			interrupts = <1>, <2>, <3>;
+			interrupts = <1>, <3>, <4>, <2>;
 		};
 
 		clint: clint@2000000 {

