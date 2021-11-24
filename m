Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85CB45C6AF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350243AbhKXOKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355167AbhKXOId (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:08:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C32E161BA0;
        Wed, 24 Nov 2021 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758233;
        bh=0/rRkYWY6000CvzZW00HHkT68rPkUGbZ2kmutIZq7WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSrH8TmNFeiu6NC90SFdA0MT6bVk11Jg0Kq7LFJ7RIxIS7xqNQf4tIOqUphNluOrD
         B4XmyupodpFzkl1mxLdqmg+qy7bD9cVGthSdG0F2HzNG5ci122avYIMCQB73LU7tJN
         si/l3y6IBnHlw6rPQytLANVZSoZDdTl3iD5tkXgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Axtens <dja@axtens.net>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/100] KVM: PPC: Book3S HV: Use GLOBAL_TOC for kvmppc_h_set_dabr/xdabr()
Date:   Wed, 24 Nov 2021 12:58:28 +0100
Message-Id: <20211124115657.190528128@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit dae581864609d36fb58855fd59880b4941ce9d14 ]

kvmppc_h_set_dabr(), and kvmppc_h_set_xdabr() which jumps into
it, need to use _GLOBAL_TOC to setup the kernel TOC pointer, because
kvmppc_h_set_dabr() uses LOAD_REG_ADDR() to load dawr_force_enable.

When called from hcall_try_real_mode() we have the kernel TOC in r2,
established near the start of kvmppc_interrupt_hv(), so there is no
issue.

But they can also be called from kvmppc_pseries_do_hcall() which is
module code, so the access ends up happening with the kvm-hv module's
r2, which will not point at dawr_force_enable and could even cause a
fault.

With the current code layout and compilers we haven't observed a fault
in practice, the load hits somewhere in kvm-hv.ko and silently returns
some bogus value.

Note that we we expect p8/p9 guests to use the DAWR, but SLOF uses
h_set_dabr() to test if sc1 works correctly, see SLOF's
lib/libhvcall/brokensc1.c.

Fixes: c1fe190c0672 ("powerpc: Add force enable of DAWR on P9 option")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Link: https://lore.kernel.org/r/20210923151031.72408-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index f9c7326672b95..c9c6619564ffa 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2535,7 +2535,7 @@ hcall_real_table:
 	.globl	hcall_real_table_end
 hcall_real_table_end:
 
-_GLOBAL(kvmppc_h_set_xdabr)
+_GLOBAL_TOC(kvmppc_h_set_xdabr)
 EXPORT_SYMBOL_GPL(kvmppc_h_set_xdabr)
 	andi.	r0, r5, DABRX_USER | DABRX_KERNEL
 	beq	6f
@@ -2545,7 +2545,7 @@ EXPORT_SYMBOL_GPL(kvmppc_h_set_xdabr)
 6:	li	r3, H_PARAMETER
 	blr
 
-_GLOBAL(kvmppc_h_set_dabr)
+_GLOBAL_TOC(kvmppc_h_set_dabr)
 EXPORT_SYMBOL_GPL(kvmppc_h_set_dabr)
 	li	r5, DABRX_USER | DABRX_KERNEL
 3:
-- 
2.33.0



