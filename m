Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D94E501359
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345002AbiDNNws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344850AbiDNNoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2260393CB;
        Thu, 14 Apr 2022 06:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02F1161D68;
        Thu, 14 Apr 2022 13:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182A1C385A5;
        Thu, 14 Apr 2022 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943626;
        bh=LOb+r/VmivW4/DQVZ0Vvs64MuNmePu62WrNeN9K0ZPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZecT+2kuFDrbck6NUB4bxNtN0cIF+zLQnJ+u4cvcyf3EjIqGU20btQjQXzQpXznqJ
         2Q1cm5lfJ04e5+GRno9rGpW8NsySN8mfVlE+v92Rf4UKB2A2C6oP7fYG5WEfPmG+66
         m/HeS47CIemmtvTo61j+pZjzDmp2W5qou9KF2hdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/475] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Thu, 14 Apr 2022 15:09:28 +0200
Message-Id: <20220414110900.254693110@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 68a8217032d0..7dbf0289e350 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1828,7 +1828,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	sata_cmd.tag = cpu_to_le32(ccb_tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m |= ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m = cpu_to_le32((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 161bf4760eac..5bf897188f4f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1516,7 +1516,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	sata_cmd.tag = cpu_to_le32(ccb_tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m_dad |= ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m_dad = cpu_to_le32(((0x1 << 7) | (0x5 << 9)));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
-- 
2.34.1



