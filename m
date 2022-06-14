Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3171E54B8F4
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357063AbiFNSlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356711AbiFNSlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F167A49909;
        Tue, 14 Jun 2022 11:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E6C4617C2;
        Tue, 14 Jun 2022 18:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A891C3411D;
        Tue, 14 Jun 2022 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232081;
        bh=o8lUshtwV6A8yIw598SaYBt6OQxFa+3oR479FU/UOwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTt7qmfZ1scSr58nLDrCOiovxV1N2kqAPNDSKWRzHh/xyA0kYme1xrtPs3fYZeuR1
         6r4F+fqOSNdFeXXGvb9RWuL61WxwjoXwtaogpOuNq5q1JJAsKZ5wna6HjwCmg9BQ+N
         qW+WdYHTC0oTsNUQ65CcZgzlmEAJHjuimhqAGV+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.9 17/20] x86/speculation/srbds: Update SRBDS mitigation selection
Date:   Tue, 14 Jun 2022 20:40:00 +0200
Message-Id: <20220614183726.151810525@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
References: <20220614183722.061550591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 22cac9c677c95f3ac5c9244f8ca0afdc7c8afb19 upstream

Currently, Linux disables SRBDS mitigation on CPUs not affected by
MDS and have the TSX feature disabled. On such CPUs, secrets cannot
be extracted from CPU fill buffers using MDS or TAA. Without SRBDS
mitigation, Processor MMIO Stale Data vulnerabilities can be used to
extract RDRAND, RDSEED, and EGETKEY data.

Do not disable SRBDS mitigation by default when CPU is also affected by
Processor MMIO Stale Data vulnerabilities.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -577,11 +577,13 @@ static void __init srbds_select_mitigati
 		return;
 
 	/*
-	 * Check to see if this is one of the MDS_NO systems supporting
-	 * TSX that are only exposed to SRBDS when TSX is enabled.
+	 * Check to see if this is one of the MDS_NO systems supporting TSX that
+	 * are only exposed to SRBDS when TSX is enabled or when CPU is affected
+	 * by Processor MMIO Stale Data vulnerability.
 	 */
 	ia32_cap = x86_read_arch_cap_msr();
-	if ((ia32_cap & ARCH_CAP_MDS_NO) && !boot_cpu_has(X86_FEATURE_RTM))
+	if ((ia32_cap & ARCH_CAP_MDS_NO) && !boot_cpu_has(X86_FEATURE_RTM) &&
+	    !boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
 		srbds_mitigation = SRBDS_MITIGATION_TSX_OFF;
 	else if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		srbds_mitigation = SRBDS_MITIGATION_HYPERVISOR;


