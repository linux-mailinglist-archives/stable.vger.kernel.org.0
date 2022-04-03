Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD84F0822
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 08:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241735AbiDCGrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 02:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbiDCGrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 02:47:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E002611A
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 23:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9434CB80BA5
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D964BC340ED;
        Sun,  3 Apr 2022 06:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648968339;
        bh=78IPCpxBz4JZe8WMJAhUW4aWSROL0ubjMUts0SJlM9Y=;
        h=Subject:To:Cc:From:Date:From;
        b=oa676UsM0HLal/Dh4a7q9ZGYbwD7UkW3Mj2puKqDBrJS8zrTy/QAys7qG/b7Yre5Z
         MVRBPL16t5JLhFEM/KLypTCmsLB1zz54r8sxA8Yl641XY8/2rvi4AXlEvauLhGPesP
         6an90xGua+g5tzT4VtYiVsTip7Xm2+6Q9OUr9rxo=
Subject: FAILED: patch "[PATCH] KVM: x86: Avoid theoretical NULL pointer dereference in" failed to apply to 4.9-stable tree
To:     vkuznets@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 08:45:36 +0200
Message-ID: <16489683366985@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
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

