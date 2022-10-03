Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB9F5F288E
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 08:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiJCGUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 02:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJCGUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 02:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0554D1A833
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 23:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B56B9B80D89
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 06:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4C9C433C1;
        Mon,  3 Oct 2022 06:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664778014;
        bh=Rifr6k1WDW+64Lo9hk8hnWrhaKSdsMlQWX4K26yJuz4=;
        h=Subject:To:Cc:From:Date:From;
        b=ZkBGVz+uiE/gUpaJdZv/HcONk2fiT7W8BCaq55u9/LKoLWvtxZRg6rPdFzFfmyGy0
         62dkCwLoGmRp33R4lhPi1gTbaPq9ND7kpKghEfTAUauf7g6sd7qSDh1bVJptDHGpOf
         t5Et3VkI/pPFnRltyBH0TcVDkH/LyynCOgGChrHk=
Subject: FAILED: patch "[PATCH] x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant" failed to apply to 4.19-stable tree
To:     bp@suse.de, ssengar@linux.microsoft.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Oct 2022 08:20:34 +0200
Message-ID: <166477803473234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

df5b035b5683 ("x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant")
66558b730f25 ("sched: Add cluster scheduler level for x86")
9164d9493a79 ("x86/cpu: Add get_llc_id() helper function")
2c88d45edbb8 ("x86, sched: Treat Intel SNC topology as default, COD as exception")
adefe55e7258 ("x86/kernel: Convert to new CPU match macros")
45fc24e89b7c ("x86/mpx: remove MPX from arch/x86")
0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
9326011edfcb ("Merge branch 'x86/cleanups' into x86/cpu, to pick up dependent changes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From df5b035b5683d6a25f077af889fb88e09827f8bc Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Fri, 19 Aug 2022 19:47:44 +0200
Subject: [PATCH] x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant

On a CONFIG_SMP=n kernel, the LLC shared mask is 0, which prevents
__cache_amd_cpumap_setup() from doing the L3 masks setup, and more
specifically from setting up the shared_cpu_map and shared_cpu_list
files in sysfs, leading to lscpu from util-linux getting confused and
segfaulting.

Add a cpu_llc_shared_mask() UP variant which returns a mask with a
single bit set, i.e., for CPU0.

Fixes: 2b83809a5e6d ("x86/cpu/amd: Derive L3 shared_cpu_map from cpu_llc_shared_mask")
Reported-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1660148115-302-1-git-send-email-ssengar@linux.microsoft.com

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 81a0211a372d..a73bced40e24 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -21,16 +21,6 @@ DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id);
 DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_l2c_id);
 DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
 
-static inline struct cpumask *cpu_llc_shared_mask(int cpu)
-{
-	return per_cpu(cpu_llc_shared_map, cpu);
-}
-
-static inline struct cpumask *cpu_l2c_shared_mask(int cpu)
-{
-	return per_cpu(cpu_l2c_shared_map, cpu);
-}
-
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u32, x86_cpu_to_acpiid);
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid);
@@ -172,6 +162,16 @@ extern int safe_smp_processor_id(void);
 # define safe_smp_processor_id()	smp_processor_id()
 #endif
 
+static inline struct cpumask *cpu_llc_shared_mask(int cpu)
+{
+	return per_cpu(cpu_llc_shared_map, cpu);
+}
+
+static inline struct cpumask *cpu_l2c_shared_mask(int cpu)
+{
+	return per_cpu(cpu_l2c_shared_map, cpu);
+}
+
 #else /* !CONFIG_SMP */
 #define wbinvd_on_cpu(cpu)     wbinvd()
 static inline int wbinvd_on_all_cpus(void)
@@ -179,6 +179,11 @@ static inline int wbinvd_on_all_cpus(void)
 	wbinvd();
 	return 0;
 }
+
+static inline struct cpumask *cpu_llc_shared_mask(int cpu)
+{
+	return (struct cpumask *)cpumask_of(0);
+}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus;

