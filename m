Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6A8501190
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244999AbiDNNiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344288AbiDNNbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:31:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A954E6;
        Thu, 14 Apr 2022 06:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC67561B18;
        Thu, 14 Apr 2022 13:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086C7C385A5;
        Thu, 14 Apr 2022 13:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942948;
        bh=WBZ/+bgpIHKBuhV6mX/mZSkeNZU9jK8K7cpWbpeUv3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0h3N9H6wDO/Qnp7ceDXNGANwxv3l9pPg2+hSdh7Z7GYVvDeygggmNiwuhjuR/Kn8
         hu+N0Cqoljr+2UBSzAATujuLOoco9MePX8YsqWXfjvayk25uZqsK3E4tyP352Q+HXX
         GTa2ocpDRGi1mQyfKHIEFkajt+e+uUf7ZHuMbYFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 318/338] x86/speculation: Restore speculation related MSRs during S3 resume
Date:   Thu, 14 Apr 2022 15:13:41 +0200
Message-Id: <20220414110847.938325381@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit e2a1256b17b16f9b9adf1b6fea56819e7b68e463 upstream.

After resuming from suspend-to-RAM, the MSRs that control CPU's
speculative execution behavior are not being restored on the boot CPU.

These MSRs are used to mitigate speculative execution vulnerabilities.
Not restoring them correctly may leave the CPU vulnerable.  Secondary
CPU's MSRs are correctly being restored at S3 resume by
identify_secondary_cpu().

During S3 resume, restore these MSRs for boot CPU when restoring its
processor state.

Fixes: 772439717dbf ("x86/bugs/intel: Set proper CPU features and setup RDS")
Reported-by: Neelima Krishnan <neelima.krishnan@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/power/cpu.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -517,10 +517,24 @@ static int pm_cpu_check(const struct x86
 	return ret;
 }
 
+static void pm_save_spec_msr(void)
+{
+	u32 spec_msr_id[] = {
+		MSR_IA32_SPEC_CTRL,
+		MSR_IA32_TSX_CTRL,
+		MSR_TSX_FORCE_ABORT,
+		MSR_IA32_MCU_OPT_CTRL,
+		MSR_AMD64_LS_CFG,
+	};
+
+	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
+}
+
 static int pm_check_save_msr(void)
 {
 	dmi_check_system(msr_save_dmi_table);
 	pm_cpu_check(msr_save_cpu_table);
+	pm_save_spec_msr();
 
 	return 0;
 }


