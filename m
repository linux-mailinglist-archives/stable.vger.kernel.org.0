Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF07253A6A8
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353653AbiFANzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353786AbiFANyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:54:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD24880D3;
        Wed,  1 Jun 2022 06:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82FC6615C2;
        Wed,  1 Jun 2022 13:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2D3C3411E;
        Wed,  1 Jun 2022 13:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091612;
        bh=SIzEPNmhi3uXel6os5Hdua5jcjP8PY79NTHws9hQrjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=schzvg+9xNdHfJipX2ibmAFcR8qV0w98WTonlocf3Y4MR6yCA1mXUEQN1ykt5/zXa
         quWJZGTcz5GbdZGEOgW637X1WMQORweWRnrOx/cHLGOk+shEGH6Pd1s5oA7nOgUBPs
         e46/YQqWHuiHwe0/63B7bAdv4/ae9EJOGyyCZmX0LKgyvRzNd3yKlkvuGGDFGfW49I
         iKygt/3zd94vIbXAgkKhN2BxIvPrwmCCCHV+G7QWCcWKWj08pEV/gjqHCCA0JTm52l
         aKIe/puNXJ4i5WHDhaS3nzvz64reYLpTZrL18UhuhXhpWSNio/e1V/04TaOpUoEXWX
         W6PA0J5MfUAvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, aik@ozlabs.ru, clg@kaod.org,
        seanjc@google.com, bharata@linux.ibm.com,
        maciej.szmigiero@oracle.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.18 33/49] KVM: PPC: Book3S HV Nested: L2 LPCR should inherit L1 LPES setting
Date:   Wed,  1 Jun 2022 09:51:57 -0400
Message-Id: <20220601135214.2002647-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
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
index 6fa518f6501d..43af871383c2 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5283,6 +5283,10 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
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
index c943a051c6e7..265bb30a0af2 100644
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

