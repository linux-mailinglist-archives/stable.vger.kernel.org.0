Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8465F4F6B00
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiDFUOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237033AbiDFUN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:13:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C137E1B60F3;
        Wed,  6 Apr 2022 11:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F27B61C57;
        Wed,  6 Apr 2022 18:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702AFC385A3;
        Wed,  6 Apr 2022 18:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269681;
        bh=Ar6wQxHGUgKLPgy00kKXXw91vno3jB1Vdh5h58ZAXlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TG0+vkYgKTOWNP3oEE1kylw2RVQY6wuVgz6CdB43FhNN64zU9eogAo1GA3maucujA
         5Xbok/TkpSrz1PZ17FOVKlOWOE1attGQ8/3vMh06bGdH2WmNpZkN8yCQvrREMqU+UG
         1TP3f+myFnvtxQUkyVUNxrr+rVy/X+fKhM7mqISY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 05/43] arm64: capabilities: Move errata work around check on boot CPU
Date:   Wed,  6 Apr 2022 20:26:14 +0200
Message-Id: <20220406182436.835640694@linuxfoundation.org>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 5e91107b06811f0ca147cebbedce53626c9c4443 ]

We trigger CPU errata work around check on the boot CPU from
smp_prepare_boot_cpu() to make sure that we run the checks only
after the CPU feature infrastructure is initialised. While this
is correct, we can also do this from init_cpu_features() which
initilises the infrastructure, and is called only on the
Boot CPU. This helps to consolidate the CPU capability handling
to cpufeature.c. No functional changes.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |    5 +++++
 arch/arm64/kernel/smp.c        |    6 ------
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -476,6 +476,11 @@ void __init init_cpu_features(struct cpu
 		init_cpu_ftr_reg(SYS_MVFR2_EL1, info->reg_mvfr2);
 	}
 
+	/*
+	 * Run the errata work around checks on the boot CPU, once we have
+	 * initialised the cpu feature infrastructure.
+	 */
+	update_cpu_errata_workarounds();
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -444,12 +444,6 @@ void __init smp_prepare_boot_cpu(void)
 	jump_label_init();
 	cpuinfo_store_boot_cpu();
 	save_boot_cpu_run_el();
-	/*
-	 * Run the errata work around checks on the boot CPU, once we have
-	 * initialised the cpu feature infrastructure from
-	 * cpuinfo_store_boot_cpu() above.
-	 */
-	update_cpu_errata_workarounds();
 }
 
 static u64 __init of_get_cpu_mpidr(struct device_node *dn)


