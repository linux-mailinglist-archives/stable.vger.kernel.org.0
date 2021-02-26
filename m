Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9D73266C2
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 19:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBZSNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 13:13:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhBZSNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 13:13:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7B7B64E85;
        Fri, 26 Feb 2021 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614363173;
        bh=nAk4WrgY8B1ZZvvFfv8YJ7MnbT4maSdfShrZmvw4D64=;
        h=From:To:Cc:Subject:Date:From;
        b=oRVWGsLXznLVXC6SDWZGUxWKLSP5iTK6CsaJ6BXqEDc/NllJ8K40KI/TxRQPsinkB
         3+JjvMXwYe5xM4nRSRWg92AmWm6FkR0+QPL2cg1ehaH8LO+Dj6wBBh2NnGuTMXQHC/
         6+MJJJUtJlKOsnwgcW1TqZ5EUg6n4PfpmJzMTkhiibEoxkK81AC38RSDSpwzAoHk3m
         aNWV4oY0kKviXBM1bFZMclEl1ZkvB81TLxFmmkIVjZGVg65UOOXyNkE/JlciG9/iRX
         2b8PB8XAbpGkod0dKqAlwP5tHrnaJjQpZBLA5OL2aJjM2B58Wc+Woxwu8g7wBf5ksk
         IKha1ce9e8GVQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, maz@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Andrew Scull <ascull@google.com>, stable@vger.kernel.org,
        Quentin Perret <qperret@google.com>
Subject: [PATCH] KVM: arm64: Avoid corrupting vCPU context register in guest exit
Date:   Fri, 26 Feb 2021 18:12:11 +0000
Message-Id: <20210226181211.14542-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

This was pretty awful to debug!

 arch/arm64/kvm/hyp/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index b0afad7a99c6..0c66a1d408fd 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -146,7 +146,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
-	set_loaded_vcpu xzr, x1, x2
+	set_loaded_vcpu xzr, x2, x3
 
 alternative_if ARM64_HAS_RAS_EXTN
 	// If we have the RAS extensions we can consume a pending error
-- 
2.30.1.766.gb4fecdf3b7-goog

