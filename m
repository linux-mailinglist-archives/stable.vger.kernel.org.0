Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D366B23A5E1
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgHCMa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbgHCMaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:30:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C46320738;
        Mon,  3 Aug 2020 12:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457823;
        bh=W+fL/TrifVBAVrzVE/HowuH99DgPJsSTdJHaUKb5KX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZ3cabdOnheTOtrLSaO72aziKbl0hZGuw0EEF+tCAq/bicvuiDKTWg13eQwTXCX54
         qPGG1x8tYvrSSh7yscYS0+sdL7bVR6sc9PIf71llhDqPI7sHXa5Hp8y5QaEPDgSWxz
         vGUyJ2pT5tU1iQUNlni2yt6ZfnppddnBYdoVydQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 86/90] KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled
Date:   Mon,  3 Aug 2020 14:19:48 +0200
Message-Id: <20200803121901.758058491@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit d2286ba7d574ba3103a421a2f9ec17cb5b0d87a1 upstream.

Prevent setting the tscdeadline timer if the lapic is hw disabled.

Fixes: bce87cce88 (KVM: x86: consolidate different ways to test for in-kernel LAPIC)
Cc: <stable@vger.kernel.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2085,7 +2085,7 @@ void kvm_set_lapic_tscdeadline_msr(struc
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
+	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
 			apic_lvtt_period(apic))
 		return;
 


