Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28259426970
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbhJHLhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240744AbhJHLfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:35:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3888960FC2;
        Fri,  8 Oct 2021 11:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692710;
        bh=tXM17ftZo6zb9iZvoXX/Qu2JrcVS4VAYlpj1pqVIu9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yzj5LDEkypHKxU7yFKpYGeitmgUrSSnl+TWulBaMYhX40Qot6z3hQp5MEcS56yWVC
         kKDr3Gcey8gxXEVexp+iFK0zkTfv9EaxWLCdkdb3rbpjs072cHHMli7tgf577NFg9c
         gytZQvWuPnRiKb0nZRGd6plNP6sQ/lPyOflezHe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 10/48] sparc64: fix pci_iounmap() when CONFIG_PCI is not set
Date:   Fri,  8 Oct 2021 13:27:46 +0200
Message-Id: <20211008112720.372365887@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



