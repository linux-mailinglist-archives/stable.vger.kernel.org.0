Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDE963DF3E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiK3SpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiK3So4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B4613E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B74A6B81CA9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18834C433C1;
        Wed, 30 Nov 2022 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833892;
        bh=JGizSkAcdCgwaI9LSxRfzZ2HHPebeBQd1bgb1VyHLdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awxKfgP+sPJfplxlSGPO/ayeN9TT1vWy9mASkJiA43I0mbdX/PhIk2Lkn5xrouNMY
         SRTwLrlK4Zx5Fmd2abjqkmrSjRtlAVd/QDI/OHCES2+Yhe9xI0FodELNzb80M0au5S
         wFv4C81cpinKA5kk+CHA9rui45c4TjgP10aU7zmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 025/289] scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC
Date:   Wed, 30 Nov 2022 19:20:10 +0100
Message-Id: <20221130180544.704616101@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit ecb8c2580d37dbb641451049376d80c8afaa387f ]

>From ZBC-1:

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
index 95f940f5c996..7346098c1c68 100644
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



