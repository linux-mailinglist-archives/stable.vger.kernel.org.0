Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA2E1FDC31
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgFRBRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729501AbgFRBRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C068B21D94;
        Thu, 18 Jun 2020 01:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443060;
        bh=7tbR37TlDsxb2DvWezaDQ8YEVSOAqo98BHGh0rZj/rE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wd0AsE7A8ZKtL5f4VjZ2suFMfTbs2XikzAM67/25OI4CL3vHioR9ooZ+7pggxdCCj
         t2T2c40F4LxdPD9WVt1aC8BgX50b4IjgqjZPvM082Cm6SrMLYGLB4AYoE5cQL8OjOg
         zLsTBLrrPxZOk9gX6Nx9r2QJ2bih1U+1EkeRW8k0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.4 051/266] m68k/PCI: Fix a memory leak in an error handling path
Date:   Wed, 17 Jun 2020 21:12:56 -0400
Message-Id: <20200618011631.604574-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 62b0eb6cf69a..84eab0f5e00a 100644
--- a/arch/m68k/coldfire/pci.c
+++ b/arch/m68k/coldfire/pci.c
@@ -216,8 +216,10 @@ static int __init mcf_pci_init(void)
 
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

