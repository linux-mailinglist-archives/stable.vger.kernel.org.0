Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6AC41A7E8
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbhI1F77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239308AbhI1F6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90E261350;
        Tue, 28 Sep 2021 05:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808611;
        bh=tXM17ftZo6zb9iZvoXX/Qu2JrcVS4VAYlpj1pqVIu9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTZzbzEPsirajhcMUKGWMBDzgo9uc34wBIrMaR2iQWQQA8mXa8dmF/Ygm2IJ+4Tvi
         YTkhosmPxQgi8WobSMOiEXlUKePU9HAGhMzylBspmihQe2oGnl5cuek7MdiE/ijRw3
         Vt/XYXdlDFkkzcZqt+KtYgVWYKcLWjYtox3muO5dXfvLzrsHcjF/EuvwLF5OALaUkz
         IxmnH8L720a+rzJ4KgDKaDFUWI3Hnx32yZy6cD3zrWNlpvxV+m0+BX3fvsvXLmooRh
         +oXiCikWT4ZNFvh7CYRnnZL8OI94t4o2flRKN9fCG1UImCUBIgv+07/g687Yb2t1S+
         Rpih9daCowFvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/23] sparc64: fix pci_iounmap() when CONFIG_PCI is not set
Date:   Tue, 28 Sep 2021 01:56:30 -0400
Message-Id: <20210928055645.172544-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit d8b1e10a2b8efaf71d151aa756052fbf2f3b6d57 ]

Guenter reported [1] that the pci_iounmap() changes remain problematic,
with sparc64 allnoconfig and tinyconfig still not building due to the
header file changes and confusion with the arch-specific pci_iounmap()
implementation.

I'm pretty convinced that sparc should just use GENERIC_IOMAP instead of
doing its own thing, since it turns out that the sparc64 version of
pci_iounmap() is somewhat buggy (see [2]).  But in the meantime, this
just fixes the build by avoiding the trivial re-definition of the empty
case.

Link: https://lore.kernel.org/lkml/20210920134424.GA346531@roeck-us.net/ [1]
Link: https://lore.kernel.org/lkml/CAHk-=wgheheFx9myQyy5osh79BAazvmvYURAtub2gQtMvLrhqQ@mail.gmail.com/ [2]
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/lib/iomap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/lib/iomap.c b/arch/sparc/lib/iomap.c
index c9da9f139694..f3a8cd491ce0 100644
--- a/arch/sparc/lib/iomap.c
+++ b/arch/sparc/lib/iomap.c
@@ -19,8 +19,10 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
+#ifdef CONFIG_PCI
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	/* nothing to do */
 }
 EXPORT_SYMBOL(pci_iounmap);
+#endif
-- 
2.33.0

