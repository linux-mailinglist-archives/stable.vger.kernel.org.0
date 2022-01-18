Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A47A492AD4
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346629AbiARQNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242800AbiARQLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:11:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D51FC061760;
        Tue, 18 Jan 2022 08:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE27CCE1A3C;
        Tue, 18 Jan 2022 16:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E4FC340E2;
        Tue, 18 Jan 2022 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522272;
        bh=QGUxhGBilWf2yzYAsZvkl/FNKNHY8OjYtLqgw6U6rB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1B5/BpAGMN33CTUSnhdG21JFTrSCiWp/wbYS+Q7T06MLDZpvMgnDL6b578ZXdK1t
         4wGuL0ttqF/AwznJB43LDB8hsZtn6stL3Uyzyi7mf3ZyzbwLrg+7bpihzqmPhmg4v6
         Vo5/LvlhIGDrvDJdqHZRzJ5xgptJPwgrv/5pzbHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Li RongQing <lirongqing@baidu.com>, stable@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 09/28] KVM: x86: dont print when fail to read/write pv eoi memory
Date:   Tue, 18 Jan 2022 17:06:04 +0100
Message-Id: <20220118160452.720746488@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

commit ce5977b181c1613072eafbc7546bcb6c463ea68c upstream.

If guest gives MSR_KVM_PV_EOI_EN a wrong value, this printk() will
be trigged, and kernel log is spammed with the useless message

Fixes: 0d88800d5472 ("kvm: x86: ioapic and apic debug macros cleanup")
Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: stable@kernel.org
Message-Id: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -676,31 +676,25 @@ static inline bool pv_eoi_enabled(struct
 static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
 {
 	u8 val;
-	if (pv_eoi_get_user(vcpu, &val) < 0) {
-		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_get_user(vcpu, &val) < 0)
 		return false;
-	}
+
 	return val & KVM_PV_EOI_ENABLED;
 }
 
 static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
-		printk(KERN_WARNING "Can't set EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0)
 		return;
-	}
+
 	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 
 static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
-		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
 		return;
-	}
+
 	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 


