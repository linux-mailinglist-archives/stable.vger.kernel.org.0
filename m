Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0817F6A09A6
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjBWNIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjBWNIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CF2199
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:08:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88CAA616ED
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD2AC433D2;
        Thu, 23 Feb 2023 13:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157719;
        bh=+CZ6D1oD5mEXQwJdkneqyYH5PmO9976T5pjm1J+Itig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7DGiWD+Qh7/QMwQJs5lplKyMA2gTtbt7kPP9Hk3Yf2Tp3rD94egfWSv7gufksUTM
         gQfJ5Shkd7BoQaS4OTEiMjJtH4uLVf1hWpvUPnP+PtK9pY/SBr9WplCbzdaKn6LRDz
         sMdXm3VmyUn1bP0qIoR+xz3xc1ENK2BABj2nrpkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jie Zhan <zhanjie9@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/46] scsi: libsas: Add smp_ata_check_ready_type()
Date:   Thu, 23 Feb 2023 14:06:20 +0100
Message-Id: <20230223130432.160001107@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Zhan <zhanjie9@hisilicon.com>

[ Upstream commit 9181ce3cb5d96f0ee28246a857ca651830fa3746 ]

Create function smp_ata_check_ready_type() for LLDDs to wait for SATA
devices to come up after a link reset.

Signed-off-by: Jie Zhan <zhanjie9@hisilicon.com>
Link: https://lore.kernel.org/r/20221118083714.4034612-4-zhanjie9@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c      | 25 +++++++++++++++++++++++++
 drivers/scsi/libsas/sas_expander.c |  4 ++--
 drivers/scsi/libsas/sas_internal.h |  2 ++
 include/scsi/sas_ata.h             |  6 ++++++
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d35c9296f7388..2fd55ef9ffca5 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -287,6 +287,31 @@ static int sas_ata_clear_pending(struct domain_device *dev, struct ex_phy *phy)
 		return 1;
 }
 
+int smp_ata_check_ready_type(struct ata_link *link)
+{
+	struct domain_device *dev = link->ap->private_data;
+	struct sas_phy *phy = sas_get_local_phy(dev);
+	struct domain_device *ex_dev = dev->parent;
+	enum sas_device_type type = SAS_PHY_UNUSED;
+	u8 sas_addr[SAS_ADDR_SIZE];
+	int res;
+
+	res = sas_get_phy_attached_dev(ex_dev, phy->number, sas_addr, &type);
+	sas_put_local_phy(phy);
+	if (res)
+		return res;
+
+	switch (type) {
+	case SAS_SATA_PENDING:
+		return 0;
+	case SAS_END_DEVICE:
+		return 1;
+	default:
+		return -ENODEV;
+	}
+}
+EXPORT_SYMBOL_GPL(smp_ata_check_ready_type);
+
 static int smp_ata_check_ready(struct ata_link *link)
 {
 	int res;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 5ce2518301040..63a23251fb1d8 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1693,8 +1693,8 @@ static int sas_get_phy_change_count(struct domain_device *dev,
 	return res;
 }
 
-static int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
-				    u8 *sas_addr, enum sas_device_type *type)
+int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
+			     u8 *sas_addr, enum sas_device_type *type)
 {
 	int res;
 	struct smp_disc_resp *disc_resp;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 8d0ad3abc7b5c..a94bd0790b055 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -84,6 +84,8 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
 int sas_ex_phy_discover(struct domain_device *dev, int single);
 int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
 			    struct smp_rps_resp *rps_resp);
+int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
+			     u8 *sas_addr, enum sas_device_type *type);
 int sas_try_ata_reset(struct asd_sas_phy *phy);
 void sas_hae_reset(struct work_struct *work);
 
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index a1df4f9d57a31..ec646217e7f6e 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -35,6 +35,7 @@ void sas_ata_end_eh(struct ata_port *ap);
 int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
 			int force_phy_id);
 int sas_ata_wait_after_reset(struct domain_device *dev, unsigned long deadline);
+int smp_ata_check_ready_type(struct ata_link *link);
 #else
 
 
@@ -98,6 +99,11 @@ static inline int sas_ata_wait_after_reset(struct domain_device *dev,
 {
 	return -ETIMEDOUT;
 }
+
+static inline int smp_ata_check_ready_type(struct ata_link *link)
+{
+	return 0;
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.39.0



