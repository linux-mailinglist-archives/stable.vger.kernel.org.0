Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4270715757B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgBJMlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729945AbgBJMlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:16 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB0CE2051A;
        Mon, 10 Feb 2020 12:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338476;
        bh=mc6P79plUE2+NT5yHFbooruDYKFyGwJIhlDwTDoVieI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtNin9NdfoTPCiHdblTOpE3c1QiF54WQHoyRfyBCFv2YHVYSqsTxnFmPT9fzAgEEh
         qzuHGfyE8lSeIWvA3dVyO0roJPV/nRGKH6zBO+g7DBoKMJcV7pemWNlJPE7VsSGohP
         ICUHhDLIiJlSWDQy3lWrtR4xnS69iewU/wUiUbwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 244/367] x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit
Date:   Mon, 10 Feb 2020 04:32:37 -0800
Message-Id: <20200210122446.704452861@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit 8c6de56a42e0c657955e12b882a81ef07d1d073e upstream.

kvm_steal_time_set_preempted() may accidentally clear KVM_VCPU_FLUSH_TLB
bit if it is called more than once while VCPU is preempted.

This is part of CVE-2019-3016.

(This bug was also independently discovered by Jim Mattson
<jmattson@google.com>)

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3514,6 +3514,9 @@ static void kvm_steal_time_set_preempted
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
+	if (vcpu->arch.st.steal.preempted)
+		return;
+
 	vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,


