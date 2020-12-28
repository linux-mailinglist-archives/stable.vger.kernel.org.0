Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B6D2E39EF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390277AbgL1NaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:30:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390270AbgL1NaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F28D21D94;
        Mon, 28 Dec 2020 13:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162168;
        bh=Dg/zvick+tF/dokWLZVEeBnggQEuMjcf8SJ0u0AdwfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeg1a02kktrOB5QBLMrwGC+RGYFWWFt9fzVSt3VXikBgudlfVq0+t8jEWqA8OhQDO
         z1f1tL6nt3IiC0/MRpX8jR3iw9Ubh4V0o1ixdp7tNovwFmQra6rGsR4BnXp78+gXsE
         wDSo7oyoOn4cx3Kfj0jQMtMedFb/IbAYWzjturGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 210/346] scsi: pm80xx: Fix error return in pm8001_pci_probe()
Date:   Mon, 28 Dec 2020 13:48:49 +0100
Message-Id: <20201228124929.937122122@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 97031ccffa4f62728602bfea8439dd045cd3aeb2 ]

The driver did not return an error in the case where
pm8001_configure_phy_settings() failed.

Use rc to store the return value of pm8001_configure_phy_settings().

Link: https://lore.kernel.org/r/20201205115551.2079471-1-zhangqilong3@huawei.com
Fixes: 279094079a44 ("[SCSI] pm80xx: Phy settings support for motherboard controller.")
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7a697ca68501e..1d59d7447a1c8 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1059,7 +1059,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	pm8001_init_sas_add(pm8001_ha);
 	/* phy setting support for motherboard controller */
-	if (pm8001_configure_phy_settings(pm8001_ha))
+	rc = pm8001_configure_phy_settings(pm8001_ha);
+	if (rc)
 		goto err_out_shost;
 
 	pm8001_post_sas_ha_init(shost, chip);
-- 
2.27.0



