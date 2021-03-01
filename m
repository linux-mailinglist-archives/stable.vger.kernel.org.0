Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68398328950
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbhCARyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:54:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238840AbhCARsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:48:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF253650E0;
        Mon,  1 Mar 2021 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617975;
        bh=p0n/G3/HgziC3s7gAHj2oKUZJkygSuzcECSdQm3aKNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZuYRhpQCKWvidwZ6O5Z2a3n0rpG6MY4sthEsFN+TknnQ4zDH6aK6HPqigHdJ0A5Q
         UrB7i6pyul7sUb1CEYf+zBEpr45P8SFRnXfH1VEn4ARMFZ1rATy72IxFWJEVzbYbPh
         ls44GUiNbRwYPOomA2oq1Q4Y36KnUtI5N3A//mEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 234/340] scsi: bnx2fc: Fix Kconfig warning & CNIC build errors
Date:   Mon,  1 Mar 2021 17:12:58 +0100
Message-Id: <20210301161059.817025051@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit eefb816acb0162e94a85a857f3a55148f671d5a5 ]

CNIC depends on MMU, but since 'select' does not follow any dependency
chains, SCSI_BNX2X_FCOE also needs to depend on MMU, so that erroneous
configs are not generated, which cause build errors in cnic.

WARNING: unmet direct dependencies detected for CNIC
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=n] || IPV6 [=n]=n) && MMU [=n]
  Selected by [y]:
  - SCSI_BNX2X_FCOE [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && PCI [=y] && (IPV6 [=n] || IPV6 [=n]=n) && LIBFC [=y] && LIBFCOE [=y]

riscv64-linux-ld: drivers/net/ethernet/broadcom/cnic.o: in function `.L154':
cnic.c:(.text+0x1094): undefined reference to `uio_event_notify'
riscv64-linux-ld: cnic.c:(.text+0x10bc): undefined reference to `uio_event_notify'
riscv64-linux-ld: drivers/net/ethernet/broadcom/cnic.o: in function `.L1442':
cnic.c:(.text+0x96a8): undefined reference to `__uio_register_device'
riscv64-linux-ld: drivers/net/ethernet/broadcom/cnic.o: in function `.L0 ':
cnic.c:(.text.unlikely+0x68): undefined reference to `uio_unregister_device'

Link: https://lore.kernel.org/r/20210213192428.22537-1-rdunlap@infradead.org
Fixes: 853e2bd2103a ("[SCSI] bnx2fc: Broadcom FCoE offload driver")
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/Kconfig b/drivers/scsi/bnx2fc/Kconfig
index e0ccb48ec9617..40e9c9dc04bd8 100644
--- a/drivers/scsi/bnx2fc/Kconfig
+++ b/drivers/scsi/bnx2fc/Kconfig
@@ -5,6 +5,7 @@ config SCSI_BNX2X_FCOE
 	depends on (IPV6 || IPV6=n)
 	depends on LIBFC
 	depends on LIBFCOE
+	depends on MMU
 	select NETDEVICES
 	select ETHERNET
 	select NET_VENDOR_BROADCOM
-- 
2.27.0



