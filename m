Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DBB3A01B2
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhFHSzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhFHSxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:53:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABA8E61483;
        Tue,  8 Jun 2021 18:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177636;
        bh=jTaVlNLcB7p+1qeKRSry2AX+8F0Yy4SjR0IfEuAeplY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rey/q6aVSXom71SaTjZ0NMxeAB6MNPJscq53IV7RI8KMA9DaiwHYVgIJDrqDZ7y7c
         l+4S07A0+86ls4R0ZZJBOlasNwCsboxUhbbwGbaZU4+hX697ThZT/UJs8mS+9+irtB
         VRkeZ7ttvGoKFAwQibpdKEN5S6olk8sSYt3FTcS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/137] vfio/pci: zap_vma_ptes() needs MMU
Date:   Tue,  8 Jun 2021 20:25:51 +0200
Message-Id: <20210608175942.764442650@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 2a55ca37350171d9b43d561528f23d4130097255 ]

zap_vma_ptes() is only available when CONFIG_MMU is set/enabled.
Without CONFIG_MMU, vfio_pci.o has build errors, so make
VFIO_PCI depend on MMU.

riscv64-linux-ld: drivers/vfio/pci/vfio_pci.o: in function `vfio_pci_mmap_open':
vfio_pci.c:(.text+0x1ec): undefined reference to `zap_vma_ptes'
riscv64-linux-ld: drivers/vfio/pci/vfio_pci.o: in function `.L0 ':
vfio_pci.c:(.text+0x165c): undefined reference to `zap_vma_ptes'

Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Eric Auger <eric.auger@redhat.com>
Message-Id: <20210515190856.2130-1-rdunlap@infradead.org>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 0f28bf99efeb..4e1107767e29 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -2,6 +2,7 @@
 config VFIO_PCI
 	tristate "VFIO support for PCI devices"
 	depends on VFIO && PCI && EVENTFD
+	depends on MMU
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 	help
-- 
2.30.2



