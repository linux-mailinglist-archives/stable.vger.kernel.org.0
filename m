Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC7657ABDA
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbiGTBQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbiGTBP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA966A9C7;
        Tue, 19 Jul 2022 18:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB392CE1D21;
        Wed, 20 Jul 2022 01:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D36C36AE5;
        Wed, 20 Jul 2022 01:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279624;
        bh=fnNrFofyWZEJTf+HkLXZkVV+hU5gRZDvYEyZWD6kC/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsAJEE1kkAlaIbEmHb1AZRs81yARzt2bi+P4LkhZ4VAawpMzLyNr/+YltCvBkBxHp
         Aliuw+jFm/kn/ba6RibPa+HnWDF4jsQE9kZAgZLq7oq/AEvzrIGJKOo5lCpfR+GH+Y
         7+UIIWwFpXijfNk6bdVxNNezrpMqkbe8ktByMAY4OuiCSE/rGKPtsUbwn6uWFRAntg
         2PO5ZYRn+tyX1g7PyVudYFX4BxA/x+EdijoQH6Yj0TFCKCH880+6wwjn+ltHiSIgmt
         6cWQFm0ey4rxOntfw8EdS/U0b/SW0DVE2xvIVcZ27fQIQJfbZyVcBBTV1WRvhhwgTt
         LEROHvDN8m0og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changyuan Lyu <changyuanl@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 52/54] scsi: pm80xx: Set stopped phy's linkrate to Disabled
Date:   Tue, 19 Jul 2022 21:10:29 -0400
Message-Id: <20220720011031.1023305-52-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
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
index 01c5e8ff4cc5..303cd05fec50 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3723,8 +3723,12 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
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

