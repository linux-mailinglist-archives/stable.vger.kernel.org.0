Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A269C6D3F92
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjDCI4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjDCI4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45D630FE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E9A2616D6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63633C433D2;
        Mon,  3 Apr 2023 08:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680512161;
        bh=YV12aQ26VcTSVLrGxS8Q3pyyily4OWJMmgi/Bq1PzOU=;
        h=Subject:To:Cc:From:Date:From;
        b=ItRcKmZ8hJOgZLQM7mCAfgz/mIFgScHVnOkY0y6SDAlyc4X+fr05PojVIIGT4tygy
         U2mISFUUpLzD/raoUmdGRdBzlZJ3eEIqy+vljm0jVkervR7m/IehifMr9RsGTJ/Wzm
         340kiXiKw1yJhiGn4ihvUQrOaBYqt7uV7idv/G2c=
Subject: FAILED: patch "[PATCH] KVM: arm64: Check for kvm_vma_mte_allowed in the critical" failed to apply to 5.15-stable tree
To:     maz@kernel.org, oliver.upton@linux.dev
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:55:51 +0200
Message-ID: <2023040351-conflict-swan-ae8b@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 8c2e8ac8ad4be68409e806ce1cc78fc7a04539f3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040351-conflict-swan-ae8b@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

8c2e8ac8ad4b ("KVM: arm64: Check for kvm_vma_mte_allowed in the critical section")
13ec9308a857 ("KVM: arm64: Retry fault if vma_lookup() results become invalid")
b0803ba72b55 ("KVM: arm64: Convert FSC_* over to ESR_ELx_FSC_*")
382b5b87a97d ("Merge branch kvm-arm64/mte-map-shared into kvmarm-master/next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c2e8ac8ad4be68409e806ce1cc78fc7a04539f3 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Thu, 16 Mar 2023 17:45:46 +0000
Subject: [PATCH] KVM: arm64: Check for kvm_vma_mte_allowed in the critical
 section

On page fault, we find about the VMA that backs the page fault
early on, and quickly release the mmap_read_lock. However, using
the VMA pointer after the critical section is pretty dangerous,
as a teardown may happen in the meantime and the VMA be long gone.

Move the sampling of the MTE permission early, and NULL-ify the
VMA pointer after that, just to be on the safe side.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230316174546.3777507-3-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cd819725193b..3b9d4d24c361 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1218,7 +1218,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
-	bool exec_fault;
+	bool exec_fault, mte_allowed;
 	bool device = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
@@ -1309,6 +1309,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		fault_ipa &= ~(vma_pagesize - 1);
 
 	gfn = fault_ipa >> PAGE_SHIFT;
+	mte_allowed = kvm_vma_mte_allowed(vma);
+
+	/* Don't use the VMA after the unlock -- it may have vanished */
+	vma = NULL;
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
@@ -1379,7 +1383,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (kvm_vma_mte_allowed(vma)) {
+		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
 			ret = -EFAULT;

