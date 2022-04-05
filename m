Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B566A4F37EF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359733AbiDELUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349081AbiDEJtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4DDA9953;
        Tue,  5 Apr 2022 02:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56727B81B14;
        Tue,  5 Apr 2022 09:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B29C385A1;
        Tue,  5 Apr 2022 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151618;
        bh=iozh1jjXmFTMe0fEZb1Fvf9I3bEgIB4Xe0asgzvx9Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k66Wn74ZJtYxGkw4lu6qRVfJtTDnxrMAJ5sXr5gtPqcOlegLuALLMYMFCUtpOoaoV
         OSWx7NdOG/IohTSmMLLQsphFEtjOzw1wpPTLhBaEh8GhUNcXuqJTSIZeDxI9XbY41U
         iwj8LPx5tnDkbs0LgAwJws4p6Lda9AxFQWJgSuQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 480/913] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Tue,  5 Apr 2022 09:25:42 +0200
Message-Id: <20220405070354.244068830@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 5e6b23da4157..1e1630a1a97c 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1860,7 +1860,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	sata_cmd.tag = cpu_to_le32(ccb_tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m |= ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m = cpu_to_le32((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 3056f3615ab8..11887ac8ad0f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1881,7 +1881,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	sata_cmd.tag = cpu_to_le32(ccb_tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m_dad |= ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m_dad = cpu_to_le32(((0x1 << 7) | (0x5 << 9)));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
-- 
2.34.1



