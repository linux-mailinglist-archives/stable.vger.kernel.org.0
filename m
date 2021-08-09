Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754B63E443C
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhHIKzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234409AbhHIKzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 06:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1A2A6103B;
        Mon,  9 Aug 2021 10:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628506488;
        bh=tqKz1W6GLZ8fkBJ2UmbtDd9QX8hJ/xRj69Kis9MIdOw=;
        h=Subject:To:Cc:From:Date:From;
        b=DvCAGOKSlHFEmltBMt1uBqPLdrWhza2JnifiaqxaWPLqdtKFFMeF7dWAeV+CATpxr
         7C5EF52qWi20voxwJ+7tttK/wA+I8hfJrvODwpUwEHVmsHkhqslV6H+pLjwD3U5xjm
         efmO5AkutK9Y11gz8DPLaTufpvRMNtmu6zxPPHAM=
Subject: FAILED: patch "[PATCH] KVM: SVM: Fix off-by-one indexing when nullifying last used" failed to apply to 5.4-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 12:54:45 +0200
Message-ID: <1628506485157230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 179c6c27bf487273652efc99acd3ba512a23c137 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 3 Aug 2021 09:27:46 -0700
Subject: [PATCH] KVM: SVM: Fix off-by-one indexing when nullifying last used
 SEV VMCB

Use the raw ASID, not ASID-1, when nullifying the last used VMCB when
freeing an SEV ASID.  The consumer, pre_sev_run(), indexes the array by
the raw ASID, thus KVM could get a false negative when checking for a
different VMCB if KVM manages to reallocate the same ASID+VMCB combo for
a new VM.

Note, this cannot cause a functional issue _in the current code_, as
pre_sev_run() also checks which pCPU last did VMRUN for the vCPU, and
last_vmentry_cpu is initialized to -1 during vCPU creation, i.e. is
guaranteed to mismatch on the first VMRUN.  However, prior to commit
8a14fe4f0c54 ("kvm: x86: Move last_cpu into kvm_vcpu_arch as
last_vmentry_cpu"), SVM tracked pCPU on its own and zero-initialized the
last_cpu variable.  Thus it's theoretically possible that older versions
of KVM could miss a TLB flush if the first VMRUN is on pCPU0 and the ASID
and VMCB exactly match those of a prior VM.

Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6710d9ee2e4b..4d0aba185412 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -189,7 +189,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 
 	for_each_possible_cpu(cpu) {
 		sd = per_cpu(svm_data, cpu);
-		sd->sev_vmcbs[pos] = NULL;
+		sd->sev_vmcbs[sev->asid] = NULL;
 	}
 
 	mutex_unlock(&sev_bitmap_lock);

