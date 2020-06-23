Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D8E205C96
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388045AbgFWUDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388041AbgFWUD2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D84BC206C3;
        Tue, 23 Jun 2020 20:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942607;
        bh=iFur/krslITuodOFdsok2QxAsRks4Xwnx4x364VXxRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEX7p++VE7LUmQPM0xbAlBdwi/VW9XoxvvW9/ukKKD0/S2s0iiWIuBy/7kzWgxOg2
         ni+Ye7Hnfnz6uRErGTk4oilH48odtEAGI4yYi16eBmXbDSGp4PWycvgBk9sDUu6Eay
         nZWqf+sVZOrnq+hk8wDHdqUAc+Zx49y1QHCVvUeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 063/477] scsi: hisi_sas: Do not reset phy timer to wait for stray phy up
Date:   Tue, 23 Jun 2020 21:51:00 +0200
Message-Id: <20200623195410.596418806@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

[ Upstream commit e16b9ed61e078d836a0f24a82080cf29d7539c7e ]

We found out that after phy up, the hardware reports another oob interrupt
but did not follow a phy up interrupt:

oob ready -> phy up -> DEV found -> oob read -> wait phy up -> timeout

We run link reset when wait phy up timeout, and it send a normal disk into
reset processing. So we made some circumvention action in the code, so that
this abnormal oob interrupt will not start the timer to wait for phy up.

Link: https://lore.kernel.org/r/1589552025-165012-2-git-send-email-john.garry@huawei.com
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9a6deb21fe4df..11caa4b0d7977 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -898,8 +898,11 @@ void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct device *dev = hisi_hba->dev;
 
+	dev_dbg(dev, "phy%d OOB ready\n", phy_no);
+	if (phy->phy_attached)
+		return;
+
 	if (!timer_pending(&phy->timer)) {
-		dev_dbg(dev, "phy%d OOB ready\n", phy_no);
 		phy->timer.expires = jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT * HZ;
 		add_timer(&phy->timer);
 	}
-- 
2.25.1



