Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C223E4C43B8
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 12:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiBYLfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 06:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiBYLfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 06:35:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9623B1E4812
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 03:35:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30BBD6195F
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 11:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB21C340E7;
        Fri, 25 Feb 2022 11:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645788914;
        bh=esl1Z7vzzBKhG9ie9WjoWcx8nRoAOAPeQEstGR59AEg=;
        h=Subject:To:Cc:From:Date:From;
        b=JWjs7gnUqR989mjeESCPhCES8RqKtIl3T8SZJWrQFYCsd3msOvYdeSmoAaAzffrF7
         i8qCBSOPXewXTdgnhXDTIyl1jKDrxPt2WcaESis//ezIuw5NzWmSAAxrWHTSej1CYG
         YqrViJL8yEjr0Aygpn1V/Uy0qzBu+lABugz8oYFc=
Subject: FAILED: patch "[PATCH] KVM: x86: Add KVM_CAP_ENABLE_CAP to x86" failed to apply to 4.19-stable tree
To:     aaronlewis@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 12:35:04 +0100
Message-ID: <164578890499206@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 127770ac0d043435375ab86434f31a93efa88215 Mon Sep 17 00:00:00 2001
From: Aaron Lewis <aaronlewis@google.com>
Date: Mon, 14 Feb 2022 21:29:51 +0000
Subject: [PATCH] KVM: x86: Add KVM_CAP_ENABLE_CAP to x86

Follow the precedent set by other architectures that support the VCPU
ioctl, KVM_ENABLE_CAP, and advertise the VM extension, KVM_CAP_ENABLE_CAP.
This way, userspace can ensure that KVM_ENABLE_CAP is available on a
vcpu before using it.

Fixes: 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Message-Id: <20220214212950.1776943-1-aaronlewis@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..3b4da6c7b25f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1394,7 +1394,7 @@ documentation when it pops into existence).
 -------------------
 
 :Capability: KVM_CAP_ENABLE_CAP
-:Architectures: mips, ppc, s390
+:Architectures: mips, ppc, s390, x86
 :Type: vcpu ioctl
 :Parameters: struct kvm_enable_cap (in)
 :Returns: 0 on success; -1 on error
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 641044db415d..b8bd8da32045 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4233,6 +4233,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_SYS_ATTRIBUTES:
+	case KVM_CAP_ENABLE_CAP:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:

