Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68AB49A313
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385727AbiAXXtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:49:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45920 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454930AbiAXVeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:34:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC226B81257;
        Mon, 24 Jan 2022 21:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FBDC340E4;
        Mon, 24 Jan 2022 21:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060044;
        bh=PuPDInC1r/GLcY+Vi+sQObVdNBoB1cbEQ8SKVAlGUU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2UAReNXan+TmlkIrx4VZj6ZYo1NdeshC46cTh6x5ry9jtGg2X5XaRxHcTag4njXk
         Z6FbmBmsNK/bZbClHDmajnH4F3WZrJQ27h2zLp3WLKEx1xi5afJ3BXd++RQ9akBgKg
         Yms/TgNhwfs9dQl4DXdgLsDdoLOScyx3zo7LFJf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Sheng <wesley.sheng@microchip.com>,
        Kelvin Cao <kelvin.cao@microchip.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0820/1039] ntb_hw_switchtec: Fix bug with more than 32 partitions
Date:   Mon, 24 Jan 2022 19:43:29 +0100
Message-Id: <20220124184152.866189101@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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



