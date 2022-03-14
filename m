Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EA24D832D
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbiCNMMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242385AbiCNMJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:09:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD1A39F;
        Mon, 14 Mar 2022 05:07:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95BCEB80CDE;
        Mon, 14 Mar 2022 12:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDA2C340E9;
        Mon, 14 Mar 2022 12:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259664;
        bh=Y9KlIpkBRHEF52Fy9TTBs0ebsuplB+fl+zs/LguYyZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBBH+dOYRTDM9SX2ZZMvjDZ2aT31Ld1rz324LH/usCNnLmFXgJrZO1qhQYIPpvrCr
         AxOM7bY0X9rchjGL88pFk9tibh4Vdri1BvvWE3NrNr1DPL0LlxPukPuWmjg1uJXnh/
         i0dp4jIj99mL7vD6iUc3mBHs9ahqnhkbPyr5bpaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/110] x86/kvm: Dont use pv tlb/ipi/sched_yield if on 1 vCPU
Date:   Mon, 14 Mar 2022 12:54:03 +0100
Message-Id: <20220314112744.738007397@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit ec756e40e271866f951d77c5e923d8deb6002b15 ]

Inspired by commit 3553ae5690a (x86/kvm: Don't use pvqspinlock code if
only 1 vCPU), on a VM with only 1 vCPU, there is no need to enable
pv tlb/ipi/sched_yield and we can save the memory for __pv_cpu_mask.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1645171838-2855-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kvm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b656456c3a94..811c7aaf23aa 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -457,19 +457,22 @@ static bool pv_tlb_flush_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+		(num_possible_cpus() != 1));
 }
 
 static bool pv_ipi_supported(void)
 {
-	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
+	return (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI) &&
+	       (num_possible_cpus() != 1));
 }
 
 static bool pv_sched_yield_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+	    (num_possible_cpus() != 1));
 }
 
 #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)
-- 
2.34.1



