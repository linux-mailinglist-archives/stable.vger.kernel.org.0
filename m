Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CFE492AAE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347372AbiARQMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346708AbiARQKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:10:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C829C0617BC;
        Tue, 18 Jan 2022 08:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D3111CE1A4C;
        Tue, 18 Jan 2022 16:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8625C00446;
        Tue, 18 Jan 2022 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522219;
        bh=QGUxhGBilWf2yzYAsZvkl/FNKNHY8OjYtLqgw6U6rB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGiCO5rM6cDha5SjFSSWxT0GbYcgefEcxdcYzbwrwUU/4Fkt6fe+xkvfJRaRtQhhF
         +C/nIo47TW5xOu/Z/dZVCHBF2x1P8LpXPcGyOX4hfvrV9U+prWz+sr0QSR9VgGqKHi
         ac37D3MJVNBbpBdt3Foz4p3NZJjEZsTJ9Z8a+ytY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Li RongQing <lirongqing@baidu.com>, stable@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 09/28] KVM: x86: dont print when fail to read/write pv eoi memory
Date:   Tue, 18 Jan 2022 17:05:55 +0100
Message-Id: <20220118160452.185229184@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
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
 


