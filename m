Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B188845C5ED
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353759AbhKXOCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:02:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353569AbhKXOAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B23E61401;
        Wed, 24 Nov 2021 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759344;
        bh=fE8VBTYqLSLGZI2S8ceYbE28FF0tKba9r2x+nxz04bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZTE6Hw8ynw4M7d9U3c+BLb0nK3Vbyd8VlsjZK5jBlvt0x1TiEi8haxSO9ASGmoNZ
         ky/pO9aEhi35XEI1yJsooVWGnDHzUAV6tdoJdmpSe74Gnc1wo4tn4lZ6/2nAMESZgN
         0xfNb0YB9OPteWcCEXUpjTANem/7JtQsJo4H5uVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>, Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 209/279] powerpc/xive: Change IRQ domain to a tree domain
Date:   Wed, 24 Nov 2021 12:58:16 +0100
Message-Id: <20211124115725.957383003@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit 8e80a73fa9a7747e3e8255cb149c543aabf65a24 upstream.

Commit 4f86a06e2d6e ("irqdomain: Make normal and nomap irqdomains
exclusive") introduced an IRQ_DOMAIN_FLAG_NO_MAP flag to isolate the
'nomap' domains still in use under the powerpc arch. With this new
flag, the revmap_tree of the IRQ domain is not used anymore. This
change broke the support of shared LSIs [1] in the XIVE driver because
it was relying on a lookup in the revmap_tree to query previously
mapped interrupts. Linux now creates two distinct IRQ mappings on the
same HW IRQ which can lead to unexpected behavior in the drivers.

The XIVE IRQ domain is not a direct mapping domain and its HW IRQ
interrupt number space is rather large : 1M/socket on POWER9 and
POWER10, change the XIVE driver to use a 'tree' domain type instead.

[1] For instance, a linux KVM guest with virtio-rng and virtio-balloon
    devices.

Fixes: 4f86a06e2d6e ("irqdomain: Make normal and nomap irqdomains exclusive")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Tested-by: Greg Kurz <groug@kaod.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211116134022.420412-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/sysdev/xive/Kconfig  |    1 -
 arch/powerpc/sysdev/xive/common.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/arch/powerpc/sysdev/xive/Kconfig
+++ b/arch/powerpc/sysdev/xive/Kconfig
@@ -3,7 +3,6 @@ config PPC_XIVE
 	bool
 	select PPC_SMP_MUXED_IPI
 	select HARDIRQS_SW_RESEND
-	select IRQ_DOMAIN_NOMAP
 
 config PPC_XIVE_NATIVE
 	bool
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1443,8 +1443,7 @@ static const struct irq_domain_ops xive_
 
 static void __init xive_init_host(struct device_node *np)
 {
-	xive_irq_domain = irq_domain_add_nomap(np, XIVE_MAX_IRQ,
-					       &xive_irq_domain_ops, NULL);
+	xive_irq_domain = irq_domain_add_tree(np, &xive_irq_domain_ops, NULL);
 	if (WARN_ON(xive_irq_domain == NULL))
 		return;
 	irq_set_default_host(xive_irq_domain);


