Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B105F41A862
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbhI1GE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239061AbhI1GCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A37A61390;
        Tue, 28 Sep 2021 05:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808664;
        bh=DD1/RWx0Jf0U3/++KX4FgO2svGaoEtvE0J5b5DS9k0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUEvt/LXdI/+tNHIREdq2uFTOlz3pNu+gmuak+IvHPZfoJfesxmmMJBwqX0Hombd9
         Xan57rnJdy3R8LrrreYCdroiJZVKAfM71UWT26EoZxAZ/bDrVjEJKicPam4K3jM0IW
         zo0/V6ZfHtLgh6cxZVC/DeqnbESu2AieYIjM7ugP46fRO9C5DitIfNjOGq9RdL8NxG
         1TxN1LzdbBYl5sf25HwRiBCncysmGwdJ8TiE5vvQjwBFvXt+7wy6nXT3Zmf+3I+xBA
         lPsWkuoTMLEG42wibKFfSSgS2h7PwMYRx19HwAPTdhDSw+3MpCpOwdFMmpUxx+IqYb
         pdY4JdNvlu8xA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/5] sparc64: fix pci_iounmap() when CONFIG_PCI is not set
Date:   Tue, 28 Sep 2021 01:57:38 -0400
Message-Id: <20210928055741.173265-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055741.173265-1-sashal@kernel.org>
References: <20210928055741.173265-1-sashal@kernel.org>
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
index c4d42a50ebc0..fa4abbaf27de 100644
--- a/arch/sparc/lib/iomap.c
+++ b/arch/sparc/lib/iomap.c
@@ -18,8 +18,10 @@ void ioport_unmap(void __iomem *addr)
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

