Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36C138A750
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbhETKhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236493AbhETKd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F39346161C;
        Thu, 20 May 2021 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504369;
        bh=kbph+OCMGvkpl0PwQ4sZMAjVv0+sOnl0W0xrNpNcW+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzIC/CH7Wli5dLJIqWtv+tlh1dIoSO5s8g99YJl0Y9A7THpOzPz50AYhRFIvZuuKR
         R1kW+tFrk3kgx6oAGeAEV+NqapRHP5ZF3t/lZKonRusuUcbZGVKpz721VK/cNiCGni
         hrCTTEPkLCSrTtz2MP126D90fNseR7ch364KzhTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 215/323] MIPS: pci-legacy: stop using of_pci_range_to_resource
Date:   Thu, 20 May 2021 11:21:47 +0200
Message-Id: <20210520092127.498539638@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 1ae6bc414e2b..c932ffa6e1d3 100644
--- a/arch/mips/pci/pci-legacy.c
+++ b/arch/mips/pci/pci-legacy.c
@@ -169,8 +169,13 @@ void pci_load_of_ranges(struct pci_controller *hose, struct device_node *node)
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



