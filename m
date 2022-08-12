Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237F05912FA
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 17:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiHLPci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 11:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiHLPci (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 11:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53025491F8
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 08:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6A0E60918
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 15:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB12C433D7;
        Fri, 12 Aug 2022 15:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660318356;
        bh=hVg5eUDYPr0uMjsqHnLnDy92ZoG0G+dp3f1vxX294Vc=;
        h=Subject:To:Cc:From:Date:From;
        b=p+mWDMfk2oxDGXsT/5bRCJywyC84CW84KHfNQqKcrDHHzGJYoSQTyPouK80w4bg+p
         fg3A803kNsWnP109K692EMkIVHuw+Xfm3VbK/nrHUt81fYQMqNrggCd/SBIcsXpR5S
         2W+PwwkHwWzpMiCcasxe1Swx9Br8gkApjPDIdG4M=
Subject: FAILED: patch "[PATCH] KVM: x86: Signal #GP, not -EPERM, on bad" failed to apply to 5.18-stable tree
To:     seanjc@google.com, jmattson@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Aug 2022 17:32:30 +0200
Message-ID: <1660318350145249@kroah.com>
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


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2368048bf5c2ec4b604ac3431564071e89a0bc71 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 12 May 2022 22:27:14 +0000
Subject: [PATCH] KVM: x86: Signal #GP, not -EPERM, on bad
 WRMSR(MCi_CTL/STATUS)

Return '1', not '-1', when handling an illegal WRMSR to a MCi_CTL or
MCi_STATUS MSR.  The behavior of "all zeros' or "all ones" for CTL MSRs
is architectural, as is the "only zeros" behavior for STATUS MSRs.  I.e.
the intent is to inject a #GP, not exit to userspace due to an unhandled
emulation case.  Returning '-1' gets interpreted as -EPERM up the stack
and effecitvely kills the guest.

Fixes: 890ca9aefa78 ("KVM: Add MCE support")
Fixes: 9ffd986c6e4e ("KVM: X86: #GP when guest attempts to write MCi_STATUS register w/o 0")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20220512222716.4112548-2-seanjc@google.com

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ce0c6fe166d..891ca973c838 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3239,13 +3239,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			 */
 			if ((offset & 0x3) == 0 &&
 			    data != 0 && (data | (1 << 10) | 1) != ~(u64)0)
-				return -1;
+				return 1;
 
 			/* MCi_STATUS */
 			if (!msr_info->host_initiated &&
 			    (offset & 0x3) == 1 && data != 0) {
 				if (!can_set_mci_status(vcpu))
-					return -1;
+					return 1;
 			}
 
 			vcpu->arch.mce_banks[offset] = data;

