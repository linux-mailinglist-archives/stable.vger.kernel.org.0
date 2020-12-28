Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60C82E64D3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbgL1NhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390657AbgL1NhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979CE208B3;
        Mon, 28 Dec 2020 13:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162613;
        bh=TLTqXpD2Sp6EJXCfXHmUQ+JTchvHrg/sIhbXQ/OTlAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWvNYmI9hTkWF+Mp3So7ymBl0CkNEx32d4cLyT/vsjZ336zg8oSswAYAcLT4YIDmX
         dK6CdkegOv9jVnwgO2DHQp9gUVAF1nUKRXvZcjvV6Rr3KpCJ5xUeXAkRveKpUHcRxo
         PnrctHykR4xZLzgMAsa8eq0p4F5Avs/6ZtwCITbE=
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
Subject: [PATCH 5.4 013/453] scsi: bnx2i: Requires MMU
Date:   Mon, 28 Dec 2020 13:44:09 +0100
Message-Id: <20201228124937.886443742@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 702dc82c9501d..a0c0791abee69 100644
--- a/drivers/scsi/bnx2i/Kconfig
+++ b/drivers/scsi/bnx2i/Kconfig
@@ -4,6 +4,7 @@ config SCSI_BNX2_ISCSI
 	depends on NET
 	depends on PCI
 	depends on (IPV6 || IPV6=n)
+	depends on MMU
 	select SCSI_ISCSI_ATTRS
 	select NETDEVICES
 	select ETHERNET
-- 
2.27.0



