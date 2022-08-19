Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61C0599F23
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352276AbiHSQVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352405AbiHSQUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568AAB5A47;
        Fri, 19 Aug 2022 09:01:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 773AF61644;
        Fri, 19 Aug 2022 16:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57728C433C1;
        Fri, 19 Aug 2022 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924904;
        bh=2BxS2z9fUVXK8JFR2a1gYx1ckx/r6/L7iaArnJXsr20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o998yzDJmdi5oAR93vUEzdBtZtWqepvIaUyl+eDURFKysX753l9JW4OUOI/iCBR7l
         8feRryuFb8nV3IPimkQUtlXmaPevTzO0V4eohndyT5j34DIR0zkeTokzDsY/v3+iiu
         SbIwj5IyDZ+hTdpueAyObdmeJF9yYen87mxTjL1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Mike McGowen <mike.mcgowen@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/545] scsi: smartpqi: Fix DMA direction for RAID requests
Date:   Fri, 19 Aug 2022 17:41:31 +0200
Message-Id: <20220819153843.713394651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>

[ Upstream commit 69695aeaa6621bc49cdd7a8e5a8d1042461e496e ]

Correct a SOP READ and WRITE DMA flags for some requests.

This update corrects DMA direction issues with SCSI commands removed from
the controller's internal lookup table.

Currently, SCSI READ BLOCK LIMITS (0x5) was removed from the controller
lookup table and exposed a DMA direction flag issue.

SCSI READ BLOCK LIMITS was recently removed from our controller lookup
table so the controller uses the respective IU flag field to set the DMA
data direction. Since the DMA direction is incorrect the FW never completes
the request causing a hang.

Some SCSI commands which use SCSI READ BLOCK LIMITS

      * sg_map
      * mt -f /dev/stX status

After updating controller firmware, users may notice their tape units
failing. This patch resolves the issue.

Also, the AIO path DMA direction is correct.

The DMA direction flag is a day-one bug with no reported BZ.

Fixes: 6c223761eb54 ("smartpqi: initial commit of Microsemi smartpqi driver")
Link: https://lore.kernel.org/r/165730605618.177165.9054223644512926624.stgit@brunhilda
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index de73ade70c24..fcff35e20a4a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4997,10 +4997,10 @@ static int pqi_raid_submit_scsi_cmd_with_io_request(
 	}
 
 	switch (scmd->sc_data_direction) {
-	case DMA_TO_DEVICE:
+	case DMA_FROM_DEVICE:
 		request->data_direction = SOP_READ_FLAG;
 		break;
-	case DMA_FROM_DEVICE:
+	case DMA_TO_DEVICE:
 		request->data_direction = SOP_WRITE_FLAG;
 		break;
 	case DMA_NONE:
-- 
2.35.1



