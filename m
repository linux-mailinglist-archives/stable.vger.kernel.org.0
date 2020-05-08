Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D24E1CAAFA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgEHMin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbgEHMik (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A882495F;
        Fri,  8 May 2020 12:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941518;
        bh=4RRrK7MglMPlDjzWMyuZn/iF6F0PRJ7h/i9OJjOr3GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1P2KxEuuZJCt7TSyJYbmZdxUZhpbrAU0Ejopw2DgDY4IobmM2vg6vcGavVh1uqUw
         3E5wz4D90VZ/YFOFivEZVh9KtV077TiSOrlP2pRJJySQA2IDY2MVstqUzsEtQzHLGn
         NAg8CxAlQEK3Cn00AzkhSblkdqAzvTXjtZVCXrlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        kvm@vger.kernel.org
Subject: [PATCH 4.4 026/312] MIPS: KVM: Fix translation of MFC0 ErrCtl
Date:   Fri,  8 May 2020 14:30:17 +0200
Message-Id: <20200508123126.325941201@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

commit 66ffc50c480e7ab6ad5642f47276435a8873c31a upstream.

The MIPS KVM dynamic translation is meant to translate "MFC0 rt, ErrCtl"
instructions into "ADD rt, zero, zero" to zero the destination register,
however the rt register number was copied into rt of the ADD instruction
encoding, which is the 2nd source operand. This results in "ADD zero,
zero, rt" which is a no-op, so only the first execution of each such
MFC0 from ErrCtl will actually read 0.

Fix the shift to put the rt from the MFC0 encoding into the rd field of
the ADD.

Fixes: 50c8308538dc ("KVM/MIPS32: Binary patching of select privileged instructions.")
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: kvm@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kvm/dyntrans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kvm/dyntrans.c
+++ b/arch/mips/kvm/dyntrans.c
@@ -82,7 +82,7 @@ int kvm_mips_trans_mfc0(uint32_t inst, u
 
 	if ((rd == MIPS_CP0_ERRCTL) && (sel == 0)) {
 		mfc0_inst = CLEAR_TEMPLATE;
-		mfc0_inst |= ((rt & 0x1f) << 16);
+		mfc0_inst |= ((rt & 0x1f) << 11);
 	} else {
 		mfc0_inst = LW_TEMPLATE;
 		mfc0_inst |= ((rt & 0x1f) << 16);


