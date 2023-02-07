Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1668D1B2
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 09:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjBGIsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 03:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjBGIsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 03:48:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A524630FB
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 00:48:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F8E26121B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 08:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB0EC433D2;
        Tue,  7 Feb 2023 08:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675759682;
        bh=dvocRrxw34W1WLL/bP2S1kJoSMddN/Ev4TCsX8S/ykw=;
        h=Subject:To:Cc:From:Date:From;
        b=lMbxfWeUi0weyOkAZ11uA4OFHkupX/Ebd/PAKdGc/sH7vEiPQf7A+MwZG9dQ25X1I
         mR7H28ujOoFk2Xx5vpaT4B7/G684weLVi9nhNi1SsajtgPmuN6ZUZU0A4vlTm+KbbF
         t+5xw9V1uwNsK4jBms36iobtFwYOd520kmWsaxc8=
Subject: FAILED: patch "[PATCH] powerpc/kexec_file: Fix division by zero in extra size" failed to apply to 5.15-stable tree
To:     mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 09:47:59 +0100
Message-ID: <167575967970206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7294194b47e9 ("powerpc/kexec_file: Fix division by zero in extra size estimation")
340a4a9f8773 ("powerpc: Take in account addition CPU node when building kexec FDT")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7294194b47e994753a86eee8cf1c61f3f36458a3 Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Mon, 30 Jan 2023 12:47:07 +1100
Subject: [PATCH] powerpc/kexec_file: Fix division by zero in extra size
 estimation

In kexec_extra_fdt_size_ppc64() there's logic to estimate how much
extra space will be needed in the device tree for some memory related
properties.

That logic uses the size of RAM divided by drmem_lmb_size() to do the
estimation. However drmem_lmb_size() can be zero if the machine has no
hotpluggable memory configured, which is the case when booting with qemu
and no maxmem=x parameter is passed (the default).

The division by zero is reported by UBSAN, and can also lead to an
overflow and a warning from kvmalloc, and kdump kernel loading fails:

  WARNING: CPU: 0 PID: 133 at mm/util.c:596 kvmalloc_node+0x15c/0x160
  Modules linked in:
  CPU: 0 PID: 133 Comm: kexec Not tainted 6.2.0-rc5-03455-g07358bd97810 #223
  Hardware name: IBM pSeries (emulated by qemu) POWER9 (raw) 0x4e1200 0xf000005 of:SLOF,git-dd0dca pSeries
  NIP:  c00000000041ff4c LR: c00000000041fe58 CTR: 0000000000000000
  REGS: c0000000096ef750 TRAP: 0700   Not tainted  (6.2.0-rc5-03455-g07358bd97810)
  MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24248242  XER: 2004011e
  CFAR: c00000000041fed0 IRQMASK: 0
  ...
  NIP kvmalloc_node+0x15c/0x160
  LR  kvmalloc_node+0x68/0x160
  Call Trace:
    kvmalloc_node+0x68/0x160 (unreliable)
    of_kexec_alloc_and_setup_fdt+0xb8/0x7d0
    elf64_load+0x25c/0x4a0
    kexec_image_load_default+0x58/0x80
    sys_kexec_file_load+0x5c0/0x920
    system_call_exception+0x128/0x330
    system_call_vectored_common+0x15c/0x2ec

To fix it, skip the calculation if drmem_lmb_size() is zero.

Fixes: 2377c92e37fe ("powerpc/kexec_file: fix FDT size estimation for kdump kernel")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230130014707.541110-1-mpe@ellerman.id.au

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index af8854f9eae3..19d084682bc2 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -989,10 +989,13 @@ unsigned int kexec_extra_fdt_size_ppc64(struct kimage *image)
 	 * linux,drconf-usable-memory properties. Get an approximate on the
 	 * number of usable memory entries and use for FDT size estimation.
 	 */
-	usm_entries = ((memblock_end_of_DRAM() / drmem_lmb_size()) +
-		       (2 * (resource_size(&crashk_res) / drmem_lmb_size())));
-
-	extra_size = (unsigned int)(usm_entries * sizeof(u64));
+	if (drmem_lmb_size()) {
+		usm_entries = ((memblock_end_of_DRAM() / drmem_lmb_size()) +
+			       (2 * (resource_size(&crashk_res) / drmem_lmb_size())));
+		extra_size = (unsigned int)(usm_entries * sizeof(u64));
+	} else {
+		extra_size = 0;
+	}
 
 	/*
 	 * Get the number of CPU nodes in the current DT. This allows to

