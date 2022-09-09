Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50975B3EA6
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 20:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiIISOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 14:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiIISOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 14:14:21 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D715E5834
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 11:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662747259; x=1694283259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gMuDDfCUmqYcJCT4kSblyTa1PE5mR8p1E7LTS0IsYMY=;
  b=FZRRj7pTxQGq4NlDgE1t6oAn0b3xK/xB3ovuBfVIQBurHV4Tb3PxfpWK
   vo/YSowif5GteJ4SvwMooViJUiq42LX75nfAnCNpoD3qJxGwCsJ6hPhhf
   qj/zBkgkeaKY5ofDBabfNsvyhoB9ZmxKpozd4ymCwRq6RzpT5I1LJITwm
   s=;
X-IronPort-AV: E=Sophos;i="5.93,303,1654560000"; 
   d="scan'208";a="128504172"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 18:14:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com (Postfix) with ESMTPS id 31D3D4522E;
        Fri,  9 Sep 2022 18:14:17 +0000 (UTC)
Received: from EX19D012UWB002.ant.amazon.com (10.13.138.53) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 9 Sep 2022 18:14:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX19D012UWB002.ant.amazon.com (10.13.138.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Fri, 9 Sep 2022 18:14:16 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Fri, 9 Sep 2022 18:14:16 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 1248758D7; Fri,  9 Sep 2022 18:14:15 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <surajjs@amazon.com>,
        <mbacco@amazon.com>, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 1/9] KVM: x86: Ensure PV TLB flush tracepoint reflects KVM behavior
Date:   Fri, 9 Sep 2022 18:13:43 +0000
Message-ID: <20220909181351.23983-2-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220909181351.23983-1-risbhat@amazon.com>
References: <20220909181351.23983-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit af3511ff7fa2107d6410831f3d71030f5e8d2b25 upstream.

In record_steal_time(), st->preempted is read twice, and
trace_kvm_pv_tlb_flush() might output result inconsistent if
kvm_vcpu_flush_tlb_guest() see a different st->preempted later.

It is a very trivial problem and hardly has actual harm and can be
avoided by reseting and reading st->preempted in atomic way via xchg().

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>

Message-Id: <20210531174628.10265-1-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5a08ec348e6..3640b298c42e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3032,9 +3032,11 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	 * expensive IPIs.
 	 */
 	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
+		u8 st_preempted = xchg(&st->preempted, 0);
+
 		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
-				       st->preempted & KVM_VCPU_FLUSH_TLB);
-		if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
+				       st_preempted & KVM_VCPU_FLUSH_TLB);
+		if (st_preempted & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
 	} else {
 		st->preempted = 0;
-- 
2.37.1

