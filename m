Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF9860FE5F
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbiJ0REy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236929AbiJ0REu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:04:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8430C5BC1D
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E9D3610AB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C2FC433C1;
        Thu, 27 Oct 2022 17:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890283;
        bh=yQF+60/nRttu+4F813ug7tbSCcUnkXqAAubIk4piuKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Li22e9+7KI/LVenLJobxUqk9NiXLPE5JAr7PUNbqbyc0E6uT9riaWIXtEmBKxC5uo
         LUS/IVC+Q7CztIa6IaK7NZHmwJMK16qEvq1Dx9Kj14InMh+fpQWPjgca2TMax8HTQ2
         EQSZLNelDxxWTXCleSphJc5pfr0TGlpgxVn48nCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 12/79] kvm: Add support for arch compat vm ioctls
Date:   Thu, 27 Oct 2022 18:55:22 +0200
Message-Id: <20221027165054.739599117@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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
@@ -911,6 +911,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			    struct kvm_enable_cap *cap);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg);
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3966,6 +3966,12 @@ struct compat_kvm_clear_dirty_log {
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
@@ -3974,6 +3980,11 @@ static long kvm_vm_compat_ioctl(struct f
 
 	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
+
+	r = kvm_arch_vm_compat_ioctl(filp, ioctl, arg);
+	if (r != -ENOTTY)
+		return r;
+
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	case KVM_CLEAR_DIRTY_LOG: {


