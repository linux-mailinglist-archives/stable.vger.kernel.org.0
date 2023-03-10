Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00D96B45E5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjCJOi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjCJOiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:38:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA93B441
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7933B822E0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41D4C4339C;
        Fri, 10 Mar 2023 14:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459076;
        bh=18UahwAOv87ERH6C1Bc2ZaRAD0AML/qKuysvTLkXdxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieklEfuuAXBoNmt/+8JMLn6Epp5mn+vtCQLRuCrxt2d5q/aeLsUSZIo1PF1NHeHMs
         R8BXxExJ+aYzW2btftO+I3ALiTHlu6se+v/0KVxMx0zNaxCOy+F0lvH4JO/f0ZDR4n
         /41g2YYrL/xQUl6u+nHvqrIUW7W05Jofhl9n/i88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.4 240/357] x86/microcode/AMD: Add a @cpu parameter to the reloading functions
Date:   Fri, 10 Mar 2023 14:38:49 +0100
Message-Id: <20230310133745.339610366@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
@@ -131,7 +131,7 @@ static inline unsigned int x86_cpuid_fam
 int __init microcode_init(void);
 extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
-void reload_early_microcode(void);
+void reload_early_microcode(unsigned int cpu);
 extern bool get_builtin_firmware(struct cpio_data *cd, const char *name);
 extern bool initrd_gone;
 void microcode_bsp_resume(void);
@@ -139,7 +139,7 @@ void microcode_bsp_resume(void);
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
@@ -573,7 +573,7 @@ int __init save_microcode_in_initrd_amd(
 	return 0;
 }
 
-void reload_ucode_amd(void)
+void reload_ucode_amd(unsigned int cpu)
 {
 	struct microcode_amd *mc;
 	u32 rev, dummy;
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -322,7 +322,7 @@ struct cpio_data find_microcode_in_initr
 #endif
 }
 
-void reload_early_microcode(void)
+void reload_early_microcode(unsigned int cpu)
 {
 	int vendor, family;
 
@@ -336,7 +336,7 @@ void reload_early_microcode(void)
 		break;
 	case X86_VENDOR_AMD:
 		if (family >= 0x10)
-			reload_ucode_amd();
+			reload_ucode_amd(cpu);
 		break;
 	default:
 		break;
@@ -782,7 +782,7 @@ void microcode_bsp_resume(void)
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
 	else if (!uci->mc)
-		reload_early_microcode();
+		reload_early_microcode(cpu);
 }
 
 static struct syscore_ops mc_syscore_ops = {


