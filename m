Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB8B29B647
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797251AbgJ0PW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797241AbgJ0PWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:22:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 218232064B;
        Tue, 27 Oct 2020 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812143;
        bh=7xT6aAxzOBLkpA2SaahT+QLhtQ+3akzwiY9gddM3Qho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFyieVV9RSyc9xEHvgJtw73jwpaeYM0sp99SVS4H26eBM9scQpAMoacaJwoNR4AQ2
         N4aaKXNz8xqOoB5fBSf/EUDo098zgVVgIdZ3GVOQQKMWp87sD1uj9SPN24UwR+mJsV
         RwykExx85nO+257OxQy2H4Xsvjz+EQMqtKpl1ZTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.9 076/757] KVM: x86/mmu: Commit zap of remaining invalid pages when recovering lpages
Date:   Tue, 27 Oct 2020 14:45:26 +0100
Message-Id: <20201027135454.103297549@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit e89505698c9f70125651060547da4ff5046124fc upstream.

Call kvm_mmu_commit_zap_page() after exiting the "prepare zap" loop in
kvm_recover_nx_lpages() to finish zapping pages in the unlikely event
that the loop exited due to lpage_disallowed_mmu_pages being empty.
Because the recovery thread drops mmu_lock() when rescheduling, it's
possible that lpage_disallowed_mmu_pages could be emptied by a different
thread without to_zap reaching zero despite to_zap being derived from
the number of disallowed lpages.

Fixes: 1aa9b9572b105 ("kvm: x86: mmu: Recovery of shattered NX large pages")
Cc: Junaid Shahid <junaids@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200923183735.584-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6376,6 +6376,7 @@ static void kvm_recover_nx_lpages(struct
 				cond_resched_lock(&kvm->mmu_lock);
 		}
 	}
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);


