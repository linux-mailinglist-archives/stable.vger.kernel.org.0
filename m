Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B7757ACC9
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbiGTBZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242070AbiGTBYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:24:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E30C73926;
        Tue, 19 Jul 2022 18:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB365B81DD6;
        Wed, 20 Jul 2022 01:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D183C341CE;
        Wed, 20 Jul 2022 01:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279848;
        bh=i3loZA7TO1d65ReVoryig1SMg9VY/k9kQOK6NEh639Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neKmR9CiW5XbxTTC27hCIbDk2tKwZzY+AevBOR9H4TyCffU7Nve0RmyY+ia+tyxYm
         iH55vF7VeLW3bmew15hWtFbxRr/DVfF/PHr9+/Y82Or3/ss2lrxatcBQrTNfgs89bX
         v7Am4RjZRcNH7oJAJEmM3BDSG94QICwjHHS07of2MM4dkuTDicSlV/CXuxY0a+0AbO
         QcCLeLuXHdRQRk2U2FiyuXe7AFnu1XICe5vgiJoSGeR/WmtUIj10cZB95h4urqf1Yl
         59hJzYSSgl5akHNV3bj4nvnWokb1JKo6vW4ndMENeo6RIJcgOihQkc+NEP2cy50mk6
         j5+jys4ciRxzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changyuan Lyu <changyuanl@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/25] scsi: pm80xx: Fix 'Unknown' max/min linkrate
Date:   Tue, 19 Jul 2022 21:16:15 -0400
Message-Id: <20220720011616.1024753-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changyuan Lyu <changyuanl@google.com>

[ Upstream commit e78276cadb669d3e55cffe66bd166ff3c8572e38 ]

Currently, the data flow of the max/min linkrate in the driver is

 * in pm8001_get_lrate_mode():
   hardcoded value ==> struct sas_phy

 * in pm8001_bytes_dmaed():
   struct pm8001_phy ==> struct sas_phy

 * in pm8001_phy_control():
   libsas data ==> struct pm8001_phy

Since pm8001_bytes_dmaed() follows pm8001_get_lrate_mode(), and the fields
in struct pm8001_phy are not initialized, sysfs
`/sys/class/sas_phy/phy-*/maximum_linkrate` always shows `Unknown`.

To fix the issue, change the dataflow to the following:

 * in pm8001_phy_init():
   initial value ==> struct pm8001_phy

 * in pm8001_get_lrate_mode():
   struct pm8001_phy ==> struct sas_phy

 * in pm8001_phy_control():
   libsas data ==> struct pm8001_phy

For negotiated linkrate, the current dataflow is:

 * in pm8001_get_lrate_mode():
   iomb data ==> struct asd_sas_phy ==> struct sas_phy

 * in pm8001_bytes_dmaed():
   struct asd_sas_phy ==> struct sas_phy

Since pm8001_bytes_dmaed() follows pm8001_get_lrate_mode(), the assignment
statements in pm8001_bytes_dmaed() are unnecessary and cleaned up.

Link: https://lore.kernel.org/r/20220707175210.528858-1-changyuanl@google.com
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 19 +++----------------
 drivers/scsi/pm8001/pm8001_init.c |  2 ++
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index da9fbe62a34d..816d853604e8 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3166,15 +3166,6 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
 	if (!phy->phy_attached)
 		return;
 
-	if (sas_phy->phy) {
-		struct sas_phy *sphy = sas_phy->phy;
-		sphy->negotiated_linkrate = sas_phy->linkrate;
-		sphy->minimum_linkrate = phy->minimum_linkrate;
-		sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
-		sphy->maximum_linkrate = phy->maximum_linkrate;
-		sphy->maximum_linkrate_hw = phy->maximum_linkrate;
-	}
-
 	if (phy->phy_type & PORT_TYPE_SAS) {
 		struct sas_identify_frame *id;
 		id = (struct sas_identify_frame *)phy->frame_rcvd;
@@ -3198,26 +3189,22 @@ void pm8001_get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)
 	switch (link_rate) {
 	case PHY_SPEED_120:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_12_0_GBPS;
-		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_12_0_GBPS;
 		break;
 	case PHY_SPEED_60:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_6_0_GBPS;
-		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
 		break;
 	case PHY_SPEED_30:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_3_0_GBPS;
-		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	case PHY_SPEED_15:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_1_5_GBPS;
-		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	}
 	sas_phy->negotiated_linkrate = phy->sas_phy.linkrate;
-	sas_phy->maximum_linkrate_hw = SAS_LINK_RATE_6_0_GBPS;
+	sas_phy->maximum_linkrate_hw = phy->maximum_linkrate;
 	sas_phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
-	sas_phy->maximum_linkrate = SAS_LINK_RATE_6_0_GBPS;
-	sas_phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+	sas_phy->maximum_linkrate = phy->maximum_linkrate;
+	sas_phy->minimum_linkrate = phy->minimum_linkrate;
 }
 
 /**
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 01eb2ade2070..81b4c97af853 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -141,6 +141,8 @@ static void pm8001_phy_init(struct pm8001_hba_info *pm8001_ha, int phy_id)
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	phy->phy_state = PHY_LINK_DISABLE;
 	phy->pm8001_ha = pm8001_ha;
+	phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+	phy->maximum_linkrate = SAS_LINK_RATE_6_0_GBPS;
 	sas_phy->enabled = (phy_id < pm8001_ha->chip->n_phy) ? 1 : 0;
 	sas_phy->class = SAS;
 	sas_phy->iproto = SAS_PROTOCOL_ALL;
-- 
2.35.1

