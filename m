Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C895C1213EB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfLPSGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729940AbfLPSGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B04FD2072D;
        Mon, 16 Dec 2019 18:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519570;
        bh=oc9ro4LAIuQXzg9PbT00l/mg0NDEym0x4weUm2An9AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMFfXW9TepkB6sgL/dT4Vxi5k6/8XzGvVxh6/WlukwmOHKtXZev5WwHAaNH1fJY99
         0gdv4ChExIMlLcgAzpk2fpMUDtc/oTGiFQKp971wTKYmhLSlZhB8oKQ/zihOeiUJOv
         p/6iWjbu5Sga1UBqRiOdOxCZb9izowoCe6tNRUao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/140] scsi: hisi_sas: send primitive NOTIFY to SSP situation only
Date:   Mon, 16 Dec 2019 18:49:48 +0100
Message-Id: <20191216174820.382069598@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 569eddcf3a0f4efff4ef96a7012010e0f7daa8b4 ]

Send primitive NOTIFY to SSP situation only, or it causes underflow issue
when sending IO. Also rename hisi_sas_hw.sl_notify() to hisi_sas_hw.
sl_notify_ssp().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6c7d2e201abed..d499c44661661 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -220,7 +220,7 @@ struct hisi_sas_hw {
 	int (*slot_index_alloc)(struct hisi_hba *hisi_hba, int *slot_idx,
 				struct domain_device *device);
 	struct hisi_sas_device *(*alloc_dev)(struct domain_device *device);
-	void (*sl_notify)(struct hisi_hba *hisi_hba, int phy_no);
+	void (*sl_notify_ssp)(struct hisi_hba *hisi_hba, int phy_no);
 	int (*get_free_slot)(struct hisi_hba *hisi_hba, struct hisi_sas_dq *dq);
 	void (*start_delivery)(struct hisi_sas_dq *dq);
 	void (*prep_ssp)(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f478d1f50dfc0..0ad8875c30e8e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -716,7 +716,8 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	int phy_no = sas_phy->id;
 
-	hisi_hba->hw->sl_notify(hisi_hba, phy_no); /* This requires a sleep */
+	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
+		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
 	hisi_sas_bytes_dmaed(hisi_hba, phy_no);
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 410eccf0bc5eb..8aa3222fe4865 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -834,7 +834,7 @@ static void phys_init_v1_hw(struct hisi_hba *hisi_hba)
 	mod_timer(timer, jiffies + HZ);
 }
 
-static void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
+static void sl_notify_ssp_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 sl_control;
 
@@ -1822,7 +1822,7 @@ static struct scsi_host_template sht_v1_hw = {
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.hw_init = hisi_sas_v1_init,
 	.setup_itct = setup_itct_v1_hw,
-	.sl_notify = sl_notify_v1_hw,
+	.sl_notify_ssp = sl_notify_ssp_v1_hw,
 	.clear_itct = clear_itct_v1_hw,
 	.prep_smp = prep_smp_v1_hw,
 	.prep_ssp = prep_ssp_v1_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index c4774d63d5d04..ebc984ffe6a22 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1584,7 +1584,7 @@ static void phys_init_v2_hw(struct hisi_hba *hisi_hba)
 	}
 }
 
-static void sl_notify_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+static void sl_notify_ssp_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 sl_control;
 
@@ -3575,7 +3575,7 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.setup_itct = setup_itct_v2_hw,
 	.slot_index_alloc = slot_index_alloc_quirk_v2_hw,
 	.alloc_dev = alloc_dev_quirk_v2_hw,
-	.sl_notify = sl_notify_v2_hw,
+	.sl_notify_ssp = sl_notify_ssp_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
 	.clear_itct = clear_itct_v2_hw,
 	.free_device = free_device_v2_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a7407d5376ba2..ce2f232b3df38 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -827,7 +827,7 @@ static void phys_init_v3_hw(struct hisi_hba *hisi_hba)
 	}
 }
 
-static void sl_notify_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+static void sl_notify_ssp_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 sl_control;
 
@@ -2127,7 +2127,7 @@ static const struct hisi_sas_hw hisi_sas_v3_hw = {
 	.get_wideport_bitmap = get_wideport_bitmap_v3_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v3_hdr),
 	.clear_itct = clear_itct_v3_hw,
-	.sl_notify = sl_notify_v3_hw,
+	.sl_notify_ssp = sl_notify_ssp_v3_hw,
 	.prep_ssp = prep_ssp_v3_hw,
 	.prep_smp = prep_smp_v3_hw,
 	.prep_stp = prep_ata_v3_hw,
-- 
2.20.1



