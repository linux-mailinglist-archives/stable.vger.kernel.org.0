Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1490865D8C9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239883AbjADQSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239892AbjADQSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:18:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9D818B3A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:18:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE456B817AC
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F1CC433EF;
        Wed,  4 Jan 2023 16:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849086;
        bh=/+RtLJrw83pOsRnIAVJD9SSkZloBC3qiRoY0p3tK/fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+73SzGHCCV1qXg/E8MMsdRHH3nIq/IXkTEx7/vM97PbxVwv8bwd7YD/cwyRZjef4
         8NNTg+ItJ2aSItHPYJtXivITh+6pXZM08drzaWpx2besyfMwXWKdbQdSdj93Ntr+kW
         qAFJaERxvXbTA3HF/qwouG92Twn/3p38Pv3sSda8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 061/177] KVM: x86: fix APICv/x2AVIC disabled when vm reboot by itself
Date:   Wed,  4 Jan 2023 17:05:52 +0100
Message-Id: <20230104160509.506216187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>

commit ef40757743b47cc95de9b4ed41525c94f8dc73d9 upstream.

When a VM reboots itself, the reset process will result in
an ioctl(KVM_SET_LAPIC, ...) to disable x2APIC mode and set
the xAPIC id of the vCPU to its default value, which is the
vCPU id.

That will be handled in KVM as follows:

     kvm_vcpu_ioctl_set_lapic
       kvm_apic_set_state
	  kvm_lapic_set_base  =>  disable X2APIC mode
	    kvm_apic_state_fixup
	      kvm_lapic_xapic_id_updated
	        kvm_xapic_id(apic) != apic->vcpu->vcpu_id
		kvm_set_apicv_inhibit(APICV_INHIBIT_REASON_APIC_ID_MODIFIED)
	   memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s))  => update APIC_ID

When kvm_apic_set_state invokes kvm_lapic_set_base to disable
x2APIC mode, the old 32-bit x2APIC id is still present rather
than the 8-bit xAPIC id.  kvm_lapic_xapic_id_updated will set the
APICV_INHIBIT_REASON_APIC_ID_MODIFIED bit and disable APICv/x2AVIC.

Instead, kvm_lapic_xapic_id_updated must be called after APIC_ID is
changed.

In fact, this fixes another small issue in the code in that
potential changes to a vCPU's xAPIC ID need not be tracked for
KVM_GET_LAPIC.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Signed-off-by: Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
Message-Id: <1669984574-32692-1-git-send-email-yuanzhaoxiong@baidu.com>
Cc: stable@vger.kernel.org
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2722,8 +2722,6 @@ static int kvm_apic_state_fixup(struct k
 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 		}
-	} else {
-		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
 	}
 
 	return 0;
@@ -2759,6 +2757,9 @@ int kvm_apic_set_state(struct kvm_vcpu *
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
+	if (!apic_x2apic_mode(apic))
+		kvm_lapic_xapic_id_updated(apic);
+
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);


