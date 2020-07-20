Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F332263A6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgGTPi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgGTPi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:38:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45CC322CAF;
        Mon, 20 Jul 2020 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259535;
        bh=5ne+sNpcnmECSNmX2RunIzgW66pQk1+y/sfjGuTWTE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1LLVfkXrVfHgTClG/522KxhsMtK6l7TyxW/OFxzuG5dR9l+8zYNUHZJanQ3u5XqX
         xritlaNI1CzeZKeYKwHJQRu14I2JR9jIcJMTfzf3F3yE1+AEkMuVlV/i9T3N9zGv8K
         uy2chDRATY8Zs1lOT4LRRnT8UpfgUuHMiFndUp7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 13/58] KVM: x86: bit 8 of non-leaf PDPEs is not reserved
Date:   Mon, 20 Jul 2020 17:36:29 +0200
Message-Id: <20200720152747.800794113@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 5ecad245de2ae23dc4e2dbece92f8ccfbaed2fa7 upstream.

Bit 8 would be the "global" bit, which does not quite make sense for non-leaf
page table entries.  Intel ignores it; AMD ignores it in PDEs and PDPEs, but
reserves it in PML4Es.

Probably, earlier versions of the AMD manual documented it as reserved in PDPEs
as well, and that behavior made it into KVM as well as kvm-unit-tests; fix it.

Cc: stable@vger.kernel.org
Reported-by: Nadav Amit <namit@vmware.com>
Fixes: a0c0feb57992 ("KVM: x86: reserve bit 8 of non-leaf PDPEs and PML4Es in 64-bit mode on AMD", 2014-09-03)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3679,7 +3679,7 @@ __reset_rsvds_bits_mask(struct kvm_vcpu
 			nonleaf_bit8_rsvd | rsvd_bits(7, 7) |
 			rsvd_bits(maxphyaddr, 51);
 		rsvd_check->rsvd_bits_mask[0][2] = exb_bit_rsvd |
-			nonleaf_bit8_rsvd | gbpages_bit_rsvd |
+			gbpages_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);
 		rsvd_check->rsvd_bits_mask[0][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);


