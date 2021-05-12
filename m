Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A99D37C347
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhELPSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234265AbhELPQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:16:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE9B61952;
        Wed, 12 May 2021 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831972;
        bh=w0ODjGif2rcoZGNVI2RJdhui/zw658jsUrjRas3821E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRYnRoTXtxH2TwhcA0xyn3nGn8olkoEbDveCfKi9nvKNoX0CQGWIeN9D9te6+1Lkr
         yRj2ElngYtRRbQNit3Rwn4jbj+jziFlYRguOtoxgLIzNXhggBHdwlzpckGBK11FkLE
         1g6kH5sYpFXMcK8neacB1T2XxjFr5ZW8Gp32GHRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.10 089/530] KVM: s390: split kvm_s390_real_to_abs
Date:   Wed, 12 May 2021 16:43:19 +0200
Message-Id: <20210512144822.717866727@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit c5d1f6b531e68888cbe6718b3f77a60115d58b9c upstream.

A new function _kvm_s390_real_to_abs will apply prefixing to a real address
with a given prefix value.

The old kvm_s390_real_to_abs becomes now a wrapper around the new function.

This is needed to avoid code duplication in vSIE.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210322140559.500716-2-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/gaccess.h |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -18,17 +18,14 @@
 
 /**
  * kvm_s390_real_to_abs - convert guest real address to guest absolute address
- * @vcpu - guest virtual cpu
+ * @prefix - guest prefix
  * @gra - guest real address
  *
  * Returns the guest absolute address that corresponds to the passed guest real
- * address @gra of a virtual guest cpu by applying its prefix.
+ * address @gra of by applying the given prefix.
  */
-static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
-						 unsigned long gra)
+static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)
 {
-	unsigned long prefix  = kvm_s390_get_prefix(vcpu);
-
 	if (gra < 2 * PAGE_SIZE)
 		gra += prefix;
 	else if (gra >= prefix && gra < prefix + 2 * PAGE_SIZE)
@@ -37,6 +34,20 @@ static inline unsigned long kvm_s390_rea
 }
 
 /**
+ * kvm_s390_real_to_abs - convert guest real address to guest absolute address
+ * @vcpu - guest virtual cpu
+ * @gra - guest real address
+ *
+ * Returns the guest absolute address that corresponds to the passed guest real
+ * address @gra of a virtual guest cpu by applying its prefix.
+ */
+static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
+						 unsigned long gra)
+{
+	return _kvm_s390_real_to_abs(kvm_s390_get_prefix(vcpu), gra);
+}
+
+/**
  * _kvm_s390_logical_to_effective - convert guest logical to effective address
  * @psw: psw of the guest
  * @ga: guest logical address


