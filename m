Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550A210BDD2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbfK0Uxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:53:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbfK0Uxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:53:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC7221929;
        Wed, 27 Nov 2019 20:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888013;
        bh=zwqFsR5FTsY0QpvqPh8rX5XlnQ914OsYn3y5BaG5MiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOvli7FHbh73pfXH/LPV0eON1si7WAWTxd9eikkKq9KNLuiGsYIeVCoN6oOrrt0AP
         MatKlgoE+oeV0NRTd21gh8ZT7O8yY6uScMec6FG9v3a5k7VLHNcZXj9ZclXuCYV7M4
         r8Gqj2cEYJi+3HlUDuR3qgmSwUljmmaBtL1ywMvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 141/211] scsi: mpt3sas: Dont modify EEDPTagMode field setting on SAS3.5 HBA devices
Date:   Wed, 27 Nov 2019 21:31:14 +0100
Message-Id: <20191127203107.327671467@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

[ Upstream commit 6cd1bc7b9b5075d395ba0120923903873fc7ea0e ]

If EEDPTagMode field in manufacturing page11 is set then unset it. This is
needed to fix a hardware bug only in SAS3/SAS2 cards. So, skipping
EEDPTagMode changes in Manufacturing page11 for SAS 3.5 controllers.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7bfe53f48d1d4..817a7963a038b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3140,7 +3140,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	 * flag unset in NVDATA.
 	 */
 	mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply, &ioc->manu_pg11);
-	if (ioc->manu_pg11.EEDPTagMode == 0) {
+	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
 		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
 		    ioc->name);
 		ioc->manu_pg11.EEDPTagMode &= ~0x3;
-- 
2.20.1



