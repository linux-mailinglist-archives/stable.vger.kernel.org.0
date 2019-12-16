Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1671213EE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbfLPSGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbfLPSGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 943A0206E0;
        Mon, 16 Dec 2019 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519575;
        bh=HgIBv7vYljcoymvSM8gL33YyVXFJK4cPOimdyTJAuTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thPk1oP2QCO6hiAwf3Kv9RVR6tIZklqegqXyRqbRBSvz1uSZygAf7wtGOschKRYWf
         1sT3FH7SRNwVjcc6UsciKT43sW6BH/aMKkUNcrNX8NGzy8rBk9nsEwWCBD5oLvNTA/
         Bfiidn276ih5etG7q5vtbjJ03uH6m2i0+wk1/gG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/140] scsi: hisi_sas: Reject setting programmed minimum linkrate > 1.5G
Date:   Mon, 16 Dec 2019 18:49:49 +0100
Message-Id: <20191216174822.583600427@linuxfoundation.org>
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

From: Luo Jiaxing <luojiaxing@huawei.com>

[ Upstream commit eb44e4d7b5a3090f0114927f42ae575c29664a09 ]

The SAS controller cannot support a programmed minimum linkrate of > 1.5G
(it will always negotiate to 1.5G at least), so just reject it.

This solves a strange situation where the PHY negotiated linkrate may be
less than the programmed minimum linkrate.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0ad8875c30e8e..f35c56217694b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -886,7 +886,7 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	return hisi_sas_task_exec(task, gfp_flags, 0, NULL);
 }
 
-static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
+static int hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 			struct sas_phy_linkrates *r)
 {
 	struct sas_phy_linkrates _r;
@@ -895,6 +895,9 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	enum sas_linkrate min, max;
 
+	if (r->minimum_linkrate > SAS_LINK_RATE_1_5_GBPS)
+		return -EINVAL;
+
 	if (r->maximum_linkrate == SAS_LINK_RATE_UNKNOWN) {
 		max = sas_phy->phy->maximum_linkrate;
 		min = r->minimum_linkrate;
@@ -902,7 +905,7 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 		max = r->maximum_linkrate;
 		min = sas_phy->phy->minimum_linkrate;
 	} else
-		return;
+		return -EINVAL;
 
 	_r.maximum_linkrate = max;
 	_r.minimum_linkrate = min;
@@ -914,6 +917,8 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 	msleep(100);
 	hisi_hba->hw->phy_set_linkrate(hisi_hba, phy_no, &_r);
 	hisi_hba->hw->phy_start(hisi_hba, phy_no);
+
+	return 0;
 }
 
 static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
@@ -939,8 +944,7 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 
 	case PHY_FUNC_SET_LINK_RATE:
-		hisi_sas_phy_set_linkrate(hisi_hba, phy_no, funcdata);
-		break;
+		return hisi_sas_phy_set_linkrate(hisi_hba, phy_no, funcdata);
 	case PHY_FUNC_GET_EVENTS:
 		if (hisi_hba->hw->get_events) {
 			hisi_hba->hw->get_events(hisi_hba, phy_no);
-- 
2.20.1



