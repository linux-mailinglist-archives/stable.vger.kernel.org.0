Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8175711338A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbfLDSRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731244AbfLDSMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:12:03 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE4BB20865;
        Wed,  4 Dec 2019 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483123;
        bh=giUmpor69kBQGPlEKJQXTVOif8JHpyxMXUDBvI7re4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1l81dHiOajZuu8jQvNVmVAkhhS3d4APPUr5Tm+vSLnHatfc4q6U8BFAXwM8NjWTt
         qoqvlgl7otgXem2ggWXVEm1pX7KzEvLM3uTcMcGixZE62pOSBNmia0nahgsCkaFc3A
         HcPjPNosSeWguiYT6w6iTo9bMvXdRqQJOAao90Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 061/125] powerpc/mm: Make NULL pointer deferences explicit on bad page faults.
Date:   Wed,  4 Dec 2019 18:56:06 +0100
Message-Id: <20191204175322.677655070@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9376e8e53bfae..2791f568bdb25 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -521,21 +521,22 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 	switch (regs->trap) {
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



