Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A044C43B6
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 12:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbiBYLfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 06:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiBYLfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 06:35:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3963D1E482A
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 03:35:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAB0E6193C
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 11:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D160AC340F1;
        Fri, 25 Feb 2022 11:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645788920;
        bh=hr+HDlUtqI0AWQnNIsSsDIRgOm46KtHeczqeZrEsJyY=;
        h=Subject:To:Cc:From:Date:From;
        b=1qtpMiCB7sMaKRIigujsSIRvRZ7ccYfmbGVRsK9vA1S/n3aSdj1E4oT6VUIT8Kh5n
         rUQ+yNmN+FKg/oiSY3vK6KK/l/d5ESIe20Ml6VDMrzo0GqmH+/mfxWoVqEmxNX93zd
         t8zbqHTxumgAFB7BwSzZe/b6XtayMUbVpy5OA1i0=
Subject: FAILED: patch "[PATCH] KVM: x86: Add KVM_CAP_ENABLE_CAP to x86" failed to apply to 4.14-stable tree
To:     aaronlewis@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 12:35:04 +0100
Message-ID: <1645788904211138@kroah.com>
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

