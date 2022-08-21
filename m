Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC7D59B40C
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiHUNna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiHUNn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:43:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6D3642F
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 06:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14255B80D57
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 13:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9B9C433C1;
        Sun, 21 Aug 2022 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661089404;
        bh=GqMxD2L0lXJz8yVTjxR8Rp/9qx9sM3tmp643RYCL1YU=;
        h=Subject:To:Cc:From:Date:From;
        b=QEpMz5s1N939vaZ2yIp9a2GgGwEj0hbXdxisdjzMqw+ztdfzE5SaUCpPYOVVZBwFn
         gm8au5SkEuwnxHpcRbedN65ICgTzhr0NvtbAc1msiEPAy2ktXvLmYZSN+/9biAg70p
         Od6oTirGpWJMzRXBJp8LToTQRLwlPF1b1j7SMNKc=
Subject: FAILED: patch "[PATCH] riscv: Ensure isa-ext static keys are writable" failed to apply to 5.19-stable tree
To:     ajones@ventanamicro.com, apatel@ventanamicro.com,
        atishp@rivosinc.com, conor.dooley@microchip.com,
        palmer@rivosinc.com, re@w6rz.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 15:43:21 +0200
Message-ID: <166108940135238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb6354e116305afbfde196be5120bfa8669fdc6a Mon Sep 17 00:00:00 2001
From: Andrew Jones <ajones@ventanamicro.com>
Date: Tue, 16 Aug 2022 18:30:58 +0200
Subject: [PATCH] riscv: Ensure isa-ext static keys are writable

riscv_isa_ext_keys[] is an array of static keys used in the unified
ISA extension framework. The keys added to this array may be used
anywhere, including in modules. Ensure the keys remain writable by
placing them in the data section.

The need to change riscv_isa_ext_keys[]'s section was found when the
kvm module started failing to load. Commit 8eb060e10185 ("arch/riscv:
add Zihintpause support") adds a static branch check for a newly
added isa-ext key to cpu_relax(), which kvm uses.

Fixes: c360cbec3511 ("riscv: introduce unified static key mechanism for ISA extensions")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Cc: stable@vger.kernel.org
Reported-by: Ron Economos <re@w6rz.net>
Reported-by: Anup Patel <apatel@ventanamicro.com>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20220816163058.3004536-1-ajones@ventanamicro.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 553d755483ed..3b5583db9d80 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -28,7 +28,7 @@ unsigned long elf_hwcap __read_mostly;
 /* Host ISA bitmap */
 static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __read_mostly;
 
-__ro_after_init DEFINE_STATIC_KEY_ARRAY_FALSE(riscv_isa_ext_keys, RISCV_ISA_EXT_KEY_MAX);
+DEFINE_STATIC_KEY_ARRAY_FALSE(riscv_isa_ext_keys, RISCV_ISA_EXT_KEY_MAX);
 EXPORT_SYMBOL(riscv_isa_ext_keys);
 
 /**

