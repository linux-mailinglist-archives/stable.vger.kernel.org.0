Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814104C43B4
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 12:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbiBYLfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 06:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiBYLfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 06:35:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3A91E4812
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 03:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A8C8B82F01
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 11:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3D8C340E7;
        Fri, 25 Feb 2022 11:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645788906;
        bh=aHiSMIiGYHFeu/4qDGcNzoNvwnQrYJx8euf9Ts2kSo8=;
        h=Subject:To:Cc:From:Date:From;
        b=1p327Yy0pi90CKFwR0M1/k2HfvyZN+x/t+qHgQTKGjF1wJvRsSWlJnKxwe9Q9dyDw
         P07M8AStqm9VikBrcf2L3UOXabsf0LH5Tzjl6u8F4tmB3z5EYS/+47/TAOx02p7CMQ
         DLFnCywK4iDtqdcLZI3VLNIVXlGdTw0R9G+E4eTE=
Subject: FAILED: patch "[PATCH] KVM: x86: Add KVM_CAP_ENABLE_CAP to x86" failed to apply to 4.9-stable tree
To:     aaronlewis@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 12:35:03 +0100
Message-ID: <1645788903206212@kroah.com>
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

