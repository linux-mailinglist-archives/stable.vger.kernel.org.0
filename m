Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9F54CF6DC
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiCGJnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241035AbiCGJlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBB16D4F9;
        Mon,  7 Mar 2022 01:39:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2E2D611D5;
        Mon,  7 Mar 2022 09:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A01C340E9;
        Mon,  7 Mar 2022 09:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645966;
        bh=PuPDInC1r/GLcY+Vi+sQObVdNBoB1cbEQ8SKVAlGUU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnZD1aCBBo4aEGUnDWd7ZfJ0djITBUMWgdOV+KNvyajLbhnyyM+uXQSffXBM69CKM
         kHZcAZ2cwAJaBM16FvrJnn0eBgKIOyQtIFBvtwBLSVtlkgXZI8anUJFjFlSP8tDCAx
         Zn5if8l+E8iAdZHuoGBsy8Kkk68Y5wG5HDtrd/tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Sheng <wesley.sheng@microchip.com>,
        Kelvin Cao <kelvin.cao@microchip.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/262] ntb_hw_switchtec: Fix bug with more than 32 partitions
Date:   Mon,  7 Mar 2022 10:17:09 +0100
Message-Id: <20220307091704.882023540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Sheng <wesley.sheng@microchip.com>

[ Upstream commit 7ff351c86b6b258f387502ab2c9b9d04f82c1c3d ]

Switchtec could support as mush as 48 partitions, but ffs & fls are
for 32 bit argument, in case of partition index larger than 31, the
current code could not parse the peer partition index correctly.
Change to the 64 bit version __ffs64 & fls64 accordingly to fix this
bug.

Fixes: 3df54c870f52 ("ntb_hw_switchtec: Allow using Switchtec NTB in multi-partition setups")
Signed-off-by: Wesley Sheng <wesley.sheng@microchip.com>
Signed-off-by: Kelvin Cao <kelvin.cao@microchip.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index 6603c77c0a848..ec9cb6c81edae 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -840,7 +840,6 @@ static int switchtec_ntb_init_sndev(struct switchtec_ntb *sndev)
 	u64 tpart_vec;
 	int self;
 	u64 part_map;
-	int bit;
 
 	sndev->ntb.pdev = sndev->stdev->pdev;
 	sndev->ntb.topo = NTB_TOPO_SWITCH;
@@ -861,29 +860,28 @@ static int switchtec_ntb_init_sndev(struct switchtec_ntb *sndev)
 	part_map = ioread64(&sndev->mmio_ntb->ep_map);
 	part_map &= ~(1 << sndev->self_partition);
 
-	if (!ffs(tpart_vec)) {
+	if (!tpart_vec) {
 		if (sndev->stdev->partition_count != 2) {
 			dev_err(&sndev->stdev->dev,
 				"ntb target partition not defined\n");
 			return -ENODEV;
 		}
 
-		bit = ffs(part_map);
-		if (!bit) {
+		if (!part_map) {
 			dev_err(&sndev->stdev->dev,
 				"peer partition is not NT partition\n");
 			return -ENODEV;
 		}
 
-		sndev->peer_partition = bit - 1;
+		sndev->peer_partition = __ffs64(part_map);
 	} else {
-		if (ffs(tpart_vec) != fls(tpart_vec)) {
+		if (__ffs64(tpart_vec) != (fls64(tpart_vec) - 1)) {
 			dev_err(&sndev->stdev->dev,
 				"ntb driver only supports 1 pair of 1-1 ntb mapping\n");
 			return -ENODEV;
 		}
 
-		sndev->peer_partition = ffs(tpart_vec) - 1;
+		sndev->peer_partition = __ffs64(tpart_vec);
 		if (!(part_map & (1ULL << sndev->peer_partition))) {
 			dev_err(&sndev->stdev->dev,
 				"ntb target partition is not NT partition\n");
-- 
2.34.1



