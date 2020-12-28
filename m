Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CFF2E6626
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388668AbgL1NYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388637AbgL1NYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:24:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C14CA22AAD;
        Mon, 28 Dec 2020 13:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161810;
        bh=DzQVrDmpBv/nzWuap9GEoQhzLuYOWJZ/LoOP4HLkE0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWOiSa9cdM/AZRLgV0e8+krBKk93tSs+cq/8mc/FikT3j4O7A4v1Y6l8GxngXeX6o
         g/ZcOlAKSkGidR0tbjYrtl1X5YlvP1y23kUr35YdmTfQsEhJERyjPBhy9B29nYYrO+
         /AFTBc7JWVVDtsUnAbcSFO+1PS21Wz0qjIMv6Z/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/346] scsi: bnx2i: Requires MMU
Date:   Mon, 28 Dec 2020 13:46:18 +0100
Message-Id: <20201228124922.648498092@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 2d586494c4a001312650f0b919d534e429dd1e09 ]

The SCSI_BNX2_ISCSI kconfig symbol selects CNIC and CNIC selects UIO, which
depends on MMU.

Since 'select' does not follow dependency chains, add the same MMU
dependency to SCSI_BNX2_ISCSI.

Quietens this kconfig warning:

WARNING: unmet direct dependencies detected for CNIC
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=m] || IPV6 [=m]=n) && MMU [=n]
  Selected by [m]:
  - SCSI_BNX2_ISCSI [=m] && SCSI_LOWLEVEL [=y] && SCSI [=y] && NET [=y] && PCI [=y] && (IPV6 [=m] || IPV6 [=m]=n)

Link: https://lore.kernel.org/r/20201129070916.3919-1-rdunlap@infradead.org
Fixes: cf4e6363859d ("[SCSI] bnx2i: Add bnx2i iSCSI driver.")
Cc: linux-scsi@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2i/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2i/Kconfig b/drivers/scsi/bnx2i/Kconfig
index ba30ff86d5818..b27a3738d940c 100644
--- a/drivers/scsi/bnx2i/Kconfig
+++ b/drivers/scsi/bnx2i/Kconfig
@@ -3,6 +3,7 @@ config SCSI_BNX2_ISCSI
 	depends on NET
 	depends on PCI
 	depends on (IPV6 || IPV6=n)
+	depends on MMU
 	select SCSI_ISCSI_ATTRS
 	select NETDEVICES
 	select ETHERNET
-- 
2.27.0



