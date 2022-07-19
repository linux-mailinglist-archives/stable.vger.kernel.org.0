Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FD6579B0A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbiGSMYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239579AbiGSMXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:23:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E7C4F66E;
        Tue, 19 Jul 2022 05:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF7EDCE1BE5;
        Tue, 19 Jul 2022 12:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4B4C341C6;
        Tue, 19 Jul 2022 12:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232485;
        bh=cgi4QBxYoFAxqmZ5tuqyrbT7QX+IIZ4oBUA/TsSEn3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNs258AdlIdsgCPf3V3QNb2Y5TtsZTEUSWttPR+MPoyUmOBQ0UBPfubYXGLcu3S2o
         7QebLfAyQq0STfoeurmnOjPKyJ1YCnQtUheZOoZTtwV6JZP9vr6nJeuwLE3HYErzVS
         BIjMPHl0OkhrZL215HQHQHsKMvReVdsVHDdzGtV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d6caa905917d353f0d07@syzkaller.appspotmail.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/112] KVM: x86: Fully initialize struct kvm_lapic_irq in kvm_pv_kick_cpu_op()
Date:   Tue, 19 Jul 2022 13:54:07 +0200
Message-Id: <20220719114633.660941761@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 8a414f943f8b5f94bbaafdec863d6f3dbef33f8a ]

'vector' and 'trig_mode' fields of 'struct kvm_lapic_irq' are left
uninitialized in kvm_pv_kick_cpu_op(). While these fields are normally
not needed for APIC_DM_REMRD, they're still referenced by
__apic_accept_irq() for trace_kvm_apic_accept_irq(). Fully initialize
the structure to avoid consuming random stack memory.

Fixes: a183b638b61c ("KVM: x86: make apic_accept_irq tracepoint more generic")
Reported-by: syzbot+d6caa905917d353f0d07@syzkaller.appspotmail.com
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220708125147.593975-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da547752580a..c71f702c037d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8142,15 +8142,17 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
  */
 static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
 {
-	struct kvm_lapic_irq lapic_irq;
-
-	lapic_irq.shorthand = APIC_DEST_NOSHORT;
-	lapic_irq.dest_mode = APIC_DEST_PHYSICAL;
-	lapic_irq.level = 0;
-	lapic_irq.dest_id = apicid;
-	lapic_irq.msi_redir_hint = false;
+	/*
+	 * All other fields are unused for APIC_DM_REMRD, but may be consumed by
+	 * common code, e.g. for tracing. Defer initialization to the compiler.
+	 */
+	struct kvm_lapic_irq lapic_irq = {
+		.delivery_mode = APIC_DM_REMRD,
+		.dest_mode = APIC_DEST_PHYSICAL,
+		.shorthand = APIC_DEST_NOSHORT,
+		.dest_id = apicid,
+	};
 
-	lapic_irq.delivery_mode = APIC_DM_REMRD;
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
 
-- 
2.35.1



