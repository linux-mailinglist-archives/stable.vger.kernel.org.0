Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50220658046
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiL1QQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiL1QQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6388319C33
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01A1CB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0B9C433D2;
        Wed, 28 Dec 2022 16:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244005;
        bh=/NlQ00/LR5XlA2MbDUa67/WFKNqh5ldcsIfdZ3E2JnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuyZ/mK43l4B97PoR/NqJ8p+ygMIktC3gw18iEbSqo/wR3U7RYxkcoICMbniAPhNn
         HJsfsxK7e2juqOiIQosrJWdJTKxRU9KxPqpk8XLs4UQ6YEUV8NXQKIpOW9u7is8lDe
         f+wHmz2N2V8SGq1qXSuApzeAASrB4ATgLeBgQbXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jie Zhan <zhanjie9@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0630/1073] scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset
Date:   Wed, 28 Dec 2022 15:36:58 +0100
Message-Id: <20221228144345.153489765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Zhan <zhanjie9@hisilicon.com>

[ Upstream commit 3c2673a09cf1181318c07b7dbc1bc532ba3d33e3 ]

SATA devices on an expander may be removed and not be found again when I_T
nexus reset and revalidation are processed simultaneously.

The issue comes from:

 - Revalidation can remove SATA devices in link reset, e.g. in
   hisi_sas_clear_nexus_ha().

 - However, hisi_sas_debug_I_T_nexus_reset() polls the state of a SATA
   device on an expander after sending link_reset, where it calls:
    hisi_sas_debug_I_T_nexus_reset
     sas_ata_wait_after_reset
      ata_wait_after_reset
       ata_wait_ready
        smp_ata_check_ready
         sas_ex_phy_discover
          sas_ex_phy_discover_helper
           sas_set_ex_phy

   The ex_phy's change count is updated in sas_set_ex_phy(), so SATA
   devices after a link reset may not be found later through revalidation.

A similar issue was reported in:
commit 0f3fce5cc77e ("[SCSI] libsas: fix ata_eh clobbering ex_phys via
smp_ata_check_ready")
commit 87c8331fcf72 ("[SCSI] libsas: prevent domain rediscovery competing
with ata error handling").

To address this issue, in hisi_sas_debug_I_T_nexus_reset(), we now call
smp_ata_check_ready_type() that only polls the device type while not
updating the ex_phy's data of libsas.

Fixes: 71453bd9d1bf ("scsi: hisi_sas: Use sas_ata_wait_after_reset() in IT nexus reset")
Signed-off-by: Jie Zhan <zhanjie9@hisilicon.com>
Link: https://lore.kernel.org/r/20221118083714.4034612-5-zhanjie9@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 33af5b8dede2..f4f9e5abee76 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1701,13 +1701,15 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 		return rc;
 	}
 
+	/* Remote phy */
 	if (rc)
 		return rc;
 
-	/* Remote phy */
 	if (dev_is_sata(device)) {
-		rc = sas_ata_wait_after_reset(device,
-					HISI_SAS_WAIT_PHYUP_TIMEOUT);
+		struct ata_link *link = &device->sata_dev.ap->link;
+
+		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
+					  smp_ata_check_ready_type);
 	} else {
 		msleep(2000);
 	}
-- 
2.35.1



