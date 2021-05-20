Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE02838A347
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhETJvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234200AbhETJtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:49:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19BC861468;
        Thu, 20 May 2021 09:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503294;
        bh=gF3ENYH1MX9au7Q9ZOzAFmnKgrgF/OFpsE8Ho3z2q14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRlOcFTQX2jOInrQojUlvaGNDyNQqLQ15EGh24kBlp7621up1np8/krax2lXNUYcX
         V/zwSEoJKyY99+5so72jdz0CPKjLfN+BHaGZJ0i/OSbtZHBdyAGOltyRYzfPnrLzsT
         o3SrMoeHQW2xQoOTmo6nnC95NStG0oqAQHfWFMjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 4.19 157/425] KVM: s390: split kvm_s390_logical_to_effective
Date:   Thu, 20 May 2021 11:18:46 +0200
Message-Id: <20210520092136.604754434@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit f85f1baaa18932a041fd2b1c2ca6cfd9898c7d2b upstream.

Split kvm_s390_logical_to_effective to a generic function called
_kvm_s390_logical_to_effective. The new function takes a PSW and an address
and returns the address with the appropriate bits masked off. The old
function now calls the new function with the appropriate PSW from the vCPU.

This is needed to avoid code duplication for vSIE.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: stable@vger.kernel.org # for VSIE: correctly handle MVPG when in VSIE
Link: https://lore.kernel.org/r/20210302174443.514363-2-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/gaccess.h |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -37,6 +37,29 @@ static inline unsigned long kvm_s390_rea
 }
 
 /**
+ * _kvm_s390_logical_to_effective - convert guest logical to effective address
+ * @psw: psw of the guest
+ * @ga: guest logical address
+ *
+ * Convert a guest logical address to an effective address by applying the
+ * rules of the addressing mode defined by bits 31 and 32 of the given PSW
+ * (extendended/basic addressing mode).
+ *
+ * Depending on the addressing mode, the upper 40 bits (24 bit addressing
+ * mode), 33 bits (31 bit addressing mode) or no bits (64 bit addressing
+ * mode) of @ga will be zeroed and the remaining bits will be returned.
+ */
+static inline unsigned long _kvm_s390_logical_to_effective(psw_t *psw,
+							   unsigned long ga)
+{
+	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
+		return ga;
+	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
+		return ga & ((1UL << 31) - 1);
+	return ga & ((1UL << 24) - 1);
+}
+
+/**
  * kvm_s390_logical_to_effective - convert guest logical to effective address
  * @vcpu: guest virtual cpu
  * @ga: guest logical address
@@ -52,13 +75,7 @@ static inline unsigned long kvm_s390_rea
 static inline unsigned long kvm_s390_logical_to_effective(struct kvm_vcpu *vcpu,
 							  unsigned long ga)
 {
-	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-
-	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
-		return ga;
-	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
-		return ga & ((1UL << 31) - 1);
-	return ga & ((1UL << 24) - 1);
+	return _kvm_s390_logical_to_effective(&vcpu->arch.sie_block->gpsw, ga);
 }
 
 /*


