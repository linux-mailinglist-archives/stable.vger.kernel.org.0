Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F4C69CEC4
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjBTOCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjBTOCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:02:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86CA1EFD6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA41BB80B4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664E0C433EF;
        Mon, 20 Feb 2023 14:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901691;
        bh=UZwVvQzzk1Lsv+I8rDaZ08SOLtjXWhwXp2bsePiIR7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzFsE54z+irc8PT6aO6J3oRmAxv9lF80efoEe8x0X6jQheio81It1aZ46hIbgzK5F
         1B5ywMnmpX0/Ahfdk2mt9t+a+FSdQE4PmQgBqlC5U/9c8lP3AXJIWRmdrcwNUK4yhY
         NquMvVvHquwksJ2cXH+IRfbMne5t+abpNEJOsP6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 114/118] perf/x86: Refuse to export capabilities for hybrid PMUs
Date:   Mon, 20 Feb 2023 14:37:10 +0100
Message-Id: <20230220133604.954264352@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 4b4191b8ae1278bde3642acaaef8f92810ed111a upstream.

Now that KVM disables vPMU support on hybrid CPUs, WARN and return zeros
if perf_get_x86_pmu_capability() is invoked on a hybrid CPU.  The helper
doesn't provide an accurate accounting of the PMU capabilities for hybrid
CPUs and needs to be enhanced if KVM, or anything else outside of perf,
wants to act on the PMU capabilities.

Cc: stable@vger.kernel.org
Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Link: https://lore.kernel.org/all/20220818181530.2355034-1-kan.liang@linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230208204230.1360502-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2994,17 +2994,19 @@ unsigned long perf_misc_flags(struct pt_
 
 void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
-	if (!x86_pmu_initialized()) {
+	/* This API doesn't currently support enumerating hybrid PMUs. */
+	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
+	    !x86_pmu_initialized()) {
 		memset(cap, 0, sizeof(*cap));
 		return;
 	}
 
-	cap->version		= x86_pmu.version;
 	/*
-	 * KVM doesn't support the hybrid PMU yet.
-	 * Return the common value in global x86_pmu,
-	 * which available for all cores.
+	 * Note, hybrid CPU models get tracked as having hybrid PMUs even when
+	 * all E-cores are disabled via BIOS.  When E-cores are disabled, the
+	 * base PMU holds the correct number of counters for P-cores.
 	 */
+	cap->version		= x86_pmu.version;
 	cap->num_counters_gp	= x86_pmu.num_counters;
 	cap->num_counters_fixed	= x86_pmu.num_counters_fixed;
 	cap->bit_width_gp	= x86_pmu.cntval_bits;


