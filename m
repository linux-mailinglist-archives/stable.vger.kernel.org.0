Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1666B7247
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCMJPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjCMJO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A40CC13;
        Mon, 13 Mar 2023 02:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F380B80EAC;
        Mon, 13 Mar 2023 09:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5395C433A4;
        Mon, 13 Mar 2023 09:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678698891;
        bh=Wye0Vl6QFmyMU9FOa/kaj5qWj9XcQLGu7BWa7lw7V9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewkzT/nuk5WO/zD80cVndUZQKir9qXYDKY1GCbp7xOHH+0x3xDBv4/hWKhbkcwJBt
         7L1CmGNRpMRIlGgd0VrEg1oc70SJFCBNYgDSu+m2mz4RFALpMirVskbfdrO0g0EGcQ
         CWCOfzirYmAhzpMIXWKCb3v4kO4+cPo1/NZRq3Lg/kQghJZDsZJQE5eEQu5EXZKJkx
         NwT5c0fLPoUKV+0uLbeJ6Uci+i5f35sD2fj+LacYJCJy/EGj7tQhel6Y1FR/dR7QBB
         pX7Hs44NYUSM7aHpoZX875G/2aKgZVXs2O3X613+p4qiZ0YLjoYLg8bp5GZZWlzted
         cdMOyEVWTVFJQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbeGW-00HAzq-LW;
        Mon, 13 Mar 2023 09:14:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: Check for kvm_vma_mte_allowed in the critical section
Date:   Mon, 13 Mar 2023 09:14:25 +0000
Message-Id: <20230313091425.1962708-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313091425.1962708-1-maz@kernel.org>
References: <20230313091425.1962708-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ardb@kernel.org, will@kernel.org, qperret@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On page fault, we find about the VMA that backs the page fault
early on, and quickly release the mmap_read_lock. However, using
the VMA pointer after the critical section is pretty dangerous,
as a teardown may happen in the meantime and the VMA be long gone.

Move the sampling of the MTE permission early, and NULL-ify the
VMA pointer after that, just to be on the safe side.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d7b8b25942df..2424be11eb52 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1208,7 +1208,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
-	bool exec_fault;
+	bool exec_fault, mte_allowed;
 	bool device = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
@@ -1285,6 +1285,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		fault_ipa &= ~(vma_pagesize - 1);
 
 	gfn = fault_ipa >> PAGE_SHIFT;
+	mte_allowed = kvm_vma_mte_allowed(vma);
+	/* Don't use the VMA after that -- it may have vanished */
+	vma = NULL;
 	mmap_read_unlock(current->mm);
 
 	/*
@@ -1375,7 +1378,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (kvm_vma_mte_allowed(vma)) {
+		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
 			ret = -EFAULT;
-- 
2.34.1

