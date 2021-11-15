Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FC8452086
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345986AbhKPAzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245713AbhKOTVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE5B96328B;
        Mon, 15 Nov 2021 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001597;
        bh=fV5uOh05VxwKaWWs9g5a6o9+meRze9rqC/tFkdxlLWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVoDhxGGk8231VrLFRL4mTSH8NS7eup5ASeucLBjTJSVjJlOkoohqenAGqJcbbKTR
         EsBYqeE0PdSdoDB31Gw3iEiaGiUlREhwhYegm7Z1botpHihjrhtHCEIF5rcx6gOY+G
         ErfsVwDW8jMAot3/YXpdtUKVSgHl3iSpJbAXCx9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 251/917] KVM: arm64: Propagate errors from __pkvm_prot_finalize hypercall
Date:   Mon, 15 Nov 2021 17:55:46 +0100
Message-Id: <20211115165437.302624318@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 2f2e1a5069679491d18cf9021da19b40c56a17f3 ]

If the __pkvm_prot_finalize hypercall returns an error, we WARN but fail
to propagate the failure code back to kvm_arch_init().

Pass a pointer to a zero-initialised return variable so that failure
to finalise the pKVM protections on a host CPU can be reported back to
KVM.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211008135839.1193-5-will@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e5183..9b328bb05596a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1971,9 +1971,25 @@ out_err:
 	return err;
 }
 
-static void _kvm_host_prot_finalize(void *discard)
+static void _kvm_host_prot_finalize(void *arg)
 {
-	WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize));
+	int *err = arg;
+
+	if (WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)))
+		WRITE_ONCE(*err, -EINVAL);
+}
+
+static int pkvm_drop_host_privileges(void)
+{
+	int ret = 0;
+
+	/*
+	 * Flip the static key upfront as that may no longer be possible
+	 * once the host stage 2 is installed.
+	 */
+	static_branch_enable(&kvm_protected_mode_initialized);
+	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
+	return ret;
 }
 
 static int finalize_hyp_mode(void)
@@ -1987,15 +2003,7 @@ static int finalize_hyp_mode(void)
 	 * None of other sections should ever be introspected.
 	 */
 	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
-
-	/*
-	 * Flip the static key upfront as that may no longer be possible
-	 * once the host stage 2 is installed.
-	 */
-	static_branch_enable(&kvm_protected_mode_initialized);
-	on_each_cpu(_kvm_host_prot_finalize, NULL, 1);
-
-	return 0;
+	return pkvm_drop_host_privileges();
 }
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
-- 
2.33.0



