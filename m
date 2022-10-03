Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C99A5F29DB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiJCH0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiJCHYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:24:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E438637192;
        Mon,  3 Oct 2022 00:18:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AE6860F08;
        Mon,  3 Oct 2022 07:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8D1C433D7;
        Mon,  3 Oct 2022 07:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781378;
        bh=1IZBZDt+Wlcs3Xkk1ok1GE/KHjIXbz2z7WjYvzPlrRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9JYh6eM3+IjCCe96Jo9zQzFTTS0eCEIWptItosWvde9fHbcW2KhJI3oECUrzYxwM
         kvGj611ZDdMZ+0XgWQAmgQShjA29WyA2wkpXth4uFYvIHfwMw0ITewyLvyZzihZ09/
         w4HIaEzfG1k6TMLRzgxUECiqSCL5Ssysr6te3gp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.19 099/101] x86/cacheinfo: Add a cpu_llc_shared_mask() UP variant
Date:   Mon,  3 Oct 2022 09:11:35 +0200
Message-Id: <20221003070726.891304655@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

commit df5b035b5683d6a25f077af889fb88e09827f8bc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/smp.h |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -21,16 +21,6 @@ DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_llc
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
@@ -179,6 +179,11 @@ static inline int wbinvd_on_all_cpus(voi
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


