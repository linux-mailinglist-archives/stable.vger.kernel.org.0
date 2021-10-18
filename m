Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D8A431D13
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhJRNrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233707AbhJRNpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:45:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDE65613AB;
        Mon, 18 Oct 2021 13:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564141;
        bh=inY9IIMJd9Wq6FfiKzkCwGuhP2O5pebn4SWvFLz1tU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQXIjODiVI8M6cOz/EhTvdFog94Yuseb97KICB9VhI4+/bImfUnuyjzBaFBieCeKi
         66yBE5e1jHrFv95RlgBXEPu+id+ucxcRaBa/ugBoLTIUjDoGLiT+VWZogu+42lYVAL
         isbkDT4/zQ9DytvqDaycpNK0FuAoYBuLPeVaYyxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        seeteena <s1seetee@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 047/103] powerpc/xive: Discard disabled interrupts in get_irqchip_state()
Date:   Mon, 18 Oct 2021 15:24:23 +0200
Message-Id: <20211018132336.327939100@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit 6f779e1d359b8d5801f677c1d49dcfa10bf95674 upstream.

When an interrupt is passed through, the KVM XIVE device calls the
set_vcpu_affinity() handler which raises the P bit to mask the
interrupt and to catch any in-flight interrupts while routing the
interrupt to the guest.

On the guest side, drivers (like some Intels) can request at probe
time some MSIs and call synchronize_irq() to check that there are no
in flight interrupts. This will call the XIVE get_irqchip_state()
handler which will always return true as the interrupt P bit has been
set on the host side and lock the CPU in an infinite loop.

Fix that by discarding disabled interrupts in get_irqchip_state().

Fixes: da15c03b047d ("powerpc/xive: Implement get_irqchip_state method for XIVE to fix shutdown race")
Cc: stable@vger.kernel.org #v5.4+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Tested-by: seeteena <s1seetee@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211011070203.99726-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/sysdev/xive/common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -997,7 +997,8 @@ static int xive_get_irqchip_state(struct
 		 * interrupt to be inactive in that case.
 		 */
 		*state = (pq != XIVE_ESB_INVALID) && !xd->stale_p &&
-			(xd->saved_p || !!(pq & XIVE_ESB_VAL_P));
+			(xd->saved_p || (!!(pq & XIVE_ESB_VAL_P) &&
+			 !irqd_irq_disabled(data)));
 		return 0;
 	default:
 		return -EINVAL;


