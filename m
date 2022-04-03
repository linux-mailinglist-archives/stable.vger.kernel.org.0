Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ACB4F0825
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 08:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350390AbiDCGsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 02:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbiDCGsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 02:48:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC1E377C2
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 23:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABA54B80BA5
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 06:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F360FC340ED;
        Sun,  3 Apr 2022 06:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648968372;
        bh=bnA0kOAMlR8EC3RFS8Rny6UBTy8Hdv8rvkK3xkKeHw8=;
        h=Subject:To:Cc:From:Date:From;
        b=k8SMZV2Nfj8BZ/dDiOeC2yXpj98nOyErZFYOhY7UVdXVLu0Fu2BlnRJnMoaPeQtcT
         pdKTwRMlCTcyHCU+496qDfinncLydoP0Qotou3UD/3qLarvpitUteMwBrnKesY9p00
         djuczCTanibV6loEV5PAwknRrmE21nsMFXYOTHvY=
Subject: FAILED: patch "[PATCH] KVM: x86: Check lapic_in_kernel() before attempting to set a" failed to apply to 5.4-stable tree
To:     vkuznets@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 08:45:59 +0200
Message-ID: <1648968359150128@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ec37d1cbe17d8189d9562178d8b29167fe1c31a Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Fri, 25 Mar 2022 14:21:38 +0100
Subject: [PATCH] KVM: x86: Check lapic_in_kernel() before attempting to set a
 SynIC irq

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

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a32f54ab84a2..f715b5a2b0e4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -449,6 +449,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	struct kvm_lapic_irq irq;
 	int ret, vector;
 
+	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return -EINVAL;
+
 	if (sint >= ARRAY_SIZE(synic->sint))
 		return -EINVAL;
 

