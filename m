Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E0F106569
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfKVGYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbfKVFv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ABB22071C;
        Fri, 22 Nov 2019 05:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401887;
        bh=qoWiZmhKyc5U9nJDESFCNNEjuf4zfvI/EeR6LBTUUF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4wky5QXL5bT5ul1T6O3mF6ciRLOCPjdammwpf3o+2yUXIg2xIUZmLkSrfTzsY8KM
         t9OSWSYJMJ0vYhkzPY42pCOARuBrQ9a7DkKljVix97b3bb1gmyaRPAE6EWbvEAfbTi
         5YaiZMhG896abNYmjskBok64gXPlaL76ORJE7fL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 121/219] powerpc/mm: Make NULL pointer deferences explicit on bad page faults.
Date:   Fri, 22 Nov 2019 00:47:33 -0500
Message-Id: <20191122054911.1750-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 49a502ea23bf9dec47f8f3c3960909ff409cd1bb ]

As several other arches including x86, this patch makes it explicit
that a bad page fault is a NULL pointer dereference when the fault
address is lower than PAGE_SIZE

In the mean time, this page makes all bad_page_fault() messages
shorter so that they remain on one single line. And it prefixes them
by "BUG: " so that they get easily grepped.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
[mpe: Avoid pr_cont()]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/fault.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 365526ee29b88..6e0ff8b600ced 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -633,21 +633,22 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 	switch (TRAP(regs)) {
 	case 0x300:
 	case 0x380:
-		printk(KERN_ALERT "Unable to handle kernel paging request for "
-			"data at address 0x%08lx\n", regs->dar);
+		pr_alert("BUG: %s at 0x%08lx\n",
+			 regs->dar < PAGE_SIZE ? "Kernel NULL pointer dereference" :
+			 "Unable to handle kernel data access", regs->dar);
 		break;
 	case 0x400:
 	case 0x480:
-		printk(KERN_ALERT "Unable to handle kernel paging request for "
-			"instruction fetch\n");
+		pr_alert("BUG: Unable to handle kernel instruction fetch%s",
+			 regs->nip < PAGE_SIZE ? " (NULL pointer?)\n" : "\n");
 		break;
 	case 0x600:
-		printk(KERN_ALERT "Unable to handle kernel paging request for "
-			"unaligned access at address 0x%08lx\n", regs->dar);
+		pr_alert("BUG: Unable to handle kernel unaligned access at 0x%08lx\n",
+			 regs->dar);
 		break;
 	default:
-		printk(KERN_ALERT "Unable to handle kernel paging request for "
-			"unknown fault\n");
+		pr_alert("BUG: Unable to handle unknown paging fault at 0x%08lx\n",
+			 regs->dar);
 		break;
 	}
 	printk(KERN_ALERT "Faulting instruction address: 0x%08lx\n",
-- 
2.20.1

