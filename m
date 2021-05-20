Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43AC38AAC8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240525AbhETLRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239968AbhETLPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:15:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CA061D60;
        Thu, 20 May 2021 10:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505342;
        bh=0IPhRDTX+qYV434FG0p+AicINTSDH8pdhGNikNitOQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGBBwU9IOXxi3l5Jr7MvUZD7EtXrUF1WC0hLMxT25YKHD+W2ucgMzVam+/ZPpHZlD
         9f+R9LWQ1J70OVs21tnXXpd0OHUU4k6nMJS39F6nXxoK6IwuAs8lQNHvxVaofIeLIH
         8WkPyBg1FuV7TbXDR5uFEfBVGhwZ8uK2T3zgH8XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 4.4 074/190] KVM: s390: split kvm_s390_real_to_abs
Date:   Thu, 20 May 2021 11:22:18 +0200
Message-Id: <20210520092104.636289067@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
@@ -21,17 +21,14 @@
 
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
@@ -40,6 +37,20 @@ static inline unsigned long kvm_s390_rea
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
  * kvm_s390_logical_to_effective - convert guest logical to effective address
  * @vcpu: guest virtual cpu
  * @ga: guest logical address


