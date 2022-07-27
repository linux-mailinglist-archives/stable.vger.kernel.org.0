Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF89583127
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbiG0RrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243196AbiG0Rqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:46:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7A84D4CB;
        Wed, 27 Jul 2022 09:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82B67B821B9;
        Wed, 27 Jul 2022 16:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E066CC433D6;
        Wed, 27 Jul 2022 16:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940826;
        bh=xzLNXcz4miuOscNHT52+ulkgeYXs8Noj2UPKsvKI/sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjODPlLPzo0xDwjwl6mxSJQ+YePeSyljkS78N74zj29beypFSkNPZWs8lEaNgcLVy
         +Ibh8WrS9FN9FAoX9o+l4ULb+nY+nRFnc1ayOenKZEIb0H6n097NUh1o+7tGhWm7Cz
         GPjqaaUlVO4rQoDso5ZBNPQX7NKurTcJ0uYKUngU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 137/158] x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts
Date:   Wed, 27 Jul 2022 18:13:21 +0200
Message-Id: <20220727161026.871390189@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -968,6 +968,7 @@ static inline const char *spectre_v2_mod
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
 #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
+#define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
 
 #ifdef CONFIG_BPF_SYSCALL
 void unpriv_ebpf_notify(int new_state)
@@ -1408,6 +1409,8 @@ static void __init spectre_v2_select_mit
 
 	case SPECTRE_V2_IBRS:
 		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
+			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
 		break;
 
 	case SPECTRE_V2_LFENCE:


