Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1FB499A5F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445320AbiAXVng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:43:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45328 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454428AbiAXVci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A1B0B80CCF;
        Mon, 24 Jan 2022 21:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AD8C340E4;
        Mon, 24 Jan 2022 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059956;
        bh=UMz2txwKo30Dyf7QnStl7t4dAxLp9RmLZ4ZsAfzY8d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BW+JJHWkvjjwrIo9qMOMbmthLsfS//AexhoedBtm+KjWIjhhclNM4BCG/0cnzjVEp
         Gabisi7o3EoDcHEm3VVYWkphj3hwvXfcP30EbblGvM/ODe28IqUp2TsWNP9Q0Oj90L
         8EdahUkErKbbnufRsU9Jhho7nJusLc6PPTaFnxn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0790/1039] KVM: VMX: Read Posted Interrupt "control" exactly once per loop iteration
Date:   Mon, 24 Jan 2022 19:42:59 +0100
Message-Id: <20220124184151.851685870@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit cfb0e1306a3790eb055ebf7cdb7b0ee8a23e9b6e ]

Use READ_ONCE() when loading the posted interrupt descriptor control
field to ensure "old" and "new" have the same base value.  If the
compiler emits separate loads, and loads into "new" before "old", KVM
could theoretically drop the ON bit if it were set between the loads.

Fixes: 28b835d60fcc ("KVM: Update Posted-Interrupts Descriptor when vCPU is preempted")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211009021236.4122790-27-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/posted_intr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 696ad48ab5daa..46fb83d6a286e 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -51,7 +51,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* The full case.  */
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		dest = cpu_physical_id(cpu);
 
@@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	unsigned int dest;
 
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 		WARN(old.nv != POSTED_INTR_WAKEUP_VECTOR,
 		     "Wakeup handler not enabled while the VCPU is blocked\n");
 
@@ -163,7 +163,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	}
 
 	do {
-		old.control = new.control = pi_desc->control;
+		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		WARN((pi_desc->sn == 1),
 		     "Warning: SN field of posted-interrupts "
-- 
2.34.1



