Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4162A2E3C1D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407830AbgL1N6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407788AbgL1N6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:58:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD0252063A;
        Mon, 28 Dec 2020 13:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163399;
        bh=STyOaqKNzxE9l0D83R6BIUkvGwDMO1M7fhvcvIOT800=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtGddI/mbl93/tpNBRE0IC1zCgsXGvJSfe/HFf4mC6AT5C9D1q04ptbw3zhLqre1z
         uGdM0wO+7dAV0rKnliDx6WwXjQHn9iqW5n9iqz6n5Qzr1CKFDSm5bu7h/qeYs4M2JV
         kbOGv6IP2NvvQRyx9t381fsJ6lmykwoUe8RByahc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 241/453] scsi: pm80xx: Fix error return in pm8001_pci_probe()
Date:   Mon, 28 Dec 2020 13:47:57 +0100
Message-Id: <20201228124948.821640141@linuxfoundation.org>
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
index 3374f553c617a..8882ba33ca87c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1040,7 +1040,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	pm8001_init_sas_add(pm8001_ha);
 	/* phy setting support for motherboard controller */
-	if (pm8001_configure_phy_settings(pm8001_ha))
+	rc = pm8001_configure_phy_settings(pm8001_ha);
+	if (rc)
 		goto err_out_shost;
 
 	pm8001_post_sas_ha_init(shost, chip);
-- 
2.27.0



