Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9853EBA0
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbiFFOz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240109AbiFFOz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:55:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06169DE9F
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:55:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96141614BD
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 14:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9F7C34115;
        Mon,  6 Jun 2022 14:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654527355;
        bh=zSKJPsneG4/5tRzekyoGPZm0a0T/kTp3eJAPZRjmmlM=;
        h=Subject:To:Cc:From:Date:From;
        b=RH6+DolKK8erctzXoJm7eMrnvmuz5IbjbSliTkRfhvzSBFWdVj1EH4UWpkzotxXE0
         EMD4hwXGuCHlVPpiwlDyXbeenn18urLKWwue/nrYq4yjCQcNVdTeOUvvNI/JK8V84x
         NG222E8EQQwdDRxpgoW2bgrjjd78W7MaA3StDKFI=
Subject: FAILED: patch "[PATCH] MIPS: IP27: Remove incorrect `cpu_has_fpu' override" failed to apply to 5.10-stable tree
To:     macro@orcam.me.uk, starzhangzsd@gmail.com,
        tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 16:55:36 +0200
Message-ID: <1654527336104186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 424c3781dd1cb401857585331eaaa425a13f2429 Mon Sep 17 00:00:00 2001
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
Date: Sun, 1 May 2022 23:14:16 +0100
Subject: [PATCH] MIPS: IP27: Remove incorrect `cpu_has_fpu' override

Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu'
kernel parameter non-functional, and also causes a link error:

ld: arch/mips/kernel/traps.o: in function `trap_init':
./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference to `handle_fpe'

where the CONFIG_MIPS_FP_SUPPORT configuration option has been disabled.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Fixes: 0ebb2f4159af ("MIPS: IP27: Update/restructure CPU overrides")
Cc: stable@vger.kernel.org # v4.2+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

diff --git a/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h b/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
index c8385c4e8664..568fe09332eb 100644
--- a/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
+++ b/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
@@ -25,7 +25,6 @@
 #define cpu_has_4kex			1
 #define cpu_has_3k_cache		0
 #define cpu_has_4k_cache		1
-#define cpu_has_fpu			1
 #define cpu_has_nofpuex			0
 #define cpu_has_32fpr			1
 #define cpu_has_counter			1

