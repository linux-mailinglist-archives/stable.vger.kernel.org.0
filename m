Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C219F505981
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343803AbiDROUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344634AbiDROSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:18:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDE04A93E;
        Mon, 18 Apr 2022 06:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91B7AB80ED5;
        Mon, 18 Apr 2022 13:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB59C385A1;
        Mon, 18 Apr 2022 13:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287609;
        bh=lo7FtlyJVfJXLnY912gcwlLUcCiexeAFG/oWgZWvNmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qa4qne0V6pLgde7LpK0aKK8lxfU/+DDXOU0WVZRI2Mi2fbG4H+IOxQoP33++iRFkm
         QrFZYVe3neSvGkopjfT8XsGAG0UmSfuqVpxSFyBnXevFs3xmLS7GLPpDZ2XkdjKWk/
         aJpOwuAHuhRwGCrvuOIsSgJGBCS5y4g928NMUaF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lotus Fenn <lotusf@google.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>,
        David Dunn <daviddunn@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 165/218] KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs
Date:   Mon, 18 Apr 2022 14:13:51 +0200
Message-Id: <20220418121205.038224371@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 9b026073db2f1ad0e4d8b61c83316c8497981037 ]

AMD EPYC CPUs never raise a #GP for a WRMSR to a PerfEvtSeln MSR. Some
reserved bits are cleared, and some are not. Specifically, on
Zen3/Milan, bits 19 and 42 are not cleared.

When emulating such a WRMSR, KVM should not synthesize a #GP,
regardless of which bits are set. However, undocumented bits should
not be passed through to the hardware MSR. So, rather than checking
for reserved bits and synthesizing a #GP, just clear the reserved
bits.

This may seem pedantic, but since KVM currently does not support the
"Host/Guest Only" bits (41:40), it is necessary to clear these bits
rather than synthesizing #GP, because some popular guests (e.g Linux)
will set the "Host Only" bit even on CPUs that don't support
EFER.SVME, and they don't expect a #GP.

For example,

root@Ubuntu1804:~# perf stat -e r26 -a sleep 1

 Performance counter stats for 'system wide':

                 0      r26

       1.001070977 seconds time elapsed

Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379957] unchecked MSR access error: WRMSR to 0xc0010200 (tried to write 0x0000020000130026) at rIP: 0xffffffff9b276a28 (native_write_msr+0x8/0x30)
Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379958] Call Trace:
Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379963]  amd_pmu_disable_event+0x27/0x90

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Reported-by: Lotus Fenn <lotusf@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Like Xu <likexu@tencent.com>
Reviewed-by: David Dunn <daviddunn@google.com>
Message-Id: <20220226234131.2167175-1-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu_amd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index cd944435dfbd..e0473c72062e 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -139,12 +139,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	/* MSR_K7_EVNTSELn */
 	pmc = get_gp_pmc(pmu, msr, MSR_K7_EVNTSEL0);
 	if (pmc) {
-		if (data == pmc->eventsel)
-			return 0;
-		if (!(data & pmu->reserved_bits)) {
+		data &= ~pmu->reserved_bits;
+		if (data != pmc->eventsel)
 			reprogram_gp_counter(pmc, data);
-			return 0;
-		}
+		return 0;
 	}
 
 	return 1;
-- 
2.35.1



