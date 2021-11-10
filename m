Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7C444C7F9
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhKJS5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:57:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhKJSzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:55:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFA8061269;
        Wed, 10 Nov 2021 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570166;
        bh=kGRRujJ0TVYCqkl5oZ2FAq43hUPCyXV5Cn7Rt0hFsQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDDcb3O5+u0e+Mv0OPnFFRSIE0S5go/tijBUwSJh0rMMmbFeT5HzZWA5yDKZT61mC
         ajEwPxNGVjgT2NlT/QXr56rVpKE8R3mHMakfAVtnp/KFJgrjkmpB2x5ViKcqu8Sfig
         7px+MOkZH5z4uF2zWMJGulFdLVIRk2yGfHS/phaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvic9@mailbox.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.14 03/24] KVM: x86: avoid warning with -Wbitwise-instead-of-logical
Date:   Wed, 10 Nov 2021 19:43:55 +0100
Message-Id: <20211110182003.446067322@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

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
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/spte.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -310,12 +310,7 @@ static inline bool __is_bad_mt_xwr(struc
 static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 					 u64 spte, int level)
 {
-	/*
-	 * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
-	 * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
-	 * (this is extremely unlikely to be short-circuited as true).
-	 */
-	return __is_bad_mt_xwr(rsvd_check, spte) |
+	return __is_bad_mt_xwr(rsvd_check, spte) ||
 	       __is_rsvd_bits_set(rsvd_check, spte, level);
 }
 


