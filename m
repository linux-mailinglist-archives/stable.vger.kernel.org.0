Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB8F33BC47
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhCOOYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238165AbhCOOWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB8664F3D;
        Mon, 15 Mar 2021 14:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818170;
        bh=R0A7ux4q9rI+P//xXJuvW1EVSmliCrIjELO0X67Qu+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pt6fUFeQgU6zPDMaiEOwZ3VTQy7bMMu3t4/CYY4qqoDlo5kD4mTkQzss7583P4Gl3
         8Ml41TEEJ9GBxNcc0QTJfoj56z4Kt7Bm/DjPn6CLkfByhyUy0q9xb2SV4UghF3M14d
         t0MvHyO/kFtZt+9/0+FxpXxLr0NECwM1TVGd/3fU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Andrew Scull <ascull@google.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 279/290] KVM: arm64: Avoid corrupting vCPU context register in guest exit
Date:   Mon, 15 Mar 2021 15:22:29 +0100
Message-Id: <20210315135551.461936430@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135551.391322899@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135551.391322899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Will Deacon <will@kernel.org>

commit 31948332d5fa392ad933f4a6a10026850649ed76 upstream.

Commit 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest
context") tracks the currently running vCPU, clearing the pointer to
NULL on exit from a guest.

Unfortunately, the use of 'set_loaded_vcpu' clobbers x1 to point at the
kvm_hyp_ctxt instead of the vCPU context, causing the subsequent RAS
code to go off into the weeds when it saves the DISR assuming that the
CPU context is embedded in a struct vCPU.

Leave x1 alone and use x3 as a temporary register instead when clearing
the vCPU on the guest exit path.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Andrew Scull <ascull@google.com>
Cc: <stable@vger.kernel.org>
Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest context")
Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210226181211.14542-1-will@kernel.org
Message-Id: <20210305185254.3730990-3-maz@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -146,7 +146,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOB
 	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
-	set_loaded_vcpu xzr, x1, x2
+	set_loaded_vcpu xzr, x2, x3
 
 alternative_if ARM64_HAS_RAS_EXTN
 	// If we have the RAS extensions we can consume a pending error


