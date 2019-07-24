Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE573E8B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389816AbfGXTi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389063AbfGXTi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DE53229F4;
        Wed, 24 Jul 2019 19:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997136;
        bh=BYgD140YwXZPbXuTbm/opODkBbWxfFqvPxTOrrDkIHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tyv3O0fn8tOQAOT+TyaaSFXA122WlL8UYtKyWzQpxMaHxsjt17O/bgnwvtWlHWhmN
         m2xaTcZ6gnUZ1aeRDpFhUNfm0nKdQalMyPvie1FwypQsbGwMegq8RrZVATwFIMLLZd
         Tio0r5n9nVu+WRi0CHab642fcMOfUb0ZnBlQMiB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 332/413] KVM: PPC: Book3S HV: Signed extend decrementer value if not using large decrementer
Date:   Wed, 24 Jul 2019 21:20:23 +0200
Message-Id: <20190724191759.582493703@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
@@ -3603,6 +3603,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu
 
 	vcpu->arch.slb_max = 0;
 	dec = mfspr(SPRN_DEC);
+	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
+		dec = (s32) dec;
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
 	vcpu->cpu = -1;


