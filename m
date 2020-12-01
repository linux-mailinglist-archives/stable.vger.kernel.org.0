Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCA62C9D51
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390540AbgLAJVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:21:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389256AbgLAJId (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9BB21D7A;
        Tue,  1 Dec 2020 09:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813672;
        bh=Ea8c+J32xde41AqYuSmUmWKow8A7G5HmWbORWiEKJmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBV0E0gX87xounWIMy5gM63x9SvUt/ThrumR8ZLfB5+EM0HZxIZaTjx5E3x9uAChm
         35QXQcDOnSmDzFGQF7YFu3Apx06ROTG+l4yB1kA2qOT1er0D8X2/7icL4Nc1lmvBUZ
         5fgwN2OFz+0tt9v131+dqNgpzuVb+HBwaD8bXVkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 020/152] powerpc/64s: Fix KVM system reset handling when CONFIG_PPC_PSERIES=y
Date:   Tue,  1 Dec 2020 09:52:15 +0100
Message-Id: <20201201084714.503903708@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 575cba20c421ecb6b563ae352e4e0468e4ca8b3c upstream.

pseries guest kernels have a FWNMI handler for SRESET and MCE NMIs,
which is basically the same as the regular handlers for those
interrupts.

The system reset FWNMI handler did not have a KVM guest test in it,
although it probably should have because the guest can itself run
guests.

Commit 4f50541f6703b ("powerpc/64s/exception: Move all interrupt
handlers to new style code gen macros") convert the handler faithfully
to avoid a KVM test with a "clever" trick to modify the IKVM_REAL
setting to 0 when the fwnmi handler is to be generated (PPC_PSERIES=y).
This worked when the KVM test was generated in the interrupt entry
handlers, but a later patch moved the KVM test to the common handler,
and the common handler macro is expanded below the fwnmi entry. This
prevents the KVM test from being generated even for the 0x100 entry
point as well.

The result is NMI IPIs in the host kernel when a guest is running will
use gest registers. This goes particularly badly when an HPT guest is
running and the MMU is set to guest mode.

Remove this trickery and just generate the test always.

Fixes: 9600f261acaa ("powerpc/64s/exception: Move KVM test to common code")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201114114743.3306283-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/exceptions-64s.S |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1000,8 +1000,6 @@ TRAMP_REAL_BEGIN(system_reset_idle_wake)
  * Vectors for the FWNMI option.  Share common code.
  */
 TRAMP_REAL_BEGIN(system_reset_fwnmi)
-	/* XXX: fwnmi guest could run a nested/PR guest, so why no test?  */
-	__IKVM_REAL(system_reset)=0
 	GEN_INT_ENTRY system_reset, virt=0
 
 #endif /* CONFIG_PPC_PSERIES */


