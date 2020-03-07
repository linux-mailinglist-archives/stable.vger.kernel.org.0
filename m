Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0976E17CABF
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 03:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCGC0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 21:26:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgCGC0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 21:26:46 -0500
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E16F206D7;
        Sat,  7 Mar 2020 02:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583548005;
        bh=WarD3A6TIXCvkh+npVTJxWlJCe2Sm4j29KWN/2pPhhs=;
        h=From:To:Cc:Subject:Date:From;
        b=DiSG3DrXPw/2Hmyg25twSuLwoqauursyOSyV1GXzwE4VozYSRkfcKMFCBZmtB+DuZ
         0adtWc+A1yF2nvqvsJCzfaescMRw5SEURNmEi3DotQWHn/bSF4sq9h4dfrwMSG22Sc
         IcN6/3NDPR/obHD63od1YtxF0qTzOkv8TT/4xlvQ=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Date:   Fri,  6 Mar 2020 18:26:42 -0800
Message-Id: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org>
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
 arch/x86/kernel/kvm.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 93ab0cbd304e..e6f2aefa298b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -318,11 +318,26 @@ static void kvm_guest_cpu_init(void)
 
 		pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
 
-#ifdef CONFIG_PREEMPTION
-		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
-#endif
 		pa |= KVM_ASYNC_PF_ENABLED;
 
+		/*
+		 * We do not set KVM_ASYNC_PF_SEND_ALWAYS.  With the current
+		 * KVM paravirt ABI, the following scenario is possible:
+		 *
+		 * #PF: async page fault (KVM_PV_REASON_PAGE_NOT_PRESENT)
+		 *  NMI before CR2 or KVM_PF_REASON_PAGE_NOT_PRESENT
+		 *   NMI accesses user memory, e.g. due to perf
+		 *    #PF: normal page fault
+		 *     #PF reads CR2 and apf_reason -- apf_reason should be 0
+		 *
+		 *  outer #PF reads CR2 and apf_reason -- apf_reason should be
+		 *  KVM_PV_REASON_PAGE_NOT_PRESENT
+		 *
+		 * There is no possible way that both reads of CR2 and
+		 * apf_reason get the correct values.  Fixing this would
+		 * require paravirt ABI changes.
+		 */
+
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
 			pa |= KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
-- 
2.24.1

