Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA4E4F082B
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 08:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237957AbiDCGst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 02:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236493AbiDCGss (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 02:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FED377FB
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 23:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EF9C60F76
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C410C340ED;
        Sun,  3 Apr 2022 06:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648968414;
        bh=6E6sQkDpVocffv7N0aJsi+P74xfQ0w9dZMmARoahBBM=;
        h=Subject:To:Cc:From:Date:From;
        b=M7r4J6gw0nTn8a2Z49anT2Wo+fz6bJZ6z8EkXp4XZTOoFhK5shR4PELvemfYBaDw8
         GNWMyRHkgYSqlxvZdN9Z11/kRVp+wcmtCYXZf8jKOdguRmyFAYuRQikt7/kBTI9QUK
         Br5nNNHHBNwGmhPzylbH8aqDhA7tr5q9n0yj0cnY=
Subject: FAILED: patch "[PATCH] KVM: x86: Avoid theoretical NULL pointer dereference in" failed to apply to 4.14-stable tree
To:     vkuznets@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 08:46:52 +0200
Message-ID: <164896841291215@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
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

