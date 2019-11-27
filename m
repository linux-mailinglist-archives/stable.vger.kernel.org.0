Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBA010BA98
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732173AbfK0VEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:04:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732161AbfK0VEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D32FA2086A;
        Wed, 27 Nov 2019 21:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888675;
        bh=cfIdG14Q63GQOlkA/hZ9JJgBBsfr+CPkNd3cO7cwUs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU73gKnt0lq14Tq11yr7+Dr6Njsr6dlrY9MwR2F+q/p14QexyehyAUL0qZx1gch+t
         31JjMhokKDa/0w02w+Af04VTpN4NazRuPZ03rDQG9eF3+tMV6J/BiIC/2h3E/My0ls
         XrSviNHmwOt6m3LPM4/8LOK1QErLnPSYsrkQJQ0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 225/306] scsi: mpt3sas: Dont modify EEDPTagMode field setting on SAS3.5 HBA devices
Date:   Wed, 27 Nov 2019 21:31:15 +0100
Message-Id: <20191127203131.484067241@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
index d2ab52026014f..2c556c7fcf0dc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4117,7 +4117,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
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



