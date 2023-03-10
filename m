Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD96B4474
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjCJOY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjCJOYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:24:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA452F793
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF079CE290B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C03C433EF;
        Fri, 10 Mar 2023 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458184;
        bh=P7ANxNI8vGnTHoYsX1RHY7+Tym4hE7xBvh0nKSEweqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wf65Jmt5MAoXvO4LpEByiTN7ODw9TtSbs+VMJoUdy1e2hR+/C6qYtLxljBlvVFb4s
         GfgC6PX+s3xCUpblG9VIH32b3EylFeIsShp+rAZgCatOtOCDqJSQ4NE9Rmb9xtZMXk
         AAAezXGt4OegqxRwPdGo5Ik31hWdH1B/YSRz7qU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 4.19 162/252] x86/microcode/AMD: Add a @cpu parameter to the reloading functions
Date:   Fri, 10 Mar 2023 14:38:52 +0100
Message-Id: <20230310133723.742413876@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov (AMD) <bp@alien8.de>

commit a5ad92134bd153a9ccdcddf09a95b088f36c3cce upstream.

Will be used in a subsequent change.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230130161709.11615-3-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/microcode.h     |    4 ++--
 arch/x86/include/asm/microcode_amd.h |    4 ++--
 arch/x86/kernel/cpu/microcode/amd.c  |    2 +-
 arch/x86/kernel/cpu/microcode/core.c |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -130,7 +130,7 @@ static inline unsigned int x86_cpuid_fam
 int __init microcode_init(void);
 extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
-void reload_early_microcode(void);
+void reload_early_microcode(unsigned int cpu);
 extern bool get_builtin_firmware(struct cpio_data *cd, const char *name);
 extern bool initrd_gone;
 void microcode_bsp_resume(void);
@@ -138,7 +138,7 @@ void microcode_bsp_resume(void);
 static inline int __init microcode_init(void)			{ return 0; };
 static inline void __init load_ucode_bsp(void)			{ }
 static inline void load_ucode_ap(void)				{ }
-static inline void reload_early_microcode(void)			{ }
+static inline void reload_early_microcode(unsigned int cpu)	{ }
 static inline void microcode_bsp_resume(void)			{ }
 static inline bool
 get_builtin_firmware(struct cpio_data *cd, const char *name)	{ return false; }
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -47,12 +47,12 @@ struct microcode_amd {
 extern void __init load_ucode_amd_bsp(unsigned int family);
 extern void load_ucode_amd_ap(unsigned int family);
 extern int __init save_microcode_in_initrd_amd(unsigned int family);
-void reload_ucode_amd(void);
+void reload_ucode_amd(unsigned int cpu);
 #else
 static inline void __init load_ucode_amd_bsp(unsigned int family) {}
 static inline void load_ucode_amd_ap(unsigned int family) {}
 static inline int __init
 save_microcode_in_initrd_amd(unsigned int family) { return -EINVAL; }
-void reload_ucode_amd(void) {}
+static inline void reload_ucode_amd(unsigned int cpu) {}
 #endif
 #endif /* _ASM_X86_MICROCODE_AMD_H */
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -354,7 +354,7 @@ int __init save_microcode_in_initrd_amd(
 	return 0;
 }
 
-void reload_ucode_amd(void)
+void reload_ucode_amd(unsigned int cpu)
 {
 	struct microcode_amd *mc;
 	u32 rev, dummy;
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -326,7 +326,7 @@ struct cpio_data find_microcode_in_initr
 #endif
 }
 
-void reload_early_microcode(void)
+void reload_early_microcode(unsigned int cpu)
 {
 	int vendor, family;
 
@@ -340,7 +340,7 @@ void reload_early_microcode(void)
 		break;
 	case X86_VENDOR_AMD:
 		if (family >= 0x10)
-			reload_ucode_amd();
+			reload_ucode_amd(cpu);
 		break;
 	default:
 		break;
@@ -783,7 +783,7 @@ void microcode_bsp_resume(void)
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
 	else if (!uci->mc)
-		reload_early_microcode();
+		reload_early_microcode(cpu);
 }
 
 static struct syscore_ops mc_syscore_ops = {


