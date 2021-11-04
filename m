Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D09A44597D
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhKDSU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhKDSU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 14:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7049C611EF;
        Thu,  4 Nov 2021 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636049870;
        bh=djlRi7nW0gwt1k2eXBO/mi+25xkLWQXHOC7IyCRvmYc=;
        h=Date:From:To:Cc:Subject:From;
        b=kCZc8TY3SYQO/S1zR4mPl9Jx2pB0zzKZLb4MOhooqcrs3a5Yi53TfI5PYap+5DOd3
         Pg9zrDpl9Ra+UjDKbEo47A152NfoftGBCyf8raeJjpqSqPlSiKGS03g0uG2RwwinFZ
         gIlw7nQdNAw59z8Wdim5442VqMpakLQDB9y1fqR0BTvVjSwrxKlOzSAS+dvIkr2l55
         wKqZ0iXnENlmGa5HDDsF2+1LRx0AQgT0rd/LDfgJkgjKRxVHBW5fukYAlzIk16fAom
         zwEztjBU3shUqXKJ4+OQURi/wYTaQDL9N/D5ZoB9yxLHLNuWodfYDzN2kULTSsEuxf
         j7Kv2FkKB/alw==
Date:   Thu, 4 Nov 2021 11:17:46 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Please apply 3d5e7a28b1ea2d603dea478e58e37ce75b9597ab to 5.15, 5.14,
 and 5.10
Message-ID: <YYQjyo/dKfDb/no3@archlinux-ax161>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NYgHrozRgQkI6Iup"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NYgHrozRgQkI6Iup
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please apply commit 3d5e7a28b1ea ("KVM: x86: avoid warning with
-Wbitwise-instead-of-logical") to 5.10, 5.14, and 5.15, where it
resolves a build error with tip of tree clang due to -Werror:

arch/x86/kvm/mmu/mmu.c:3548:15: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
                reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                                          ||
arch/x86/kvm/mmu/mmu.c:3548:15: note: cast one or both operands to int to silence this warning
1 error generated.

It applies cleanly to 5.14 and 5.15 and I have attached a backport for
5.10. I have added Paolo in case he has any objections to this.

Cheers,
Nathan

--NYgHrozRgQkI6Iup
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-avoid-warning-with-Wbitwise-instead-of-logic.patch"

From e632639ddfc5e0a6a9f71c38ef840b6a0439b869 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 15 Oct 2021 04:50:01 -0400
Subject: [PATCH 5.10] KVM: x86: avoid warning with
 -Wbitwise-instead-of-logical

commit 3d5e7a28b1ea2d603dea478e58e37ce75b9597ab upstream.

This is a new warning in clang top-of-tree (will be clang 14):

In file included from arch/x86/kvm/mmu/mmu.c:27:
arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
        return __is_bad_mt_xwr(rsvd_check, spte) |
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                 ||
arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning

The code is fine, but change it anyway to shut up this clever clogs
of a compiler.

Reported-by: torvic9@mailbox.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[nathan: Backport to 5.10, which does not have 961f84457cd4]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 060d9a906535..770d18dc4650 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3545,7 +3545,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
 		 * adding a Jcc in the loop.
 		 */
-		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
+		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) ||
 			    __is_rsvd_bits_set(rsvd_check, sptes[level - 1],
 					       level);
 	}

base-commit: 09df347cfd189774130f8ae8267324b97aaf868e
-- 
2.34.0.rc0


--NYgHrozRgQkI6Iup--
