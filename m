Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8FF5F30FC
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiJCNNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJCNNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:13:30 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62000501AC;
        Mon,  3 Oct 2022 06:13:07 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0DA9642FB6;
        Mon,  3 Oct 2022 13:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802782;
        bh=izVzSnniHZ6iK//oyP2lya3zGRsESReloLdsqEzyO7A=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Iv8jYpqaecCOf+m3AmnrGGyTirPNk4NEKQPxkF9zSfKD8vVljxB8XuRwQHu7YuKSK
         d4AVQS84RzDZRoTNCpLx2r4sjWp/uZLSVxaC8t8hNPoJ6yXJVfcyosyxzQsQquUkeU
         wZwJJH+jYgykOtkho0KD2fP1umJzfGH3rOFA1P7pSIh0t3O+C2uRZtmhdUtzEDh4lF
         BAZs06RiiWrJk6iRXwIM1yGpX13kK/hg1C6s7CaX1MKFkb4h6VsJxTuqeqL22DVtuA
         QBANAG2fgV3XlPNRbJnw6hyySM24u7Q6PmSWNEzWnF5n2dUIjWla+5+SyoL+xT33AJ
         rQGXvcNvFvC7Q==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 36/37] x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts
Date:   Mon,  3 Oct 2022 10:10:37 -0300
Message-Id: <20221003131038.12645-37-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit eb23b5ef9131e6d65011de349a4d25ef1b3d4314 upstream.

IBRS mitigation for spectre_v2 forces write to MSR_IA32_SPEC_CTRL at
every kernel entry/exit. On Enhanced IBRS parts setting
MSR_IA32_SPEC_CTRL[IBRS] only once at boot is sufficient. MSR writes at
every kernel entry/exit incur unnecessary performance loss.

When Enhanced IBRS feature is present, print a warning about this
unnecessary performance loss.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2a5eaf54583c2bfe0edc4fea64006656256cca17.1657814857.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/kernel/cpu/bugs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 56feba04d1f5..07afdc82b5c8 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -851,6 +851,7 @@ static inline const char *spectre_v2_module_string(void) { return ""; }
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
 #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
+#define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
 
 #ifdef CONFIG_BPF_SYSCALL
 void unpriv_ebpf_notify(int new_state)
@@ -1277,6 +1278,8 @@ static void __init spectre_v2_select_mitigation(void)
 
 	case SPECTRE_V2_IBRS:
 		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
+			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
 		break;
 
 	case SPECTRE_V2_LFENCE:
-- 
2.34.1

