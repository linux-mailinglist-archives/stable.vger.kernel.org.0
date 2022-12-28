Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F33F65843A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbiL1Q4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbiL1QzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08C91EEC9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:50:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B639B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9D5C433EF;
        Wed, 28 Dec 2022 16:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246202;
        bh=3AZAoDc18ZnziJnVMDSe32b1UpNvK44xxuL1Y7Z5fdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ut72sREDfYqZhafVOYIQEG3JAu8UGlRgq6Qnh9dKnpWCHANf/QDnlDTOamtXb8f0j
         z7qbQxo0OoM/v2U0ji9NYbImHpuovDMfoH5QqxumDR/sMlxIrfcNUv3yOl97lYE9f9
         ZXz+/W91WZR1ulo4/x3VCVsJodeO1oky9fcnzaWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Robert Elliott (Servers)" <elliott@hpe.com>,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0960/1146] x86/apic: Handle no CONFIG_X86_X2APIC on systems with x2APIC enabled by BIOS
Date:   Wed, 28 Dec 2022 15:41:39 +0100
Message-Id: <20221228144356.395952496@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

[ Upstream commit e3998434da4f5b1f57f8d6a8a9f8502ee3723bae ]

A kernel that was compiled without CONFIG_X86_X2APIC was unable to boot on
platforms that have x2APIC already enabled in the BIOS before starting the
kernel.

The kernel was supposed to panic with an approprite error message in
validate_x2apic() due to the missing X2APIC support.

However, validate_x2apic() was run too late in the boot cycle, and the
kernel tried to initialize the APIC nonetheless. This resulted in an
earlier panic in setup_local_APIC() because the APIC was not registered.

In my experiments, a panic message in setup_local_APIC() was not visible
in the graphical console, which resulted in a hang with no indication
what has gone wrong.

Instead of calling panic(), disable the APIC, which results in a somewhat
working system with the PIC only (and no SMP). This way the user is able to
diagnose the problem more easily.

Disabling X2APIC mode is not an option because it's impossible on systems
with locked x2APIC.

The proper place to disable the APIC in this case is in check_x2apic(),
which is called early from setup_arch(). Doing this in
__apic_intr_mode_select() is too late.

Make check_x2apic() unconditionally available and remove the empty stub.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reported-by: Robert Elliott (Servers) <elliott@hpe.com>
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/lkml/d573ba1c-0dc4-3016-712a-cc23a8a33d42@molgen.mpg.de
Link: https://lore.kernel.org/lkml/20220911084711.13694-3-mat.jonczyk@o2.pl
Link: https://lore.kernel.org/all/20221129215008.7247-1-mat.jonczyk@o2.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig            |  4 ++--
 arch/x86/include/asm/apic.h |  3 +--
 arch/x86/kernel/apic/apic.c | 13 ++++++++-----
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 67745ceab0db..b2c0fce3f257 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -462,8 +462,8 @@ config X86_X2APIC
 
 	  Some Intel systems circa 2022 and later are locked into x2APIC mode
 	  and can not fall back to the legacy APIC modes if SGX or TDX are
-	  enabled in the BIOS.  They will be unable to boot without enabling
-	  this option.
+	  enabled in the BIOS. They will boot with very reduced functionality
+	  without enabling this option.
 
 	  If you don't know what to do here, say N.
 
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3415321c8240..3216da7074ba 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -249,7 +249,6 @@ static inline u64 native_x2apic_icr_read(void)
 extern int x2apic_mode;
 extern int x2apic_phys;
 extern void __init x2apic_set_max_apicid(u32 apicid);
-extern void __init check_x2apic(void);
 extern void x2apic_setup(void);
 static inline int x2apic_enabled(void)
 {
@@ -258,13 +257,13 @@ static inline int x2apic_enabled(void)
 
 #define x2apic_supported()	(boot_cpu_has(X86_FEATURE_X2APIC))
 #else /* !CONFIG_X86_X2APIC */
-static inline void check_x2apic(void) { }
 static inline void x2apic_setup(void) { }
 static inline int x2apic_enabled(void) { return 0; }
 
 #define x2apic_mode		(0)
 #define	x2apic_supported()	(0)
 #endif /* !CONFIG_X86_X2APIC */
+extern void __init check_x2apic(void);
 
 struct irq_data;
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c6876d3ea4b1..20d9a604da7c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1931,16 +1931,19 @@ void __init check_x2apic(void)
 	}
 }
 #else /* CONFIG_X86_X2APIC */
-static int __init validate_x2apic(void)
+void __init check_x2apic(void)
 {
 	if (!apic_is_x2apic_enabled())
-		return 0;
+		return;
 	/*
-	 * Checkme: Can we simply turn off x2apic here instead of panic?
+	 * Checkme: Can we simply turn off x2APIC here instead of disabling the APIC?
 	 */
-	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
+	pr_err("Kernel does not support x2APIC, please recompile with CONFIG_X86_X2APIC.\n");
+	pr_err("Disabling APIC, expect reduced performance and functionality.\n");
+
+	disable_apic = 1;
+	setup_clear_cpu_cap(X86_FEATURE_APIC);
 }
-early_initcall(validate_x2apic);
 
 static inline void try_to_enable_x2apic(int remap_mode) { }
 static inline void __x2apic_enable(void) { }
-- 
2.35.1



