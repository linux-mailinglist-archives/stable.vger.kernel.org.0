Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981E41AC448
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbgDPN5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409305AbgDPN5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:57:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2F2321734;
        Thu, 16 Apr 2020 13:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045437;
        bh=kxAl/kLJfUsCpIvICM6QwVBnOzWBV/taZCwvMzq5wjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0CNuD/FOybRjWVPOmot4RmJ76+MMnT5Wigj7wibhpk9aymwGqlnp5RfibESLH3LR
         jmIm9x62towCy83hD8qc0fK98EuN5T1mMVs7aLqvfvd2RWSXtKLIAQ2F6Gwts6bxlo
         w5ArjG1g51DxshseWKZUOq8i+zwnuF6FIobE7TxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.6 133/254] KVM: s390: vsie: Fix delivery of addressing exceptions
Date:   Thu, 16 Apr 2020 15:23:42 +0200
Message-Id: <20200416131343.116657448@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 4d4cee96fb7a3cc53702a9be8299bf525be4ee98 upstream.

Whenever we get an -EFAULT, we failed to read in guest 2 physical
address space. Such addressing exceptions are reported via a program
intercept to the nested hypervisor.

We faked the intercept, we have to return to guest 2. Instead, right
now we would be returning -EFAULT from the intercept handler, eventually
crashing the VM.
the correct thing to do is to return 1 as rc == 1 is the internal
representation of "we have to go back into g2".

Addressing exceptions can only happen if the g2->g3 page tables
reference invalid g2 addresses (say, either a table or the final page is
not accessible - so something that basically never happens in sane
environments.

Identified by manual code inspection.

Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200403153050.20569-3-david@redhat.com
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
[borntraeger@de.ibm.com: fix patch description]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/vsie.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1202,6 +1202,7 @@ static int vsie_run(struct kvm_vcpu *vcp
 		scb_s->iprcc = PGM_ADDRESSING;
 		scb_s->pgmilc = 4;
 		scb_s->gpsw.addr = __rewind_psw(scb_s->gpsw, 4);
+		rc = 1;
 	}
 	return rc;
 }


