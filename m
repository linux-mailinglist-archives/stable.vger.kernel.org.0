Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EFB73B61
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404953AbfGXT7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404966AbfGXT7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:59:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4534F206BA;
        Wed, 24 Jul 2019 19:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998374;
        bh=Tzp+ZhRiVS9bYdseA5JBs/kN+fpV3dzKZZHB5idK+4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPv1jLWo551D0hhHoL+BoswJZd1ewBdRfZeyfpj70Zs2u9t9dCk1Y/dcwloPDA5AK
         s0qJATI+GcPV+Sopl6QjV3T5FGMkKdEVO/uH9MhVOpWczcegTDnDHIh3IsUTEiZZbg
         pnmxR5anc0Fu/DIBVlyRZzqDg7cW0vQHVR7Tqt+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 302/371] KVM: PPC: Book3S HV: Signed extend decrementer value if not using large decrementer
Date:   Wed, 24 Jul 2019 21:20:54 +0200
Message-Id: <20190724191746.982481949@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

commit 869537709ebf1dc865e75c3fc97b23f8acf37c16 upstream.

On POWER9 the decrementer can operate in large decrementer mode where
the decrementer is 56 bits and signed extended to 64 bits. When not
operating in this mode the decrementer behaves as a 32 bit decrementer
which is NOT signed extended (as on POWER8).

Currently when reading a guest decrementer value we don't take into
account whether the large decrementer is enabled or not, and this
means the value will be incorrect when the guest is not using the
large decrementer. Fix this by sign extending the value read when the
guest isn't using the large decrementer.

Fixes: 95a6432ce903 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3568,6 +3568,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu
 
 	vcpu->arch.slb_max = 0;
 	dec = mfspr(SPRN_DEC);
+	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
+		dec = (s32) dec;
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
 	vcpu->cpu = -1;


