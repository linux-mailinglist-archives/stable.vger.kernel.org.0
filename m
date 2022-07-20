Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B6357AC5A
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241274AbiGTBVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241651AbiGTBVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DF26A9C0;
        Tue, 19 Jul 2022 18:16:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55DF36172D;
        Wed, 20 Jul 2022 01:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB1DC385A2;
        Wed, 20 Jul 2022 01:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279770;
        bh=yFi+738m5tAoBxOaads/0rYD8jyFACjkx0yYi6lkbZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dATWGoNEFLqq8eaKWaQXVNHP1HnN+kCyqlGXQJ6uhV0blytoNvA2RjU3TbvYxsrig
         sqx8apLR0yg3KINflfmSpX72kvP4P6qRsdRDi5c/qETuh677YmuXQ+ig1Rel4CdNVR
         OQBj8n+agcQrybsQxNRPPjbmPcLN/EuB/BkRBJAr66Z3wfnsVblJmDCa8klJ0suPSK
         rPD4AWN8wRi+v5ku9BKJoxfgTb4FJuQW7ZSoS8Bte/y4SRfgWH203se+4Xcht7kLZv
         Z8Z0eLM2YUdtc0nV5pUGq2mBCg0Eu4vMNVdjDEgR1d9gZOdedj5WMVQS4XkHVaPCCx
         79LDfPN1SMsgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changyuan Lyu <changyuanl@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 40/42] scsi: pm80xx: Set stopped phy's linkrate to Disabled
Date:   Tue, 19 Jul 2022 21:13:48 -0400
Message-Id: <20220720011350.1024134-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
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

[ Upstream commit 355bf2e036c954317ddc4a9618b4f7e38ea5a970 ]

Negotiated link rate needs to be updated to 'Disabled' when phy is stopped.

Link: https://lore.kernel.org/r/20220708205026.969161-1-changyuanl@google.com
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 04746df26c6c..146402037488 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3776,8 +3776,12 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_dbg(pm8001_ha, MSG, "phy:0x%x status:0x%x\n",
 		   phyid, status);
 	if (status == PHY_STOP_SUCCESS ||
-		status == PHY_STOP_ERR_DEVICE_ATTACHED)
+		status == PHY_STOP_ERR_DEVICE_ATTACHED) {
 		phy->phy_state = PHY_LINK_DISABLE;
+		phy->sas_phy.phy->negotiated_linkrate = SAS_PHY_DISABLED;
+		phy->sas_phy.linkrate = SAS_PHY_DISABLED;
+	}
+
 	return 0;
 }
 
-- 
2.35.1

