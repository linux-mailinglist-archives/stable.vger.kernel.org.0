Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7EB218B3FC
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbgCSNFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbgCSNFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:05:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5F120767;
        Thu, 19 Mar 2020 13:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623151;
        bh=adMMLGcqvitOlb6WSgYu/9d69wcN8CQ7NT+4lcaczpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9HNDqFSZHS7YCd8BGUw0RgvQ6Amln4okMeW5hgx5uGjsIIQlCagcDM4lUU8oLRVW
         v2fbAOJv0NsK2HNlnITkqEpTGFEA9RsA3j/mNjGUph/YzRB+ayKc8tCTO0DgHbbE3X
         jUrv1iIs5TJmsLeaxo85dGGWzofBMlkCFvGNoUMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 4.4 25/93] KVM: x86: clear stale x86_emulate_ctxt->intercept value
Date:   Thu, 19 Mar 2020 13:59:29 +0100
Message-Id: <20200319123933.022825570@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
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
@@ -5010,6 +5010,7 @@ int x86_decode_insn(struct x86_emulate_c
 	ctxt->fetch.ptr = ctxt->fetch.data;
 	ctxt->fetch.end = ctxt->fetch.data + insn_len;
 	ctxt->opcode_len = 1;
+	ctxt->intercept = x86_intercept_none;
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
 	else {


