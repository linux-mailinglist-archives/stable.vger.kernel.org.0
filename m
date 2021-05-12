Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B79337C23D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhELPIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232493AbhELPGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F50B6195A;
        Wed, 12 May 2021 15:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831658;
        bh=PbfKYe+osiPgdsnQSlzfrRC76DNdtXx/z2RiJMzamGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sl8gXduj4fSiXxJmVhpLUbz0Kif2a7+aPPnb0MG68q9XYqvKu3dlSCijvs2iZSC2G
         XJSCwMDsFwmE5BchA89M78hzT0Ao4rf+kT2jTNzege+zUhUSlSU424J7RLEFc6M2bO
         BpyuAblCgBTxpM3qMS7S6q3zdsPaspUvQL/2a0Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 209/244] MIPS: pci-legacy: stop using of_pci_range_to_resource
Date:   Wed, 12 May 2021 16:49:40 +0200
Message-Id: <20210512144749.679018043@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>

[ Upstream commit 3ecb9dc1581eebecaee56decac70e35365260866 ]

Mirror commit aeba3731b150 ("powerpc/pci: Fix IO space breakage after
of_pci_range_to_resource() change").

Most MIPS platforms do not define PCI_IOBASE, nor implement
pci_address_to_pio(). Moreover, IO_SPACE_LIMIT is 0xffff for most MIPS
platforms. of_pci_range_to_resource passes the _start address_ of the IO
range into pci_address_to_pio, which then checks it against
IO_SPACE_LIMIT and fails, because for MIPS platforms that use
pci-legacy (pci-lantiq, pci-rt3883, pci-mt7620), IO ranges start much
higher than 0xffff.

In fact, pci-mt7621 in staging already works around this problem, see
commit 09dd629eeabb ("staging: mt7621-pci: fix io space and properly set
resource limits")

So just stop using of_pci_range_to_resource, which does not work for
MIPS.

Fixes PCI errors like:
  pci_bus 0000:00: root bus resource [io  0xffffffff]

Fixes: 0b0b0893d49b ("of/pci: Fix the conversion of IO ranges into IO resources")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pci/pci-legacy.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pci/pci-legacy.c b/arch/mips/pci/pci-legacy.c
index 39052de915f3..3a909194284a 100644
--- a/arch/mips/pci/pci-legacy.c
+++ b/arch/mips/pci/pci-legacy.c
@@ -166,8 +166,13 @@ void pci_load_of_ranges(struct pci_controller *hose, struct device_node *node)
 			res = hose->mem_resource;
 			break;
 		}
-		if (res != NULL)
-			of_pci_range_to_resource(&range, node, res);
+		if (res != NULL) {
+			res->name = node->full_name;
+			res->flags = range.flags;
+			res->start = range.cpu_addr;
+			res->end = range.cpu_addr + range.size - 1;
+			res->parent = res->child = res->sibling = NULL;
+		}
 	}
 }
 
-- 
2.30.2



