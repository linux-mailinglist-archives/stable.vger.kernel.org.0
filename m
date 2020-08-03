Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D223A531
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgHCMeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729528AbgHCMeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:34:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A629204EC;
        Mon,  3 Aug 2020 12:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458046;
        bh=N9pC0y8ia7HAFIP+qsQdo12QqCgv5yaYu1BWaAETZIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBkEkNAM1C0dCe0mg/bnCkopg/XjKlAxEvnoYpJRMZs/lVC/9ISs9VaqDOA8czmIF
         +RPKM5FCzIbOjqUTjrgzDV+K5m3SKQbOIJ74iqk0rvd5pkb6dn9zg2qmopM+Poe2aM
         0p8Sx08aXABp9vMb94xbfZ3P2tGUIwwT5ZWSU9yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/51] x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit
Date:   Mon,  3 Aug 2020 14:19:53 +0200
Message-Id: <20200803121849.869521189@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8c6de56a42e0c657955e12b882a81ef07d1d073e ]

kvm_steal_time_set_preempted() may accidentally clear KVM_VCPU_FLUSH_TLB
bit if it is called more than once while VCPU is preempted.

This is part of CVE-2019-3016.

(This bug was also independently discovered by Jim Mattson
<jmattson@google.com>)

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09f47c837c258..3aed03942d7d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3075,6 +3075,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
+	if (vcpu->arch.st.steal.preempted)
+		return;
+
 	vcpu->arch.st.steal.preempted = 1;
 
 	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,
-- 
2.25.1



