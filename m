Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C045D423F45
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238943AbhJFNc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238892AbhJFNcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 09:32:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A5260E9C;
        Wed,  6 Oct 2021 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633527033;
        bh=HvnztjarHSn+a6mS+GbFME7OEatQUSnVwZdZm6XrE2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUzpr3g89CeK2rY0F+q905VMlBGRk3YIiJ8JcCq+AaQTahV3Vx2t4gPxQ5T2pKiIy
         /JlVWh6kMzsID2uyAbsAiZ94QcGY2nPBgn9IEB32ooqRFn13ASADlLd25LwcCaioKQ
         ckxRbOmVJucXFtlIWw/lRVpfFbawAuLYP2Wo3mzS5ovLLnLwzIVeMwW0uAi2opd5mN
         YyDxGj84Wv021JUAdALu9paV6VkTVGltHuD6p37TlrXFqLdO5yTC5kH2B0a3xWgpF4
         nEiT4BKTbg+NNjUYQNpnar24aHcmtOazLIu9gMNRLzpQF3mzXNq88TH3XrUZIve301
         p0DMdc89Y4KxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.14 8/9] KVM: x86: nSVM: restore int_vector in svm_clear_vintr
Date:   Wed,  6 Oct 2021 09:30:20 -0400
Message-Id: <20211006133021.271905-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006133021.271905-1-sashal@kernel.org>
References: <20211006133021.271905-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit aee77e1169c1900fe4248dc186962e745b479d9e ]

In svm_clear_vintr we try to restore the virtual interrupt
injection that might be pending, but we fail to restore
the interrupt vector.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210914154825.104886-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 69639f9624f5..19d6ffdd3f73 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1601,6 +1601,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 
 		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
 			V_IRQ_INJECTION_BITS_MASK;
+
+		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
-- 
2.33.0

