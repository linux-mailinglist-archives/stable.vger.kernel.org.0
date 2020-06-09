Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FC21F4311
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732546AbgFIRtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732542AbgFIRti (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:49:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB18E20801;
        Tue,  9 Jun 2020 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724978;
        bh=elzZlFVVbJQP/RVUFulbrxVPPSPHvHGxsKQio13tRac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xe8OSZ9wOtT4/I7D+g3c3pwM4gRVil3SEyXY7a1LnBYchrbCosSEpJpgqe4hYRSps
         A/Gr+iT7Yj0vgoIRbrWuMOrfu5I5bxoQaFmIyKN0JMJ150wbU3snUue67fFarC66hi
         HAZ8puuM7MugLK4uv7QwGnI4pBb9NEhi2WKHupJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/46] scsi: hisi_sas: Check sas_port before using it
Date:   Tue,  9 Jun 2020 19:44:19 +0200
Message-Id: <20200609174023.206203623@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 8c39673d5474b95374df2104dc1f65205c5278b8 ]

Need to check the structure sas_port before using it.

Link: https://lore.kernel.org/r/1573551059-107873-2-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b167411580ba..dd918c5d5cb8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -655,12 +655,13 @@ static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
 	struct hisi_hba *hisi_hba = sas_ha->lldd_ha;
 	struct hisi_sas_phy *phy = sas_phy->lldd_phy;
 	struct asd_sas_port *sas_port = sas_phy->port;
-	struct hisi_sas_port *port = to_hisi_sas_port(sas_port);
+	struct hisi_sas_port *port;
 	unsigned long flags;
 
 	if (!sas_port)
 		return;
 
+	port = to_hisi_sas_port(sas_port);
 	spin_lock_irqsave(&hisi_hba->lock, flags);
 	port->port_attached = 1;
 	port->id = phy->port_id;
-- 
2.25.1



