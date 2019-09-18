Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86F6B5D50
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfIRGUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbfIRGUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:20:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37AE921927;
        Wed, 18 Sep 2019 06:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787635;
        bh=xItjJk21um48QSG8Cuzllh+TXH0xwu64qQfvRLOtT4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tb3nDnVIMBYKctZhhz2bby7Xn/je9N2lBhdvOF8HuWHGt4Y8E/uOZGvr1VYTpe5PS
         ZmCCaABOCRd2Op37slk0LecptrUU61qh4KVwqlqeDQEULYKZkdj6zq9NhEkLExWb1+
         d6eTz48ZUdHb003z0j2ypMz/Mk84ilQumP4vxCv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH 4.14 22/45] KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT ioctl
Date:   Wed, 18 Sep 2019 08:19:00 +0200
Message-Id: <20190918061225.314367870@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

commit 53936b5bf35e140ae27e4bbf0447a61063f400da upstream.

When the userspace program runs the KVM_S390_INTERRUPT ioctl to inject
an interrupt, we convert them from the legacy struct kvm_s390_interrupt
to the new struct kvm_s390_irq via the s390int_to_s390irq() function.
However, this function does not take care of all types of interrupts
that we can inject into the guest later (see do_inject_vcpu()). Since we
do not clear out the s390irq values before calling s390int_to_s390irq(),
there is a chance that we copy random data from the kernel stack which
could be leaked to the userspace later.

Specifically, the problem exists with the KVM_S390_INT_PFAULT_INIT
interrupt: s390int_to_s390irq() does not handle it, and the function
__inject_pfault_init() later copies irq->u.ext which contains the
random kernel stack data. This data can then be leaked either to
the guest memory in __deliver_pfault_init(), or the userspace might
retrieve it directly with the KVM_S390_GET_IRQ_STATE ioctl.

Fix it by handling that interrupt type in s390int_to_s390irq(), too,
and by making sure that the s390irq struct is properly pre-initialized.
And while we're at it, make sure that s390int_to_s390irq() now
directly returns -EINVAL for unknown interrupt types, so that we
immediately get a proper error code in case we add more interrupt
types to do_inject_vcpu() without updating s390int_to_s390irq()
sometime in the future.

Cc: stable@vger.kernel.org
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/kvm/20190912115438.25761-1-thuth@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/interrupt.c |   10 ++++++++++
 arch/s390/kvm/kvm-s390.c  |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1701,6 +1701,16 @@ int s390int_to_s390irq(struct kvm_s390_i
 	case KVM_S390_MCHK:
 		irq->u.mchk.mcic = s390int->parm64;
 		break;
+	case KVM_S390_INT_PFAULT_INIT:
+		irq->u.ext.ext_params = s390int->parm;
+		irq->u.ext.ext_params2 = s390int->parm64;
+		break;
+	case KVM_S390_RESTART:
+	case KVM_S390_INT_CLOCK_COMP:
+	case KVM_S390_INT_CPU_TIMER:
+		break;
+	default:
+		return -EINVAL;
 	}
 	return 0;
 }
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3730,7 +3730,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 	}
 	case KVM_S390_INTERRUPT: {
 		struct kvm_s390_interrupt s390int;
-		struct kvm_s390_irq s390irq;
+		struct kvm_s390_irq s390irq = {};
 
 		r = -EFAULT;
 		if (copy_from_user(&s390int, argp, sizeof(s390int)))


