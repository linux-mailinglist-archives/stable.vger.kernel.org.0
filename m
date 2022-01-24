Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2A8497F43
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiAXMVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:21:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48700 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238910AbiAXMVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:21:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1520D60F0D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66DCC340E4;
        Mon, 24 Jan 2022 12:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643026905;
        bh=OZHy3y1QaaMD0eh/sst3wUNnL+YQ2z4YGykv2qDX1IA=;
        h=Subject:To:Cc:From:Date:From;
        b=PTAOFLPHArpTATs5O4DdCPaPvJ0mGHn0IKz7I70stqTe88shfqeJHIlIaY5lFYG/G
         bLGiJ1+2JxUDLAuXtOygC7gmSVK4YNVYnrVMYj0Sqf0PtbAYPwKTdR54XctskNhdGY
         uYXKrq5cRiSMnF40IJZY0H+EcRokYjx1OZRJEwe4=
Subject: FAILED: patch "[PATCH] RISC-V: MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW" failed to apply to 5.15-stable tree
To:     palmer@rivosinc.com, anup@brainfault.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:21:34 +0100
Message-ID: <164302689416035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 9f36b96bc70f9707e618d22cd6a6baf86706ade2 Mon Sep 17 00:00:00 2001
From: Palmer Dabbelt <palmer@rivosinc.com>
Date: Fri, 19 Nov 2021 08:44:03 -0800
Subject: [PATCH] RISC-V: MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW

For non-relocatable kernels we need to be able to link the kernel at
approximately PAGE_OFFSET, thus requiring medany (as medlow requires the
code to be linked within 2GiB of 0).  The inverse doesn't apply, though:
since medany code can be linked anywhere it's fine to link it close to
0, so we can support the smaller memory config.

Fixes: de5f4b8f634b ("RISC-V: Define MAXPHYSMEM_1GB only for RV32")
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 821252b65f89..61f64512dcde 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -280,7 +280,7 @@ choice
 		depends on 32BIT
 		bool "1GiB"
 	config MAXPHYSMEM_2GB
-		depends on 64BIT && CMODEL_MEDLOW
+		depends on 64BIT
 		bool "2GiB"
 	config MAXPHYSMEM_128GB
 		depends on 64BIT && CMODEL_MEDANY

