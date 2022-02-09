Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C5C4AFC4C
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241208AbiBIS5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241191AbiBIS5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:57:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3147C050CC3;
        Wed,  9 Feb 2022 10:57:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3CD8B82384;
        Wed,  9 Feb 2022 18:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BE9C340ED;
        Wed,  9 Feb 2022 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433027;
        bh=cHsPid5BwyM2TYSZCb78GZ0uJjtAROUGJf0j9hx1WQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqMmKAGOsITM0nVkOa3u2DQaWQrT7h7iE7y5ZVgqKzgmTvz+l7VcZw9NPVWaqaszy
         sArtHqwEwcweZGFXXPXomPK6JGOHF+CZvAW0rJBwJke75mgnstOXRji5oLKYUHN7kx
         kj7YqbvxCWewF8HNMnGu1ybEgLKIrw2uKr1ffCdwTCElm95jgSME5qt8T9vNOE/2uz
         amXV3NvCq020TtgUPGHDdt/YiUylblfu+UIk6txRHU245MDtVjTQPXy7NS2idtSQC+
         Ay1yI/VXUf5+rYAyzfwHXokYObhN+1Z5bNZliN/fYL7LaIZg0bynwIoFpgR2wi8XvZ
         OwZ4j0Zzezcvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 6/8] KVM: SVM: Explicitly require DECODEASSISTS to enable SEV support
Date:   Wed,  9 Feb 2022 13:56:51 -0500
Message-Id: <20220209185653.48833-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209185653.48833-1-sashal@kernel.org>
References: <20220209185653.48833-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c532f2903b69b775d27016511fbe29a14a098f95 ]

Add a sanity check on DECODEASSIST being support if SEV is supported, as
KVM cannot read guest private memory and thus relies on the CPU to
provide the instruction byte stream on #NPF for emulation.  The intent of
the check is to document the dependency, it should never fail in practice
as producing hardware that supports SEV but not DECODEASSISTS would be
non-sensical.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Message-Id: <20220120010719.711476-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 134c4ea5e6ad8..d006eeb1d0321 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1887,8 +1887,13 @@ void __init sev_hardware_setup(void)
 	if (!sev_enabled || !npt_enabled)
 		goto out;
 
-	/* Does the CPU support SEV? */
-	if (!boot_cpu_has(X86_FEATURE_SEV))
+	/*
+	 * SEV must obviously be supported in hardware.  Sanity check that the
+	 * CPU supports decode assists, which is mandatory for SEV guests to
+	 * support instruction emulation.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_SEV) ||
+	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)))
 		goto out;
 
 	/* Retrieve SEV CPUID information */
-- 
2.34.1

