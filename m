Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98459630980
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiKSCNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiKSCMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848A55802C;
        Fri, 18 Nov 2022 18:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A121B8267C;
        Sat, 19 Nov 2022 02:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13103C433D6;
        Sat, 19 Nov 2022 02:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823931;
        bh=DYSTxLNVpkZd++m8BU3LVX3nRD7yMJsqKfyXsa/sbkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBCqKTJ/w4s0wMFzA/N2tQ+Mdbyr8TF4/EWmgqTO3HlilumU9ceDOefL0chqxuB10
         wi3izj8M8eMh9mkI/eQBWjERcTz2jsfGg6mml2POSi2DGhgUfe2oe24ECBH8+HTVt8
         DTrYQvSTY/kQiewfeMjrnrCa4DhH5XUz2E+zywtFWZBtRK1sldnF5GYCzAMEAs7P17
         iRqnfds9e/1Nfb5WEAOjZcoka8wFaea1twhnKlOawAg06zBpU6Z9TtSfKS/CzgoxiC
         +h6OdSF6GIz2TbcsIxgkbOSLe3Hn5j7IClG++1kZux0IsZLqd8YumupoOGWqIgqYbO
         ibYfLPazQfgtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 24/44] scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC
Date:   Fri, 18 Nov 2022 21:11:04 -0500
Message-Id: <20221119021124.1773699-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit ecb8c2580d37dbb641451049376d80c8afaa387f ]

From ZBC-1:

 - RC BASIS = 0: The RETURNED LOGICAL BLOCK ADDRESS field indicates the
   highest LBA of a contiguous range of zones that are not sequential write
   required zones starting with the first zone.

 - RC BASIS = 1: The RETURNED LOGICAL BLOCK ADDRESS field indicates the LBA
   of the last logical block on the logical unit.

The current scsi_debug READ CAPACITY response does not comply with the
above if there are one or more sequential write required zones. SCSI
initiators need a way to retrieve the largest valid LBA from SCSI
devices. Reporting the largest valid LBA if there are one or more
sequential zones requires to set the RC BASIS field in the READ CAPACITY
response to one. Hence this patch.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20221102193248.3177608-1-bvanassche@acm.org
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b8a76b89f85a..d474b3da8914 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1899,6 +1899,13 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 			arr[14] |= 0x40;
 	}
 
+	/*
+	 * Since the scsi_debug READ CAPACITY implementation always reports the
+	 * total disk capacity, set RC BASIS = 1 for host-managed ZBC devices.
+	 */
+	if (devip->zmodel == BLK_ZONED_HM)
+		arr[12] |= 1 << 4;
+
 	arr[15] = sdebug_lowest_aligned & 0xff;
 
 	if (have_dif_prot) {
-- 
2.35.1

