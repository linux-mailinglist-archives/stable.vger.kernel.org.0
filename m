Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D692E3D7E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391766AbgL1OQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440838AbgL1OQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E71F22B2B;
        Mon, 28 Dec 2020 14:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164949;
        bh=86yJcSwYTKaaW/g5i0hJCTrJclIW8UcXEP8Gby8i7p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8CmIHZEgBI8r/S6fZomJqCV+7M7bNfo0oqyzb6y8E7c27fsmbtHUedYJ+JslPboq
         ggp4OgN8KHNyrJmktiAqrdCEGzw9rNAnp1fFBbyteaYDN1I7fy5M6nyf1Fe3mWRx/j
         Wcq+Y0st9/5mst6KJfhTMlYbHyDKYs+MBYBWbaH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/717] scsi: pm80xx: Fix error return in pm8001_pci_probe()
Date:   Mon, 28 Dec 2020 13:45:55 +0100
Message-Id: <20201228125038.115356499@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 3cf3e58b69799..2025361b36e96 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1131,7 +1131,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	pm8001_init_sas_add(pm8001_ha);
 	/* phy setting support for motherboard controller */
-	if (pm8001_configure_phy_settings(pm8001_ha))
+	rc = pm8001_configure_phy_settings(pm8001_ha);
+	if (rc)
 		goto err_out_shost;
 
 	pm8001_post_sas_ha_init(shost, chip);
-- 
2.27.0



