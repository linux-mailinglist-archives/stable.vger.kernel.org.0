Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A9632EA4C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhCEMhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233212AbhCEMhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:37:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F2D65012;
        Fri,  5 Mar 2021 12:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947843;
        bh=tmbZ0ujeLAKfplvADqenZ3g25Ac5KzfRJiS9W3Sutrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9qUe+GZksFwNqluc8HxVrRwhKN90mJN+fMDbRpQuR6wk9eQvJINULBUIVeL8bana
         +xfz1a9paMIcKmDHCVOLOjpn8cS0e/glp9MV+/E4CCrRX+1zYT299dEqw/jpU6jlsS
         AVvd4HRmSgAg5Z2w5J83s0E8rp5UidCi4ngRT4Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 07/52] arm64: cmpxchg: Use "K" instead of "L" for ll/sc immediate constraint
Date:   Fri,  5 Mar 2021 13:21:38 +0100
Message-Id: <20210305120854.016708187@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 4230509978f2921182da4e9197964dccdbe463c3 upstream.

The "L" AArch64 machine constraint, which we use for the "old" value in
an LL/SC cmpxchg(), generates an immediate that is suitable for a 64-bit
logical instruction. However, for cmpxchg() operations on types smaller
than 64 bits, this constraint can result in an invalid instruction which
is correctly rejected by GAS, such as EOR W1, W1, #0xffffffff.

Whilst we could special-case the constraint based on the cmpxchg size,
it's far easier to change the constraint to "K" and put up with using
a register for large 64-bit immediates. For out-of-line LL/SC atomics,
this is all moot anyway.

Reported-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/atomic_ll_sc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -268,7 +268,7 @@ __LL_SC_PREFIX(__cmpxchg_case_##name##sz
 	"2:"								\
 	: [tmp] "=&r" (tmp), [oldval] "=&r" (oldval),			\
 	  [v] "+Q" (*(u##sz *)ptr)					\
-	: [old] "Lr" (old), [new] "r" (new)				\
+	: [old] "Kr" (old), [new] "r" (new)				\
 	: cl);								\
 									\
 	return oldval;							\


