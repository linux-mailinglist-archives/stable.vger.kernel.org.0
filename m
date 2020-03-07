Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3414917CAB0
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 03:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCGCQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 21:16:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgCGCQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 21:16:32 -0500
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E32EA2067C;
        Sat,  7 Mar 2020 02:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583547392;
        bh=ZIV6z1lwkiwcQzPHzg5HwO+jQAtalo0Uf9NvrIMC3qw=;
        h=From:To:Cc:Subject:Date:From;
        b=m7uWRUdrjOTLRGmZ4uhPFL/Scr9zbtshS1wDjuGwg54H8+1QaeZN5+r+Yh/gV+coV
         qCrIlI0dfVXZ/ma9a/eJalmZQhazh+o/Z5MuBinffJQBH/GNBSgYAfqM01Iaekb3gO
         RtIUVeBjktTdEgO99gcevvp20QlHi7Y9pfzYIFjo=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Date:   Fri,  6 Mar 2020 18:16:27 -0800
Message-Id: <25d5c6de22cabf6a4ecb44ce077f33aa5f10b4d4.1583547371.git.luto@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ABI is broken and we cannot support it properly.  Turn it off.

If this causes a meaningful performance regression for someone, KVM
can introduce an improved ABI that is supportable.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/kernel/kvm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 93ab0cbd304e..71f9f39f93da 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -318,11 +318,16 @@ static void kvm_guest_cpu_init(void)
 
 		pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
 
-#ifdef CONFIG_PREEMPTION
-		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
-#endif
 		pa |= KVM_ASYNC_PF_ENABLED;
 
+		/*
+		 * We do not set KVM_ASYNC_PF_SEND_ALWAYS.  With the current
+		 * KVM paravirt ABI, if an async page fault occurs on an early
+		 * memory access in the normal (sync) #PF path or in an NMI
+		 * that happens early in the #PF code, the combination of CR2
+		 * and the APF reason field will be corrupted.
+		 */
+
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
 			pa |= KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
-- 
2.24.1

