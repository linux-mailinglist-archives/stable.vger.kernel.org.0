Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B578F206222
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388099AbgFWUzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392567AbgFWUoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:44:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D1FA21BE5;
        Tue, 23 Jun 2020 20:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945060;
        bh=aVC0bzsG9b9HjVAWAadwDR5xt8QVdC5i7Yfqow4dtPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrcFvdmLBImh9ELWdpRxVUcqkqew+gksvgzz0Y9wR/vs8NMW/uNN8wJz21Har4aTS
         ucT6+SH8zK+qW593YcJO65ezCkDMwaeWoFn2lidGL4Zv4sltKUKZCWPWuxXx9qL+Zl
         ls9vcydX+DOr/xIEJ6vq3fuvWzF4+tQZqWonCCkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/136] m68k/PCI: Fix a memory leak in an error handling path
Date:   Tue, 23 Jun 2020 21:57:59 +0200
Message-Id: <20200623195304.796176655@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c3f4ec050f56eeab7c1f290321f9b762c95bd332 ]

If 'ioremap' fails, we must free 'bridge', as done in other error handling
path bellow.

Fixes: 19cc4c843f40 ("m68k/PCI: Replace pci_fixup_irqs() call with host bridge IRQ mapping hooks")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/coldfire/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/coldfire/pci.c b/arch/m68k/coldfire/pci.c
index 3097fa2ca7467..1e428d18d268a 100644
--- a/arch/m68k/coldfire/pci.c
+++ b/arch/m68k/coldfire/pci.c
@@ -316,8 +316,10 @@ static int __init mcf_pci_init(void)
 
 	/* Keep a virtual mapping to IO/config space active */
 	iospace = (unsigned long) ioremap(PCI_IO_PA, PCI_IO_SIZE);
-	if (iospace == 0)
+	if (iospace == 0) {
+		pci_free_host_bridge(bridge);
 		return -ENODEV;
+	}
 	pr_info("Coldfire: PCI IO/config window mapped to 0x%x\n",
 		(u32) iospace);
 
-- 
2.25.1



