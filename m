Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D69A90CE
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389273AbfIDSLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389206AbfIDSLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68992087E;
        Wed,  4 Sep 2019 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620710;
        bh=NGDQCyVycC9SA+WJSA2hJ2rHFe5sjCV3JCNMe92DowI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XD9Pu69NpTj5ahsxklOSmf1ChdECvOJUvL3zPk3ES0JVdIf6Y6XirfGvO89+Nye/R
         ncV3PNGBRUudLMzrOHXnoL4hZK25/aMWMAhJo/hZwM/u7GzGLtnMHAcADRurPCxzqy
         L0AvMgWvkRPffZvz+3gpoGNO9QEr9vnDxqcTN1lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radim Krcmar <rkrcmar@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 067/143] kvm: x86: skip populating logical dest map if apic is not sw enabled
Date:   Wed,  4 Sep 2019 19:53:30 +0200
Message-Id: <20190904175316.688032395@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radim Krcmar <rkrcmar@redhat.com>

commit b14c876b994f208b6b95c222056e1deb0a45de0e upstream.

recalculate_apic_map does not santize ldr and it's possible that
multiple bits are set. In that case, a previous valid entry
can potentially be overwritten by an invalid one.

This condition is hit when booting a 32 bit, >8 CPU, RHEL6 guest and then
triggering a crash to boot a kdump kernel. This is the sequence of
events:
1. Linux boots in bigsmp mode and enables PhysFlat, however, it still
writes to the LDR which probably will never be used.
2. However, when booting into kdump, the stale LDR values remain as
they are not cleared by the guest and there isn't a apic reset.
3. kdump boots with 1 cpu, and uses Logical Destination Mode but the
logical map has been overwritten and points to an inactive vcpu.

Signed-off-by: Radim Krcmar <rkrcmar@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -212,6 +212,9 @@ static void recalculate_apic_map(struct
 		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
 			new->phys_map[xapic_id] = apic;
 
+		if (!kvm_apic_sw_enabled(apic))
+			continue;
+
 		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
 
 		if (apic_x2apic_mode(apic)) {
@@ -254,6 +257,8 @@ static inline void apic_set_spiv(struct
 			static_key_slow_dec_deferred(&apic_sw_disabled);
 		else
 			static_key_slow_inc(&apic_sw_disabled.key);
+
+		recalculate_apic_map(apic->vcpu->kvm);
 	}
 }
 


