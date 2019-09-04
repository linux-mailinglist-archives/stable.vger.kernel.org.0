Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8040A9043
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389426AbfIDSIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389813AbfIDSIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:08:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF0EB20870;
        Wed,  4 Sep 2019 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620515;
        bh=NTKwB7aa/kwgpL34pU5dtXVMXwwMvnt49GjVF3BIX10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8ipi257dvvbprkiJQeMsAfkyZuOjNKgtfEyne2JakIJjTbserRWU2hPBWeQA1fwQ
         Nj6t/A5/+I7l3d6JhEWvw5nF3UJzZT4jgIb78YfOHwm6sNh51uhOjNQ+AicYz3L7GO
         /inaIUG1B1dvSeS7JV1AsBaKGW1+PP/GyAfbn6mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radim Krcmar <rkrcmar@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 46/93] kvm: x86: skip populating logical dest map if apic is not sw enabled
Date:   Wed,  4 Sep 2019 19:53:48 +0200
Message-Id: <20190904175307.138573832@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
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
@@ -209,6 +209,9 @@ static void recalculate_apic_map(struct
 		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
 			new->phys_map[xapic_id] = apic;
 
+		if (!kvm_apic_sw_enabled(apic))
+			continue;
+
 		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
 
 		if (apic_x2apic_mode(apic)) {
@@ -252,6 +255,8 @@ static inline void apic_set_spiv(struct
 			recalculate_apic_map(apic->vcpu->kvm);
 		} else
 			static_key_slow_inc(&apic_sw_disabled.key);
+
+		recalculate_apic_map(apic->vcpu->kvm);
 	}
 }
 


