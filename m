Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE0C60FDA0
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiJ0Q5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbiJ0Q5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:57:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95324B4B6
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85985623ED
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CFFC433D7;
        Thu, 27 Oct 2022 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889835;
        bh=MYOWGRMZShKK19Z0SNCUieR2k7lrndQVXOsCIVsxOGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4VJoatbwEiFazAzD2OoCh6XSkE722HqnvqWKlxU/Ui1upSVnQrN9/w3CzHefIZl7
         OMNmA+UAT/FoVlxJqrSBHic5GTT+8VlKasV5fdEd1H8hGwVgJgQtgAPDg5WsdDDuqT
         hehYhgf0emr7Gnn3jRO5Rts7vx3h0ZMSd0PhAZZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 17/94] kvm: Add support for arch compat vm ioctls
Date:   Thu, 27 Oct 2022 18:54:19 +0200
Message-Id: <20221027165057.773540279@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Graf <graf@amazon.com>

commit ed51862f2f57cbce6fed2d4278cfe70a490899fd upstream.

We will introduce the first architecture specific compat vm ioctl in the
next patch. Add all necessary boilerplate to allow architectures to
override compat vm ioctls when necessary.

Signed-off-by: Alexander Graf <graf@amazon.com>
Message-Id: <20221017184541.2658-2-graf@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |   11 +++++++++++
 2 files changed, 13 insertions(+)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1391,6 +1391,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			    struct kvm_enable_cap *cap);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg);
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4834,6 +4834,12 @@ struct compat_kvm_clear_dirty_log {
 	};
 };
 
+long __weak kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+				     unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 static long kvm_vm_compat_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4842,6 +4848,11 @@ static long kvm_vm_compat_ioctl(struct f
 
 	if (kvm->mm != current->mm || kvm->vm_dead)
 		return -EIO;
+
+	r = kvm_arch_vm_compat_ioctl(filp, ioctl, arg);
+	if (r != -ENOTTY)
+		return r;
+
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	case KVM_CLEAR_DIRTY_LOG: {


