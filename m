Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4BB472EB8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhLMOUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238840AbhLMOUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF886C06173F;
        Mon, 13 Dec 2021 06:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 739AAB8106C;
        Mon, 13 Dec 2021 14:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18686C34603;
        Mon, 13 Dec 2021 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405203;
        bh=udf/eWOWfR5Kj1n2cH9DJeIszizctsQGc34nEWJhCnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iky34ncoTIk+KQXo8cH415t163fVYF64iYFVlgYQkzWNCi6VaVsfmMNBg9FW80qHm
         8mgL9DxktaJhNlIHaJmEdkEhRAdnv+LOHFrEw6lZUouxxcpFwJPJW476OTS2cFRY+U
         LdGYcUgyOxhVhuw3An96LA6c1YnZM6N2Bw7NlspjVMqlrY9cYuGQRNaOatA5qNBn+Q
         qXidwNpGJLCZYfBH9SRfB/5Lar2Ab0r0lVG1kEal14Nu4TkrFhYhK+cZk04D/+y3Ry
         0RhZ9fyYjOXkM339vkSesO5Y1LB5V6xMNU/vX10ggu3t3x6mvlG1dfE5rIJGZNRuXU
         xWs0XbqcmIxBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 4/9] KVM: SEV: do not take kvm->lock when destroying
Date:   Mon, 13 Dec 2021 09:19:37 -0500
Message-Id: <20211213141944.352249-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213141944.352249-1-sashal@kernel.org>
References: <20211213141944.352249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 10a37929efeb4c51a0069afdd537c4fa3831f6e5 ]

Taking the lock is useless since there are no other references,
and there are already accesses (e.g. to sev->enc_context_owner)
that do not take it.  So get rid of it.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211123005036.2954379-12-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 134c4ea5e6ad8..ae8092f0d401e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1842,8 +1842,6 @@ void sev_vm_destroy(struct kvm *kvm)
 		return;
 	}
 
-	mutex_lock(&kvm->lock);
-
 	/*
 	 * Ensure that all guest tagged cache entries are flushed before
 	 * releasing the pages back to the system for use. CLFLUSH will
@@ -1863,8 +1861,6 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
-	mutex_unlock(&kvm->lock);
-
 	sev_unbind_asid(kvm, sev->handle);
 	sev_asid_free(sev);
 }
-- 
2.33.0

