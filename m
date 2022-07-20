Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCF357AD0E
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241990AbiGTB13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241970AbiGTB1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:27:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6D674CD8;
        Tue, 19 Jul 2022 18:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37010B81DF6;
        Wed, 20 Jul 2022 01:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A10C341CA;
        Wed, 20 Jul 2022 01:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279889;
        bh=/Ig2tbqHef+3D8WRqRuVOBMa0BsImMB2vBeVVWc89H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQHK7Jtc56dvGN5ca9cjbKF1L2SCmN/WzTWgKNbeoRPDzvLBTZbyronInXil5f7Wr
         h1POB+G7FdKdx8jAkfXO23OeGxFPC2iaHM4Qr4RKp5fCrTtUsQupzNuugcj9/Xj1A5
         GAAnUT48WB9FIedHR8OFgY1WerwfYoCuVrzNLrfj/9e9AoduiDfLLFwrJ3OwMCQBF0
         Dr995RXwNkFjgfz5haD2VALyzc9uP0Q0TbCFDt+7S0ql8bcpwfhM+N+Gk9dsazkQTA
         1LWayEBHLM5VZp4KhOnkXTIZ5/7BQg7PdKadQP0yXFZXUHGhx43eCerj8do5GtKu1R
         94NoI6ieDw3Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changyuan Lyu <changyuanl@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/16] scsi: pm80xx: Set stopped phy's linkrate to Disabled
Date:   Tue, 19 Jul 2022 21:17:30 -0400
Message-Id: <20220720011730.1025099-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011730.1025099-1-sashal@kernel.org>
References: <20220720011730.1025099-1-sashal@kernel.org>
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
index ce67965a504f..5ce65bf2d3a6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3406,8 +3406,12 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("phy:0x%x status:0x%x\n",
 					phyid, status));
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

