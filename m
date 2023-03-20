Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401726C1931
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbjCTPbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbjCTPbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C8C1BF7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AAA4615AC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5E4C433EF;
        Mon, 20 Mar 2023 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325819;
        bh=itjs6iFZRt2JynM6LYNqrcpc5v86ZBjvB4BLoUlCYyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilTakTe+orBp9UwDyPs1WZtQIXZfe7ITE8rO9B5Ve04ahdKT41CjmPqJGje7HyCzv
         vnDsCDg3pshT4Y7raIZ18p3kWBwVAd5/GVNxAVuoP+iu7Be1foAS+hq6QAhYMyO2y3
         q6dlzNnMIkc5OhvtOU+Ypq7XKipLid9gY07e7d1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 148/198] KVM: SVM: Modify AVIC GATag to support max number of 512 vCPUs
Date:   Mon, 20 Mar 2023 15:54:46 +0100
Message-Id: <20230320145513.755489646@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit 5999715922c5a3ede5d8fe2a6b17aba58a157d41 upstream.

Define AVIC_VCPU_ID_MASK based on AVIC_PHYSICAL_MAX_INDEX, i.e. the mask
that effectively controls the largest guest physical APIC ID supported by
x2AVIC, instead of hardcoding the number of bits to 8 (and the number of
VM bits to 24).

The AVIC GATag is programmed into the AMD IOMMU IRTE to provide a
reference back to KVM in case the IOMMU cannot inject an interrupt into a
non-running vCPU.  In such a case, the IOMMU notifies software by creating
a GALog entry with the corresponded GATag, and KVM then uses the GATag to
find the correct VM+vCPU to kick.  Dropping bit 8 from the GATag results
in kicking the wrong vCPU when targeting vCPUs with x2APIC ID > 255.

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-Id: <20230207002156.521736-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ca684979e90d..326341a22153 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -27,19 +27,29 @@
 #include "irq.h"
 #include "svm.h"
 
-/* AVIC GATAG is encoded using VM and VCPU IDs */
-#define AVIC_VCPU_ID_BITS		8
-#define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
+/*
+ * Encode the arbitrary VM ID and the vCPU's default APIC ID, i.e the vCPU ID,
+ * into the GATag so that KVM can retrieve the correct vCPU from a GALog entry
+ * if an interrupt can't be delivered, e.g. because the vCPU isn't running.
+ *
+ * For the vCPU ID, use however many bits are currently allowed for the max
+ * guest physical APIC ID (limited by the size of the physical ID table), and
+ * use whatever bits remain to assign arbitrary AVIC IDs to VMs.  Note, the
+ * size of the GATag is defined by hardware (32 bits), but is an opaque value
+ * as far as hardware is concerned.
+ */
+#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
 
-#define AVIC_VM_ID_BITS			24
-#define AVIC_VM_ID_NR			(1 << AVIC_VM_ID_BITS)
-#define AVIC_VM_ID_MASK			((1 << AVIC_VM_ID_BITS) - 1)
+#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
+#define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
-#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
+#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
 						(y & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
+#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+static_assert(AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
+
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
 
-- 
2.40.0



