Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED2C4F082F
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 08:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiDCGue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 02:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiDCGud (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 02:50:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9A213FA4
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 23:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE25D60DB4
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD32DC340ED;
        Sun,  3 Apr 2022 06:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648968519;
        bh=Z7It0m9EwOMV26PifJ8Htm7qXH03bMUj9ravBKojzyk=;
        h=Subject:To:Cc:From:Date:From;
        b=SeLkiOgt/yuuo4tGP1KGY0YaoqKrSM2amO5ZYSKE8RhGPK2I6ScN65+s6BzRQiCJz
         cH8LFsIueINebKmior9O3tMYTL1tsqF1ljI+1MGAjWv8v/+NlR0J4U90AWFtzuwvfH
         xWALcP88Pjdj8zwbHV/UF71uyJkn2bKX2Jl55WWI=
Subject: FAILED: patch "[PATCH] KVM: x86: Avoid theoretical NULL pointer dereference in" failed to apply to 5.10-stable tree
To:     vkuznets@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 08:48:31 +0200
Message-ID: <164896851119659@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 00b5f37189d24ac3ed46cb7f11742094778c46ce Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Fri, 25 Mar 2022 14:21:39 +0100
Subject: [PATCH] KVM: x86: Avoid theoretical NULL pointer dereference in
 kvm_irq_delivery_to_apic_fast()

When kvm_irq_delivery_to_apic_fast() is called with APIC_DEST_SELF
shorthand, 'src' must not be NULL. Crash the VM with KVM_BUG_ON()
instead of crashing the host.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220325132140.25650-3-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 80a2020c4db4..66b0eb0bda94 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1024,6 +1024,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	*r = -1;
 
 	if (irq->shorthand == APIC_DEST_SELF) {
+		if (KVM_BUG_ON(!src, kvm)) {
+			*r = 0;
+			return true;
+		}
 		*r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
 		return true;
 	}

