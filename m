Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509CD38FC0
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbfFGPoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbfFGPoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:44:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC66A2146E;
        Fri,  7 Jun 2019 15:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922293;
        bh=cjaMWXG1wuSzMG16QrIqS8Mcr8Nc8UzIUt0oa+M9Ez0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AO8kxiid2dhP53YOKwnxBQH4YZbD5o55BpwW7szl0MhPM2wF+KfU9QS7vZCj/DRev
         c5jyzEsxuzb61GzfdLeUcvkGXfcbF28xYRX5cdT/91YwCNJQyogg0uLpdu/V8ES+hP
         BNcvIgfOSdcUqr9bLp7bQ0VsOfLqBbmlBcbL8x2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 4.19 34/73] KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID
Date:   Fri,  7 Jun 2019 17:39:21 +0200
Message-Id: <20190607153852.901517671@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

commit a86cb413f4bf273a9d341a3ab2c2ca44e12eb317 upstream.

KVM_CAP_MAX_VCPU_ID is currently always reporting KVM_MAX_VCPU_ID on all
architectures. However, on s390x, the amount of usable CPUs is determined
during runtime - it is depending on the features of the machine the code
is running on. Since we are using the vcpu_id as an index into the SCA
structures that are defined by the hardware (see e.g. the sca_add_vcpu()
function), it is not only the amount of CPUs that is limited by the hard-
ware, but also the range of IDs that we can use.
Thus KVM_CAP_MAX_VCPU_ID must be determined during runtime on s390x, too.
So the handling of KVM_CAP_MAX_VCPU_ID has to be moved from the common
code into the architecture specific code, and on s390x we have to return
the same value here as for KVM_CAP_MAX_VCPUS.
This problem has been discovered with the kvm_create_max_vcpus selftest.
With this change applied, the selftest now passes on s390x, too.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190523164309.13345-9-thuth@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/mips/kvm/mips.c       |    3 +++
 arch/powerpc/kvm/powerpc.c |    3 +++
 arch/s390/kvm/kvm-s390.c   |    1 +
 arch/x86/kvm/x86.c         |    3 +++
 virt/kvm/arm/arm.c         |    3 +++
 virt/kvm/kvm_main.c        |    2 --
 6 files changed, 13 insertions(+), 2 deletions(-)

--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1099,6 +1099,9 @@ int kvm_vm_ioctl_check_extension(struct
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_ID;
+		break;
 	case KVM_CAP_MIPS_FPU:
 		/* We don't handle systems with inconsistent cpu_has_fpu */
 		r = !!raw_cpu_has_fpu;
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -632,6 +632,9 @@ int kvm_vm_ioctl_check_extension(struct
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_ID;
+		break;
 #ifdef CONFIG_PPC_BOOK3S_64
 	case KVM_CAP_PPC_GET_SMMU_INFO:
 		r = 1;
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -489,6 +489,7 @@ int kvm_vm_ioctl_check_extension(struct
 		break;
 	case KVM_CAP_NR_VCPUS:
 	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_S390_BSCA_CPU_SLOTS;
 		if (!kvm_s390_use_sca_entries())
 			r = KVM_MAX_VCPUS;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2987,6 +2987,9 @@ int kvm_vm_ioctl_check_extension(struct
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_ID;
+		break;
 	case KVM_CAP_NR_MEMSLOTS:
 		r = KVM_USER_MEM_SLOTS;
 		break;
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -223,6 +223,9 @@ int kvm_vm_ioctl_check_extension(struct
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_ID;
+		break;
 	case KVM_CAP_NR_MEMSLOTS:
 		r = KVM_USER_MEM_SLOTS;
 		break;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2965,8 +2965,6 @@ static long kvm_vm_ioctl_check_extension
 	case KVM_CAP_MULTI_ADDRESS_SPACE:
 		return KVM_ADDRESS_SPACE_NUM;
 #endif
-	case KVM_CAP_MAX_VCPU_ID:
-		return KVM_MAX_VCPU_ID;
 	default:
 		break;
 	}


