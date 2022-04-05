Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2A44F28E4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbiDEIXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbiDEIRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DD4B18BF;
        Tue,  5 Apr 2022 01:05:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 997B9B81BAF;
        Tue,  5 Apr 2022 08:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010B1C385A0;
        Tue,  5 Apr 2022 08:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145939;
        bh=W91xtLEFfTMll7ZsK6hqKsdimU1ucJroPdiZg5yDm+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+zMgTyr9Sbl2DeqMB3ZWrxiM+ilUv5TURnyxTYL2Y7E05KRdJyZzrtIjVzp9C7D9
         ynGItsSqVfN5sTxr5cfyDmkkkojluoGtRwH16TJmuyhv3Y1e35ReJE3SaDGQ17WNww
         Ahhs6rabJcw+x4jaT0TFIkhfAjr5uy97sgz7ITeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0583/1126] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Tue,  5 Apr 2022 09:22:10 +0200
Message-Id: <20220405070424.745909403@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 1a37b6738b58d86f6b144b3fc754ace0f2e0166d ]

Since the sata_cmd struct is zeroed out before its fields are initialized,
there is no need for using "|=" to initialize the ncqtag_atap_dir_m
field. Using a standard assignment removes the sparse warning:

warning: invalid assignment: |=

Also, since the ncqtag_atap_dir_m field has type __le32, use cpu_to_le32()
to generate the assigned value.

Link: https://lore.kernel.org/r/20220220031810.738362-5-damien.lemoal@opensource.wdc.com
Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 9ec310b795c3..d978f7226206 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1865,7 +1865,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	sata_cmd.tag = cpu_to_le32(ccb_tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m |= ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m = cpu_to_le32((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9d20f8009b89..ec6b970e05a1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1882,7 +1882,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	sata_cmd.tag = cpu_to_le32(ccb_tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m_dad |= ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m_dad = cpu_to_le32(((0x1 << 7) | (0x5 << 9)));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
-- 
2.34.1



