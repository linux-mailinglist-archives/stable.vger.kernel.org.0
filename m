Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEAB63DD9E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiK3S3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiK3S26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:28:58 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6039D3E097
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:28:58 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0677ED1;
        Wed, 30 Nov 2022 10:29:04 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.197.38])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EC5E3F73B;
        Wed, 30 Nov 2022 10:28:57 -0800 (PST)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [stable:PATCH v5.4.225 2/2] arm64: errata: Fix KVM Spectre-v2 mitigation selection  for Cortex-A57/A72
Date:   Wed, 30 Nov 2022 18:28:19 +0000
Message-Id: <20221130182819.739068-3-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221130182819.739068-1-james.morse@arm.com>
References: <20221130182819.739068-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both the Spectre-v2 and Spectre-BHB mitigations involve running a sequence
immediately after exiting a guest, before any branches. In the stable
kernels these sequences are built by copying templates into an empty vector
slot.

For Spectre-BHB, Cortex-A57 and A72 require the branchy loop with k=8.
If Spectre-v2 needs mitigating at the same time, a firmware call to EL3 is
needed. The work EL3 does at this point is also enough to mitigate
Spectre-BHB.

When enabling the Spectre-BHB mitigation, spectre_bhb_enable_mitigation()
should check if a slot has already been allocated for Spectre-v2, meaning
no work is needed for Spectre-BHB.

This check was missed in the earlier backport, add it.

Fixes: 9013fd4bc958 ("arm64: Mitigate spectre style branch history side channels")
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/cpu_errata.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 2a7c05640b38..b18f307a3c59 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -1363,7 +1363,13 @@ void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
 	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
 		switch (spectre_bhb_loop_affected(SCOPE_SYSTEM)) {
 		case 8:
-			kvm_setup_bhb_slot(__spectre_bhb_loop_k8_start);
+			/*
+			 * A57/A72-r0 will already have selected the
+			 * spectre-indirect vector, which is sufficient
+			 * for BHB too.
+			 */
+			if (!__this_cpu_read(bp_hardening_data.fn))
+				kvm_setup_bhb_slot(__spectre_bhb_loop_k8_start);
 			break;
 		case 24:
 			kvm_setup_bhb_slot(__spectre_bhb_loop_k24_start);
-- 
2.30.2

