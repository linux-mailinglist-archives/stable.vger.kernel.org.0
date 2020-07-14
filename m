Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C3521F9DD
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgGNSrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729713AbgGNSrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:47:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B90122B37;
        Tue, 14 Jul 2020 18:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752438;
        bh=/gHC++29JAy6ACrY3V6PW+arlIq88u0R9AiIZWZxphw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itYJfEoOrisKWAH6hyBIRGr0GIcXdSHjoJTD/Ba1OqEn44rAGoBffyhnCbaCoQjvO
         wPbTFCnIPKGvJTmb7gUD4VF2x/dnqBlpgunXz/Fh+DFFjzTTyvgO/VjOSRpdUuHHBb
         Fn4h/9VBIWpywUOWLx9TG5+M77j021ZQTGKC4jWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 43/58] KVM: x86: bit 8 of non-leaf PDPEs is not reserved
Date:   Tue, 14 Jul 2020 20:44:16 +0200
Message-Id: <20200714184058.256767459@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
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
@@ -4474,7 +4474,7 @@ __reset_rsvds_bits_mask(struct kvm_vcpu
 			nonleaf_bit8_rsvd | rsvd_bits(7, 7) |
 			rsvd_bits(maxphyaddr, 51);
 		rsvd_check->rsvd_bits_mask[0][2] = exb_bit_rsvd |
-			nonleaf_bit8_rsvd | gbpages_bit_rsvd |
+			gbpages_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);
 		rsvd_check->rsvd_bits_mask[0][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);


