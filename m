Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BE14F6A91
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiDFTyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbiDFTxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D9519316D;
        Wed,  6 Apr 2022 11:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3DC361C57;
        Wed,  6 Apr 2022 18:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E012EC385A3;
        Wed,  6 Apr 2022 18:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269651;
        bh=4PDQbNjEWgyzjgN+9Ms2UXb1BtWf2djd8Z39TxrINqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4pWES0BVK2Ay0bVHAfCahl5HKu3uECEWavXm/yeCTEA9sD4MQ+cwf0EluCCl0UBv
         LpF5zVoiuN7+wn4sYSpWAf6mT8PoLZozq7/obpNS062RDLwbAX7k9yHJzwus0/FbrM
         5hQ+SKX+NfdCBKtEOLurhXiFqejJ7zzWfTZ6mt/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 02/43] arm64: Remove useless UAO IPI and describe how this gets enabled
Date:   Wed,  6 Apr 2022 20:26:11 +0200
Message-Id: <20220406182436.748478940@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit c8b06e3fddddaae1a87ed479edcb8b3d85caecc7 upstream.

Since its introduction, the UAO enable call was broken, and useless.
commit 2a6dcb2b5f3e ("arm64: cpufeature: Schedule enable() calls instead
of calling them via IPI"), fixed the framework so that these calls
are scheduled, so that they can modify PSTATE.

Now it is just useless. Remove it. UAO is enabled by the code patching
which causes get_user() and friends to use the 'ldtr' family of
instructions. This relies on the PSTATE.UAO bit being set to match
addr_limit, which we do in uao_thread_switch() called via __switch_to().

All that is needed to enable UAO is patch the code, and call schedule().
__apply_alternatives_multi_stop() calls stop_machine() when it modifies
the kernel text to enable the alternatives, (including the UAO code in
uao_thread_switch()). Once stop_machine() has finished __switch_to() is
called to reschedule the original task, this causes PSTATE.UAO to be set
appropriately. An explicit enable() call is not needed.

Reported-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/processor.h |    1 -
 arch/arm64/kernel/cpufeature.c     |    5 ++++-
 arch/arm64/mm/fault.c              |   14 --------------
 3 files changed, 4 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -220,7 +220,6 @@ static inline void spin_lock_prefetch(co
 #endif
 
 int cpu_enable_pan(void *__unused);
-int cpu_enable_uao(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
 
 #endif /* __ASSEMBLY__ */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -905,7 +905,10 @@ static const struct arm64_cpu_capabiliti
 		.sys_reg = SYS_ID_AA64MMFR2_EL1,
 		.field_pos = ID_AA64MMFR2_UAO_SHIFT,
 		.min_field_value = 1,
-		.enable = cpu_enable_uao,
+		/*
+		 * We rely on stop_machine() calling uao_thread_switch() to set
+		 * UAO immediately after patching.
+		 */
 	},
 #endif /* CONFIG_ARM64_UAO */
 #ifdef CONFIG_ARM64_PAN
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -740,17 +740,3 @@ int cpu_enable_pan(void *__unused)
 	return 0;
 }
 #endif /* CONFIG_ARM64_PAN */
-
-#ifdef CONFIG_ARM64_UAO
-/*
- * Kernel threads have fs=KERNEL_DS by default, and don't need to call
- * set_fs(), devtmpfs in particular relies on this behaviour.
- * We need to enable the feature at runtime (instead of adding it to
- * PSR_MODE_EL1h) as the feature may not be implemented by the cpu.
- */
-int cpu_enable_uao(void *__unused)
-{
-	asm(SET_PSTATE_UAO(1));
-	return 0;
-}
-#endif /* CONFIG_ARM64_UAO */


