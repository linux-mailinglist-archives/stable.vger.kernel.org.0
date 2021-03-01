Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F54328A35
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239521AbhCASN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239271AbhCASIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C8EC64E62;
        Mon,  1 Mar 2021 17:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618834;
        bh=gvmHwS7ZOav2q26xzaIqniB1AvIo8l+wxzWzd5FCu90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/2adm8iqNVN2TvMWnUT8l0HJNzpng+GGsDTiffXBLMNro9Th1DoijYEPJS+VfRnE
         Ka+VF3N9VA/evCYKCKp01yppRgESwvEPB/eM5EpOewnrnbUl0dP4kW3B/Mp7kcSKze
         wna3gTCQPqp6OEpnqHiVmsT7O0ZPlH8OUPoP7L5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/663] KVM: x86: Restore all 64 bits of DR6 and DR7 during RSM on x86-64
Date:   Mon,  1 Mar 2021 17:07:55 +0100
Message-Id: <20210301161153.035114517@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2644312052d54e2e7543c7d186899a36ed22f0bf ]

Restore the full 64-bit values of DR6 and DR7 when emulating RSM on
x86-64, as defined by both Intel's SDM and AMD's APM.

Note, bits 63:32 of DR6 and DR7 are reserved, so this is a glorified nop
unless the SMM handler is poking into SMRAM, which it most definitely
shouldn't be doing since both Intel and AMD list the DR6 and DR7 fields
as read-only.

Fixes: 660a5d517aaa ("KVM: x86: save/load state on SMM switch")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210205012458.3872687-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 66a08322988f2..1453b9b794425 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2564,12 +2564,12 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);
 	ctxt->eflags = GET_SMSTATE(u32, smstate, 0x7f70) | X86_EFLAGS_FIXED;
 
-	val = GET_SMSTATE(u32, smstate, 0x7f68);
+	val = GET_SMSTATE(u64, smstate, 0x7f68);
 
 	if (ctxt->ops->set_dr(ctxt, 6, (val & DR6_VOLATILE) | DR6_FIXED_1))
 		return X86EMUL_UNHANDLEABLE;
 
-	val = GET_SMSTATE(u32, smstate, 0x7f60);
+	val = GET_SMSTATE(u64, smstate, 0x7f60);
 
 	if (ctxt->ops->set_dr(ctxt, 7, (val & DR7_VOLATILE) | DR7_FIXED_1))
 		return X86EMUL_UNHANDLEABLE;
-- 
2.27.0



