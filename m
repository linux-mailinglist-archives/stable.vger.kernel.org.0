Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7396E57ACF9
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbiGTBZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242145AbiGTBYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:24:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60FA4A81D;
        Tue, 19 Jul 2022 18:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FE8FB81DD5;
        Wed, 20 Jul 2022 01:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03365C341CA;
        Wed, 20 Jul 2022 01:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279849;
        bh=2JMI4+jiFEGbj/Vv46g4htDma9uuS4k32ctd2LwYaF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCpSLkWVJEJESl6yY6n8e/Ct55Y9hqGsYUm94z/xuKNkbWqSlr2z+lJs8cTiqF+b9
         /Ix4mrDiraDSL8/KP1eGJSm6pvEPyBV41peJS5DdBFQl+QUuOutJzyhGnzzF8e7a6A
         oKag/ZxIM5W0G43jgIgnnjHk280j+i69YXoqN+Hw2UYteahX9W9esSwrWPaEwFSnrh
         qnVwE5/jW+HfpFj7woxse3ogXc2HKDDklvy3Y9iNxO6LeJlRNjk6Jm3zfx+uRQ4nC0
         w9grxcvAejEKfjTc609GBZHDjUT1Z0OZjDdBiapt9zYi5qS65/x0qTlRFFcgqrEF3X
         v/m95Khlws78Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changyuan Lyu <changyuanl@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/25] scsi: pm80xx: Set stopped phy's linkrate to Disabled
Date:   Tue, 19 Jul 2022 21:16:16 -0400
Message-Id: <20220720011616.1024753-25-sashal@kernel.org>
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
index 0305c8999ba5..16519daf67cb 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3705,8 +3705,12 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
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

