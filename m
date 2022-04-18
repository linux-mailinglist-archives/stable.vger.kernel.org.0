Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0F95051F8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiDRMlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240750AbiDRMjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6241252BD;
        Mon, 18 Apr 2022 05:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BF58B80EC0;
        Mon, 18 Apr 2022 12:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C25C385A9;
        Mon, 18 Apr 2022 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285020;
        bh=ehPeAqHSgyACVdtGXHUmHK684ZF6aL+6T9g8dqRUzh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1gpzvr5itJ9Iw5Axo58j20X4g/mU7S9LouEdJJAhrGSBJR42fDrJ1vIvCVSGpMOS
         iYBMhBIz+oP5oY8QW0YbETn78SXeH8ClcuHVEdCT9VzultOwPze55XFje25y1uLSze
         9wh5GPWsX73tl+lvhwwL2hgm3jLVuf/BZf22P56A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/189] scsi: pm80xx: Enable upper inbound, outbound queues
Date:   Mon, 18 Apr 2022 14:11:40 +0200
Message-Id: <20220418121202.778740814@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajish Koshy <Ajish.Koshy@microchip.com>

[ Upstream commit bcd8a45223470e00b5f254018174d64a75db4bbe ]

Executing driver on servers with more than 32 CPUs were faced with command
timeouts. This is because we were not geting completions for commands
submitted on IQ32 - IQ63.

Set E64Q bit to enable upper inbound and outbound queues 32 to 63 in the
MPI main configuration table.

Added 500ms delay after successful MPI initialization as mentioned in
controller datasheet.

Link: https://lore.kernel.org/r/20220411064603.668448-3-Ajish.Koshy@microchip.com
Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index aa6f114be064..04746df26c6c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -765,6 +765,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
 
+	/* Enable higher IQs and OQs, 32 to 63, bit 16 */
+	if (pm8001_ha->max_q_num > 32)
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
+							1 << 16;
 	/* Disable end to end CRC checking */
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
 
@@ -1026,6 +1030,13 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 	if (0x0000 != gst_len_mpistate)
 		return -EBUSY;
 
+	/*
+	 *  As per controller datasheet, after successful MPI
+	 *  initialization minimum 500ms delay is required before
+	 *  issuing commands.
+	 */
+	msleep(500);
+
 	return 0;
 }
 
-- 
2.35.1



