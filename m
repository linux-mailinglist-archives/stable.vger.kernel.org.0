Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D1959DA0C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243818AbiHWKEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352733AbiHWKC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716CF7C52E;
        Tue, 23 Aug 2022 01:50:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6C34B8105C;
        Tue, 23 Aug 2022 08:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C41CC433D6;
        Tue, 23 Aug 2022 08:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244638;
        bh=hEUNJb7IAicBZVfgahbqM6ydvks3bcoQGC/znlVEVbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blqU+WJEeTRoc+wRKaC3rGKTfq243USOROI3zycNs5NcT0eFL7yMIu6rz+dCrbXeX
         KtA+ZUdrojxer0kNvG+vKB4L47S16h8PbqxH5p30mDlQU03Ca3ay+wyV8EjFNfxLcn
         q2/4+Bv9pD+TxRR+bOzWCp+Z0cV0YAq3FWFGwEhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 168/229] KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()
Date:   Tue, 23 Aug 2022 10:25:29 +0200
Message-Id: <20220823080059.653148604@linuxfoundation.org>
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

commit 00b5f37189d24ac3ed46cb7f11742094778c46ce upstream

When kvm_irq_delivery_to_apic_fast() is called with APIC_DEST_SELF
shorthand, 'src' must not be NULL. Crash the VM with KVM_BUG_ON()
instead of crashing the host.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220325132140.25650-3-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -894,6 +894,10 @@ bool kvm_irq_delivery_to_apic_fast(struc
 	*r = -1;
 
 	if (irq->shorthand == APIC_DEST_SELF) {
+		if (KVM_BUG_ON(!src, kvm)) {
+			*r = 0;
+			return true;
+		}
 		*r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
 		return true;
 	}


