Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA9253A778
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354096AbiFAOB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354483AbiFAOA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA95ADF3A;
        Wed,  1 Jun 2022 06:56:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06A3C61555;
        Wed,  1 Jun 2022 13:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FF4C385A5;
        Wed,  1 Jun 2022 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091735;
        bh=a4qFuWEqZC0lHRCkY7Blx87Le22rwe0ztnrHoEFNJ4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsZbOLhaa3NCelbzPOc5toVLk8MqyQgbeCvpb58TCq00xqyZT409nltGmHIiULjji
         TxvlE+G2BBrk3b4dHopiZzW6Mt7RKezCiz8diGSUgo8l9pwJGMi495tq6n3pgBytrY
         ThEH062aaPw9ybKIq/EWwki0dYTM+wikEEzr0sLB0gSEnpBoUtbxWhcogIHmOcAKpq
         Xcv7kXJn1YjuC0jvSK2fByyaajElg0td7yQpswgRc9uSnQFaHwd49Qt7XTzbZSt0Iq
         9R9hW2iIvG0jAEjNF300oXkWDj3f2udw5DVPJWRxHe4W7bwpdrPbx0HZMLDNtk0GDv
         c/rA3DhMdRHig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aik@ozlabs.ru, clg@kaod.org,
        bharata@linux.ibm.com, seanjc@google.com,
        maciej.szmigiero@oracle.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.17 32/48] KVM: PPC: Book3S HV Nested: L2 LPCR should inherit L1 LPES setting
Date:   Wed,  1 Jun 2022 09:54:05 -0400
Message-Id: <20220601135421.2003328-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 2852ebfa10afdcefff35ec72c8da97141df9845c ]

The L1 should not be able to adjust LPES mode for the L2. Setting LPES
if the L0 needs it clear would cause external interrupts to be sent to
L2 and missed by the L0.

Clearing LPES when it may be set, as typically happens with XIVE enabled
could cause a performance issue despite having no native XIVE support in
the guest, because it will cause mediated interrupts for the L2 to be
taken in HV mode, which then have to be injected.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220303053315.1056880-7-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c        | 4 ++++
 arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 316f61a4cb59..0da8c0df768d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5289,6 +5289,10 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 		kvm->arch.host_lpcr = lpcr = mfspr(SPRN_LPCR);
 		lpcr &= LPCR_PECE | LPCR_LPES;
 	} else {
+		/*
+		 * The L2 LPES mode will be set by the L0 according to whether
+		 * or not it needs to take external interrupts in HV mode.
+		 */
 		lpcr = 0;
 	}
 	lpcr |= (4UL << LPCR_DPFD_SH) | LPCR_HDICE |
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 9d373f8963ee..58e05a9122ac 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -261,8 +261,7 @@ static void load_l2_hv_regs(struct kvm_vcpu *vcpu,
 	/*
 	 * Don't let L1 change LPCR bits for the L2 except these:
 	 */
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
-		LPCR_LPES | LPCR_MER;
+	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD | LPCR_MER;
 
 	/*
 	 * Additional filtering is required depending on hardware
-- 
2.35.1

