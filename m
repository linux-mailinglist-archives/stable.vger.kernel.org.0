Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48124CE454
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 12:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiCELCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 06:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiCELCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 06:02:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A11D42A3A
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 03:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C0A6CE3023
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 11:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205FFC004E1;
        Sat,  5 Mar 2022 11:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646478073;
        bh=HCoGKPq5lfgqWbdY4yrs86U06GP19h9hyBRl22uEuGs=;
        h=Subject:To:Cc:From:Date:From;
        b=0LjYRHYgnvI7nsY0XYiK6IJgsSdBN2E6oqwXrA/nYCS7ZHDv/3QkZpGxBO8c2uO1k
         j5ER9uEEOM/5BPpEi14Q2VxZKKbRp8VzFPOMQr9NVTsIiTA9flyRyuIaXcU6ySgXkt
         sRp3rOA3SURMMzBCaK3eJRWLwqRouUnM1s8Uw4qg=
Subject: FAILED: patch "[PATCH] riscv: dts: k210: fix broken IRQs on hart1" failed to apply to 5.16-stable tree
To:     niklas.cassel@wdc.com, palmer@rivosinc.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 12:01:10 +0100
Message-ID: <164647807017044@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 74583f1b92cb3bbba1a3741cea237545c56f506c Mon Sep 17 00:00:00 2001
From: Niklas Cassel <niklas.cassel@wdc.com>
Date: Tue, 1 Mar 2022 00:44:18 +0000
Subject: [PATCH] riscv: dts: k210: fix broken IRQs on hart1

Commit 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
incorrectly removed two entries from the PLIC interrupt-controller node's
interrupts-extended property.

The PLIC driver cannot know the mapping between hart contexts and hart ids,
so this information has to be provided by device tree, as specified by the
PLIC device tree binding.

The PLIC driver uses the interrupts-extended property, and initializes the
hart context registers in the exact same order as provided by the
interrupts-extended property.

In other words, if we don't specify the S-mode interrupts, the PLIC driver
will simply initialize the hart0 S-mode hart context with the hart1 M-mode
configuration. It is therefore essential to specify the S-mode IRQs even
though the system itself will only ever be running in M-mode.

Re-add the S-mode interrupts, so that we get working IRQs on hart1 again.

Cc: <stable@vger.kernel.org>
Fixes: 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/boot/dts/canaan/k210.dtsi b/arch/riscv/boot/dts/canaan/k210.dtsi
index 56f57118c633..44d338514761 100644
--- a/arch/riscv/boot/dts/canaan/k210.dtsi
+++ b/arch/riscv/boot/dts/canaan/k210.dtsi
@@ -113,7 +113,8 @@ plic0: interrupt-controller@c000000 {
 			compatible = "canaan,k210-plic", "sifive,plic-1.0.0";
 			reg = <0xC000000 0x4000000>;
 			interrupt-controller;
-			interrupts-extended = <&cpu0_intc 11>, <&cpu1_intc 11>;
+			interrupts-extended = <&cpu0_intc 11>, <&cpu0_intc 9>,
+					      <&cpu1_intc 11>, <&cpu1_intc 9>;
 			riscv,ndev = <65>;
 		};
 

