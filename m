Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A679859122E
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 16:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiHLO3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 10:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbiHLO3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 10:29:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8993782872
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 07:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B90E3CE256D
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 14:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E1BC433D6;
        Fri, 12 Aug 2022 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660314543;
        bh=uYT3Il+sLbfkf9FdH7MQoCUbYkE6PENo4ZrEAp5aLRE=;
        h=Subject:To:Cc:From:Date:From;
        b=Fb2jcK4RUNf7Iwdhip+DFGih2RqUDMTOORAYFmhL/u3kfWt1UDe2u59D4haP6tjqk
         OSeuTviIM5jCTEDkVslm+ZNikYvKrVn8xCLKUap7yc2TN490bjvkWc5OaZzD4Nwzj4
         n1Qr4EMkyjBoPWUcaeSIOov/dNn9z8C8/QyzHADk=
Subject: FAILED: patch "[PATCH] KVM: x86: Set error code to segment selector on LLDT/LTR" failed to apply to 4.9-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Aug 2022 16:29:01 +0200
Message-ID: <1660314541111120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From 2626206963ace9e8bf92b6eea5ff78dd674c555c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 11 Jul 2022 23:27:49 +0000
Subject: [PATCH] KVM: x86: Set error code to segment selector on LLDT/LTR
 non-canonical #GP

When injecting a #GP on LLDT/LTR due to a non-canonical LDT/TSS base, set
the error code to the selector.  Intel SDM's says nothing about the #GP,
but AMD's APM explicitly states that both LLDT and LTR set the error code
to the selector, not zero.

Note, a non-canonical memory operand on LLDT/LTR does generate a #GP(0),
but the KVM code in question is specific to the base from the descriptor.

Fixes: e37a75a13cda ("KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20220711232750.1092012-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 09e4b67b881f..bd9e9c5627d0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1736,8 +1736,8 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		if (ret != X86EMUL_CONTINUE)
 			return ret;
 		if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
-				((u64)base3 << 32), ctxt))
-			return emulate_gp(ctxt, 0);
+						 ((u64)base3 << 32), ctxt))
+			return emulate_gp(ctxt, err_code);
 	}
 
 	if (seg == VCPU_SREG_TR) {

