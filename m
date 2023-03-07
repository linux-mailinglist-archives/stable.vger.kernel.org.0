Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96D16AF1BB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjCGSrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjCGSqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:46:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F469EF56
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:35:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D7076155E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABC4C433EF;
        Tue,  7 Mar 2023 18:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214100;
        bh=/kVG3WeMvU/WUSXVEAP6aK5jjbZTo0xKB9hR2bn8YDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkar9NNSdfB+ZVKQFNodglZfnj1UUsXUO4ymzBWj9ZFqXjy2ESB9BYzcpe1YEgYsw
         uRwvF7RiTw3fZ7ljaMv/LtFzXxaWq+ePB/nH7sMwtWjxalWmICV0qBeTJhx/WpgTwW
         HOPwCsLFeAyGpf50VSLLbUprB7EOEgaGo66esdX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 721/885] KVM: x86: Dont inhibit APICv/AVIC if xAPIC ID mismatch is due to 32-bit ID
Date:   Tue,  7 Mar 2023 18:00:55 +0100
Message-Id: <20230307170033.341260413@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit f651a008954803d7bb2d85b7042d0fd46133d782 upstream.

Truncate the vcpu_id, a.k.a. x2APIC ID, to an 8-bit value when comparing
it against the xAPIC ID to avoid false positives (sort of) on systems
with >255 CPUs, i.e. with IDs that don't fit into a u8.  The intent of
APIC_ID_MODIFIED is to inhibit APICv/AVIC when the xAPIC is changed from
it's original value,

The mismatch isn't technically a false positive, as architecturally the
xAPIC IDs do end up being aliased in this scenario, and neither APICv
nor AVIC correctly handles IPI virtualization when there is aliasing.
However, KVM already deliberately does not honor the aliasing behavior
that results when an x2APIC ID gets truncated to an xAPIC ID.  I.e. the
resulting APICv/AVIC behavior is aligned with KVM's existing behavior
when KVM's x2APIC hotplug hack is effectively enabled.

If/when KVM provides a way to disable the hotplug hack, APICv/AVIC can
piggyback whatever logic disables the optimized APIC map (which is what
provides the hotplug hack), i.e. so that KVM's optimized map and APIC
virtualization yield the same behavior.

For now, fix the immediate problem of APIC virtualization being disabled
for large VMs, which is a much more pressing issue than ensuring KVM
honors architectural behavior for APIC ID aliasing.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230106011306.85230-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 191b5a962700..2183a9b8efa5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2078,7 +2078,12 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
 		return;
 
-	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
+	/*
+	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
+	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
+	 * value.
+	 */
+	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
 		return;
 
 	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
-- 
2.39.2



