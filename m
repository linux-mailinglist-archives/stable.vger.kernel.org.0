Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B28E431C0E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhJRNhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233181AbhJRNfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F6786135A;
        Mon, 18 Oct 2021 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563846;
        bh=ZxcjFqWZXvFV9igIuOLE3hl8vv0O9cCZ+0IFLBuu5F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdDToULNl9Uon/egTa19xph5wtXxuE7nLUxTNcWIqtLi9YqmnJDmGUYmRSeGyNn87
         lzwyBrQ8YJM4JvGfXlQ/cSCjFQ3/YYAgNALG7S96IDdXH+RTYwK+6bJyIqU3Jvg2VD
         9UtTuGYDZFRbVxhJVLNCKh3VlEbc9YdNbFdmXV34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        seeteena <s1seetee@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 37/69] powerpc/xive: Discard disabled interrupts in get_irqchip_state()
Date:   Mon, 18 Oct 2021 15:24:35 +0200
Message-Id: <20211018132330.707750916@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
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
@@ -990,7 +990,8 @@ static int xive_get_irqchip_state(struct
 		 * interrupt to be inactive in that case.
 		 */
 		*state = (pq != XIVE_ESB_INVALID) && !xd->stale_p &&
-			(xd->saved_p || !!(pq & XIVE_ESB_VAL_P));
+			(xd->saved_p || (!!(pq & XIVE_ESB_VAL_P) &&
+			 !irqd_irq_disabled(data)));
 		return 0;
 	default:
 		return -EINVAL;


