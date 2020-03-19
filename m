Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0074318B528
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgCSNQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729497AbgCSNQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76BC1216FD;
        Thu, 19 Mar 2020 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623766;
        bh=F3E9u0e+OhzeM2fhFFj712/muRznLLR9TG6SMNd/BoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOoydtuBAPkzazbaQd0SxeZfgKUHeHJCQO/dorzOe5MHDgVTWDVdR88/aIsa8RAl+
         ub7Vx7cqrVd0NSTWPD/VUGdp8FPW+GEk9MX23NJwTP5+/E26k6izdA1X+eNEmvO2Hr
         T310BST6ptiKVxyR6SQVgzww7PupwXG8HZ6Y2W2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 4.14 47/99] KVM: x86: clear stale x86_emulate_ctxt->intercept value
Date:   Thu, 19 Mar 2020 14:03:25 +0100
Message-Id: <20200319123956.144975540@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 342993f96ab24d5864ab1216f46c0b199c2baf8e upstream.

After commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest
mode") Hyper-V guests on KVM stopped booting with:

 kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181
    info2 0 int_info 0 int_info_err 0
 kvm_page_fault:       address febd0000 error_code 181
 kvm_emulate_insn:     0:fffff802987d6169: f3 a5
 kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
 kvm_inj_exception:    #UD (0x0)

"f3 a5" is a "rep movsw" instruction, which should not be intercepted
at all.  Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
init_decode_cache") reduced the number of fields cleared by
init_decode_cache() claiming that they are being cleared elsewhere,
'intercept', however, is left uncleared if the instruction does not have
any of the "slow path" flags (NotImpl, Stack, Op3264, Sse, Mmx, CheckPerm,
NearBranch, No16 and of course Intercept itself).

Fixes: c44b4c6ab80e ("KVM: emulate: clean up initializations in init_decode_cache")
Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5062,6 +5062,7 @@ int x86_decode_insn(struct x86_emulate_c
 	ctxt->fetch.ptr = ctxt->fetch.data;
 	ctxt->fetch.end = ctxt->fetch.data + insn_len;
 	ctxt->opcode_len = 1;
+	ctxt->intercept = x86_intercept_none;
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
 	else {


