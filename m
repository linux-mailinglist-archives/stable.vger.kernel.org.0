Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D9759DA0A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352154AbiHWKEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352717AbiHWKCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B3F7C53E;
        Tue, 23 Aug 2022 01:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5F07B8105C;
        Tue, 23 Aug 2022 08:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0619FC433C1;
        Tue, 23 Aug 2022 08:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244632;
        bh=KHKdcDR1KcGMN127IkrwnlFmcCyodJnypzzaBS50q94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGOuJUTltSaEgam8ToqSubkZgGtl4VNAlzLrKDYzfgT7Xl6UTjkKahx/tzMzQWLEk
         fAJFI7m2tKUD39zU8VHbjKn3JJkUh9lh2vMYWD/fSAhCz1gMEEQt9MqhlVUydsKe+7
         KuL2X/3CAMMXqxwedx2q3WLgoKzOG+aBzKiJTukM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 167/229] KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
Date:   Tue, 23 Aug 2022 10:25:28 +0200
Message-Id: <20220823080059.622082211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 7ec37d1cbe17d8189d9562178d8b29167fe1c31a upstream

When KVM_CAP_HYPERV_SYNIC{,2} is activated, KVM already checks for
irqchip_in_kernel() so normally SynIC irqs should never be set. It is,
however,  possible for a misbehaving VMM to write to SYNIC/STIMER MSRs
causing erroneous behavior.

The immediate issue being fixed is that kvm_irq_delivery_to_apic()
(kvm_irq_delivery_to_apic_fast()) crashes when called with
'irq.shorthand = APIC_DEST_SELF' and 'src == NULL'.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220325132140.25650-2-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -317,6 +317,9 @@ static int synic_set_irq(struct kvm_vcpu
 	struct kvm_lapic_irq irq;
 	int ret, vector;
 
+	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return -EINVAL;
+
 	if (sint >= ARRAY_SIZE(synic->sint))
 		return -EINVAL;
 


