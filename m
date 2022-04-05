Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB064F2A67
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353761AbiDEKJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345465AbiDEJWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A484B1F7;
        Tue,  5 Apr 2022 02:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47B9AB818F3;
        Tue,  5 Apr 2022 09:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83088C385A0;
        Tue,  5 Apr 2022 09:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149857;
        bh=i6ekhz8yvn0w0xbt01pqAW4L3Qfv2grJOD45n0DZ3D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUHam74465FdvGZRizgQkDgG93nCQmtYvnp5Mdj30TZ58JjK3OS95JTVWhoyA5v0g
         bsj+U2Nnvx3ORUPhU8IlOlpmVEWFmENr/fc8gslC1KKf2y29P8cq3g6+r09xAJUW42
         +u4+P5B+g19tloAMUCLO27i+JCnOqu7+sroCGTZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 0865/1017] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
Date:   Tue,  5 Apr 2022 09:29:38 +0200
Message-Id: <20220405070419.911625128@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 47d3e5cdfe607ec6883eb0faa7acf05b8cb3f92a upstream.

It has been proven on practice that at least Windows Server 2019 tries
using HVCALL_SEND_IPI_EX in 'XMM fast' mode when it has more than 64 vCPUs
and it needs to send an IPI to a vCPU > 63. Similarly to other XMM Fast
hypercalls (HVCALL_FLUSH_VIRTUAL_ADDRESS_{LIST,SPACE}{,_EX}), this
information is missing in TLFS as of 6.0b. Currently, KVM returns an error
(HV_STATUS_INVALID_HYPERCALL_INPUT) and Windows crashes.

Note, HVCALL_SEND_IPI is a 'standard' fast hypercall (not 'XMM fast') as
all its parameters fit into RDX:R8 and this is handled by KVM correctly.

Cc: stable@vger.kernel.org # 5.14.x: 3244867af8c0: KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req
Cc: stable@vger.kernel.org # 5.14.x
Fixes: d8f5537a8816 ("KVM: hyper-v: Advertise support for fast XMM hypercalls")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220222154642.684285-5-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |   52 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 18 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1889,6 +1889,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vc
 	int sparse_banks_len;
 	u32 vector;
 	bool all_cpus;
+	int i;
 
 	if (hc->code == HVCALL_SEND_IPI) {
 		if (!hc->fast) {
@@ -1909,9 +1910,15 @@ static u64 kvm_hv_send_ipi(struct kvm_vc
 
 		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
 	} else {
-		if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
-					    sizeof(send_ipi_ex))))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (!hc->fast) {
+			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
+						    sizeof(send_ipi_ex))))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		} else {
+			send_ipi_ex.vector = (u32)hc->ingpa;
+			send_ipi_ex.vp_set.format = hc->outgpa;
+			send_ipi_ex.vp_set.valid_bank_mask = sse128_lo(hc->xmm[0]);
+		}
 
 		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
 					 send_ipi_ex.vp_set.format,
@@ -1919,8 +1926,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vc
 
 		vector = send_ipi_ex.vector;
 		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
-		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64) *
-			sizeof(sparse_banks[0]);
+		sparse_banks_len = bitmap_weight(&valid_bank_mask, 64);
 
 		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
 
@@ -1930,12 +1936,27 @@ static u64 kvm_hv_send_ipi(struct kvm_vc
 		if (!sparse_banks_len)
 			goto ret_success;
 
-		if (kvm_read_guest(kvm,
-				   hc->ingpa + offsetof(struct hv_send_ipi_ex,
-							vp_set.bank_contents),
-				   sparse_banks,
-				   sparse_banks_len))
-			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		if (!hc->fast) {
+			if (kvm_read_guest(kvm,
+					   hc->ingpa + offsetof(struct hv_send_ipi_ex,
+								vp_set.bank_contents),
+					   sparse_banks,
+					   sparse_banks_len * sizeof(sparse_banks[0])))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		} else {
+			/*
+			 * The lower half of XMM0 is already consumed, each XMM holds
+			 * two sparse banks.
+			 */
+			if (sparse_banks_len > (2 * HV_HYPERCALL_MAX_XMM_REGISTERS - 1))
+				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+			for (i = 0; i < sparse_banks_len; i++) {
+				if (i % 2)
+					sparse_banks[i] = sse128_lo(hc->xmm[(i + 1) / 2]);
+				else
+					sparse_banks[i] = sse128_hi(hc->xmm[i / 2]);
+			}
+		}
 	}
 
 check_and_send_ipi:
@@ -2097,6 +2118,7 @@ static bool is_xmm_fast_hypercall(struct
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
 	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
+	case HVCALL_SEND_IPI_EX:
 		return true;
 	}
 
@@ -2264,14 +2286,8 @@ int kvm_hv_hypercall(struct kvm_vcpu *vc
 		ret = kvm_hv_flush_tlb(vcpu, &hc);
 		break;
 	case HVCALL_SEND_IPI:
-		if (unlikely(hc.rep)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_send_ipi(vcpu, &hc);
-		break;
 	case HVCALL_SEND_IPI_EX:
-		if (unlikely(hc.fast || hc.rep)) {
+		if (unlikely(hc.rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}


