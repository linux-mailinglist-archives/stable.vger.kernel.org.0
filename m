Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840146B4447
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjCJOWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjCJOWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:22:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383D511997B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:21:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0F17B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F16C433D2;
        Fri, 10 Mar 2023 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458096;
        bh=zPct63Z4+AehcZ6OMqHS+3OlfTiG22VT9D5oSjBaZAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usdBXlPv8czB9lS6E1rFXsrmctdRcmQaReJRYjpo50IH6o0qWAaZM8P7y/AcOwZFM
         x5JLJrJiRxsHDRfgj+4m3l6y0uF6hA9O/ZElqDY+axlvfzRqPFWdxnOPHlxpI9OjlE
         mnJgBkHM3di69sW7to3AvuxvEJCB+IjoMFtNuksY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>,
        stable@kernel.org
Subject: [PATCH 4.19 163/252] x86/microcode/AMD: Fix mixed steppings support
Date:   Fri, 10 Mar 2023 14:38:53 +0100
Message-Id: <20230310133723.782874925@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 7ff6edf4fef38ab404ee7861f257e28eaaeed35f upstream.

The AMD side of the loader has always claimed to support mixed
steppings. But somewhere along the way, it broke that by assuming that
the cached patch blob is a single one instead of it being one per
*node*.

So turn it into a per-node one so that each node can stash the blob
relevant for it.

  [ NB: Fixes tag is not really the exactly correct one but it is good
    enough. ]

Fixes: fe055896c040 ("x86/microcode: Merge the early microcode loader")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org> # 2355370cd941 ("x86/microcode/amd: Remove load_microcode_amd()'s bsp parameter")
Cc: <stable@kernel.org> # a5ad92134bd1 ("x86/microcode/AMD: Add a @cpu parameter to the reloading functions")
Link: https://lore.kernel.org/r/20230130161709.11615-4-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -54,7 +54,9 @@ struct cont_desc {
 };
 
 static u32 ucode_new_rev;
-static u8 amd_ucode_patch[PATCH_MAX_SIZE];
+
+/* One blob per node. */
+static u8 amd_ucode_patch[MAX_NUMNODES][PATCH_MAX_SIZE];
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio
@@ -210,7 +212,7 @@ apply_microcode_early_amd(u32 cpuid_1_ea
 	patch	= (u8 (*)[PATCH_MAX_SIZE])__pa_nodebug(&amd_ucode_patch);
 #else
 	new_rev = &ucode_new_rev;
-	patch	= &amd_ucode_patch;
+	patch	= &amd_ucode_patch[0];
 #endif
 
 	desc.cpuid_1_eax = cpuid_1_eax;
@@ -356,10 +358,10 @@ int __init save_microcode_in_initrd_amd(
 
 void reload_ucode_amd(unsigned int cpu)
 {
-	struct microcode_amd *mc;
 	u32 rev, dummy;
+	struct microcode_amd *mc;
 
-	mc = (struct microcode_amd *)amd_ucode_patch;
+	mc = (struct microcode_amd *)amd_ucode_patch[cpu_to_node(cpu)];
 
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
@@ -699,6 +701,8 @@ static enum ucode_state __load_microcode
 
 static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 {
+	struct cpuinfo_x86 *c;
+	unsigned int nid, cpu;
 	struct ucode_patch *p;
 	enum ucode_state ret;
 
@@ -711,18 +715,22 @@ static enum ucode_state load_microcode_a
 		return ret;
 	}
 
-	p = find_patch(0);
-	if (!p) {
-		return ret;
-	} else {
-		if (boot_cpu_data.microcode >= p->patch_id)
-			return ret;
+	for_each_node(nid) {
+		cpu = cpumask_first(cpumask_of_node(nid));
+		c = &cpu_data(cpu);
+
+		p = find_patch(cpu);
+		if (!p)
+			continue;
+
+		if (c->microcode >= p->patch_id)
+			continue;
 
 		ret = UCODE_NEW;
-	}
 
-	memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
-	memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data), PATCH_MAX_SIZE));
+		memset(&amd_ucode_patch[nid], 0, PATCH_MAX_SIZE);
+		memcpy(&amd_ucode_patch[nid], p->data, min_t(u32, ksize(p->data), PATCH_MAX_SIZE));
+	}
 
 	return ret;
 }


