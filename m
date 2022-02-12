Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54894B3407
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 10:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiBLJ1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 04:27:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiBLJ1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 04:27:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169F2655A
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 01:27:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C472B800A0
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 09:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977C9C340EB;
        Sat, 12 Feb 2022 09:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644658023;
        bh=hALC3Dg5BgXmtSqBgpKrk2kW3gHZkAcfln7y4swIaxA=;
        h=Subject:To:Cc:From:Date:From;
        b=KdehhUQKH/JtNONR7kGb4hbgw+1F0ujI8wNataX6D3mTBSnMCoTYLHnIH7OFxle/U
         s+qmBuRLVM0pgOsrVAl/fEsVxAr7fJqgEhCLZv/Zln+h2Xy4K3hXQDvr8UWKcJ5AeS
         XkJHGFZQj7nUKzubyelH/as8crRxlweQG/Z/8JTo=
Subject: FAILED: patch "[PATCH] riscv/mm: Add XIP_FIXUP for phys_ram_base" failed to apply to 5.15-stable tree
To:     palmer@rivosinc.com, gatecat@ds0.me
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 12 Feb 2022 10:27:00 +0100
Message-ID: <1644658020119206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 4b1c70aa8ed8249608bb991380cb8ff423edf49e Mon Sep 17 00:00:00 2001
From: Palmer Dabbelt <palmer@rivosinc.com>
Date: Fri, 4 Feb 2022 13:13:37 -0800
Subject: [PATCH] riscv/mm: Add XIP_FIXUP for phys_ram_base

This manifests as a crash early in boot on VexRiscv.

Signed-off-by: Myrtle Shah <gatecat@ds0.me>
[Palmer: split commit]
Fixes: 6d7f91d914bc ("riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical address conversion")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index cf4d018b7d66..eecfacac2cc5 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -522,6 +522,7 @@ static uintptr_t __init best_map_size(phys_addr_t base, phys_addr_t size)
 }
 
 #ifdef CONFIG_XIP_KERNEL
+#define phys_ram_base  (*(phys_addr_t *)XIP_FIXUP(&phys_ram_base))
 extern char _xiprom[], _exiprom[], __data_loc;
 
 /* called from head.S with MMU off */

