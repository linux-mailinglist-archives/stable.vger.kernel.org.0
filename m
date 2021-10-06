Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF20423C4E
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbhJFLOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238357AbhJFLOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 07:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B92BE61184;
        Wed,  6 Oct 2021 11:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633518763;
        bh=iDuXUh8Sqb2SmjrONaN8Y8dFcYOdWd+BO/L8fjufths=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZl93efSh2uRb31uJl1Q58/f7lnAT2MSzaEUHZLt6fMV0y4vUDTrlJIoyDV+d9GJ/
         ypARpgkHQGLKB538fW5YXGJK65NDT7YB/c20Qtlp+EAqx5Uvq0CB4pyxcTIGo51V3y
         +yz3HuvixIDeLBDSBwsW1dDs1/N/HA21KArgI7afXvxalUdHHigpP7m6nerlbq99mi
         XHWBS7GpkArAqet1xLIPHcyi5/26g1YxmT/n/UUyob0qgFZUnczOYqjCSEKgz02wnA
         wbRYkn14aqxoFY/z4Dr08c3EsGCYZSfD2LswTBmtF0MGOjVwPcxjPn2jtA3GWhLEQ3
         dnn/WePYNyCeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 6/7] KVM: x86: nSVM: restore int_vector in svm_clear_vintr
Date:   Wed,  6 Oct 2021 07:12:32 -0400
Message-Id: <20211006111234.264020-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006111234.264020-1-sashal@kernel.org>
References: <20211006111234.264020-1-sashal@kernel.org>
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
index 1c23aee3778c..5e1d7396a6b8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1497,6 +1497,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 			(svm->nested.ctl.int_ctl & V_TPR_MASK));
 		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
 			V_IRQ_INJECTION_BITS_MASK;
+
+		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
-- 
2.33.0

