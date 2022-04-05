Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25454F39AD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357844AbiDELhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353858AbiDEKJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:09:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A484C3376;
        Tue,  5 Apr 2022 02:55:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2707461500;
        Tue,  5 Apr 2022 09:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352E5C385A2;
        Tue,  5 Apr 2022 09:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152539;
        bh=uwEM9yJd8yQV8YVnMIu1YlcaI8etPYsnFYaOdz+jFvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCPuPesTFA/W36H3rMeUmsFtTyD7JiUMTGnrAlqRpY7If7eX4zzu9AUs20UX9ZbGK
         tjhTgE6WBeo7lS2gDpLHU1tGGOXsse2uIq/hUEgS6G1hbmGEV34FZkFqbIobU0G6i9
         1UhHbNRUp0GY7DcYpU8V6mujDB8D1O6S6xclTowk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 812/913] KVM: x86: Forbid VMM to set SYNIC/STIMER MSRs when SynIC wasnt activated
Date:   Tue,  5 Apr 2022 09:31:14 +0200
Message-Id: <20220405070404.171468399@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -236,7 +236,7 @@ static int synic_set_msr(struct kvm_vcpu
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	int ret;
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || data))
 		return 1;
 
 	trace_kvm_hv_synic_set_msr(vcpu->vcpu_id, msr, data, host);
@@ -282,6 +282,9 @@ static int synic_set_msr(struct kvm_vcpu
 	case HV_X64_MSR_EOM: {
 		int i;
 
+		if (!synic->active)
+			break;
+
 		for (i = 0; i < ARRAY_SIZE(synic->sint); i++)
 			kvm_hv_notify_acked_sint(vcpu, i);
 		break;
@@ -661,7 +664,7 @@ static int stimer_set_config(struct kvm_
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || config))
 		return 1;
 
 	if (unlikely(!host && hv_vcpu->enforce_cpuid && new_config.direct_mode &&
@@ -690,7 +693,7 @@ static int stimer_set_count(struct kvm_v
 	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
-	if (!synic->active && !host)
+	if (!synic->active && (!host || count))
 		return 1;
 
 	trace_kvm_hv_stimer_set_count(hv_stimer_to_vcpu(stimer)->vcpu_id,


