Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEDD6E640A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbjDRMpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjDRMph (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB11A14F49
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 557246338A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651CEC433D2;
        Tue, 18 Apr 2023 12:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821934;
        bh=45TR7h11OXZLgsrqC2lRbf1QhDSEalskq339Wvvwnh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+437bw2mC+dOieTlPGpmDppwHkBkekLnPi6tt41X5v7r+A88oWPWTheUoZX4G2UD
         c3WzGnDRy3qUBuioF7ECN8bd343KTo5h1jRfpWxbrqjyX+dsRLx7ioBj8sp9lEiW7j
         W3Keg7V+mWqVFvqXrVaLUoKy6j5tqLEh5nTYvPWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/134] KVM: selftests: Move "struct hv_enlightenments" to x86_64/svm.h
Date:   Tue, 18 Apr 2023 14:22:31 +0200
Message-Id: <20230418120316.495243176@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 381fc63ac0754e05d3921e9d399b89dfdfd2b2e5 ]

Move Hyper-V's VMCB "struct hv_enlightenments" to the svm.h header so
that the struct can be referenced in "struct vmcb_control_area".
Alternatively, a dedicated header for SVM+Hyper-V could be added, a la
x86_64/evmcs.h, but it doesn't appear that Hyper-V will end up needing
a wholesale replacement for the VMCB.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20221101145426.251680-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e5c972c1fada ("KVM: SVM: Flush Hyper-V TLB when required")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/kvm/include/x86_64/svm.h | 17 +++++++++++++++++
 .../selftests/kvm/x86_64/hyperv_svm_test.c     | 18 ------------------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
index c8343ff84f7f7..89ce2c6b57fe0 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -58,6 +58,23 @@ enum {
 	INTERCEPT_RDPRU,
 };
 
+struct hv_enlightenments {
+	struct __packed hv_enlightenments_control {
+		u32 nested_flush_hypercall:1;
+		u32 msr_bitmap:1;
+		u32 enlightened_npt_tlb: 1;
+		u32 reserved:29;
+	} __packed hv_enlightenments_control;
+	u32 hv_vp_id;
+	u64 hv_vm_id;
+	u64 partition_assist_page;
+	u64 reserved;
+} __packed;
+
+/*
+ * Hyper-V uses the software reserved clean bit in VMCB
+ */
+#define HV_VMCB_NESTED_ENLIGHTENMENTS (1U << 31)
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercept_cr;
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 5060fcfe17601..2fd64b419928a 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -23,24 +23,6 @@
 
 #define L2_GUEST_STACK_SIZE 256
 
-struct hv_enlightenments {
-	struct __packed hv_enlightenments_control {
-		u32 nested_flush_hypercall:1;
-		u32 msr_bitmap:1;
-		u32 enlightened_npt_tlb: 1;
-		u32 reserved:29;
-	} __packed hv_enlightenments_control;
-	u32 hv_vp_id;
-	u64 hv_vm_id;
-	u64 partition_assist_page;
-	u64 reserved;
-} __packed;
-
-/*
- * Hyper-V uses the software reserved clean bit in VMCB
- */
-#define HV_VMCB_NESTED_ENLIGHTENMENTS (1U << 31)
-
 void l2_guest_code(void)
 {
 	GUEST_SYNC(3);
-- 
2.39.2



