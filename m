Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2267C4F3E91
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383236AbiDEMZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348215AbiDEKqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:46:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D6436163;
        Tue,  5 Apr 2022 03:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E08456142E;
        Tue,  5 Apr 2022 10:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED22DC385A0;
        Tue,  5 Apr 2022 10:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154418;
        bh=y84qgXsxoEUAikPwoR4Mbefb/6Lca7pkYMZB4UujyCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vL9ZEHV+hMWsLeRsr+yzJtY3SrfZlmF7HO9cEkPNEwdsqzilRQsmVTDmg6a2xA++z
         O+fNFjdkRmYJjuISgRMgnpFK8m+HfcrvIPkDzcRZubdy/2CJZXhZca43DkrIJ2sAZF
         JxtqPUzWSPsu7EF6pClsXlZqTIMukocu4ighCwXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 533/599] KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasnt activated
Date:   Tue,  5 Apr 2022 09:33:47 +0200
Message-Id: <20220405070314.702100323@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

commit b1e34d325397a33d97d845e312d7cf2a8b646b44 upstream.

Setting non-zero values to SYNIC/STIMER MSRs activates certain features,
this should not happen when KVM_CAP_HYPERV_SYNIC{,2} was not activated.

Note, it would've been better to forbid writing anything to SYNIC/STIMER
MSRs, including zeroes, however, at least QEMU tries clearing
HV_X64_MSR_STIMER0_CONFIG without SynIC. HV_X64_MSR_EOM MSR is somewhat
'special' as writing zero there triggers an action, this also should not
happen when SynIC wasn't activated.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220325132140.25650-4-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -207,7 +207,7 @@ static int synic_set_msr(struct kvm_vcpu
 	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
 	int ret;
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || data))
 		return 1;
 
 	trace_kvm_hv_synic_set_msr(vcpu->vcpu_id, msr, data, host);
@@ -253,6 +253,9 @@ static int synic_set_msr(struct kvm_vcpu
 	case HV_X64_MSR_EOM: {
 		int i;
 
+		if (!synic->active)
+			break;
+
 		for (i = 0; i < ARRAY_SIZE(synic->sint); i++)
 			kvm_hv_notify_acked_sint(vcpu, i);
 		break;
@@ -636,7 +639,7 @@ static int stimer_set_config(struct kvm_
 	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || config))
 		return 1;
 
 	trace_kvm_hv_stimer_set_config(stimer_to_vcpu(stimer)->vcpu_id,
@@ -660,7 +663,7 @@ static int stimer_set_count(struct kvm_v
 	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || count))
 		return 1;
 
 	trace_kvm_hv_stimer_set_count(stimer_to_vcpu(stimer)->vcpu_id,


