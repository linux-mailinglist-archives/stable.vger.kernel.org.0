Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E261A571E
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgDKXUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730493AbgDKXNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71CE3217D8;
        Sat, 11 Apr 2020 23:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646817;
        bh=Vo2R7UWVX+9jbJ4AzHAMsXxjEvDPKDXQfxVDV9uWlAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdoSQ8VpuH3TdMIAE93zNf50FALrFwXeRUltPzPHAKEt0kV7uBXx4W4bRhU5pfMh3
         RkPDqJY8ZILrXaFqEfpDL23qvkQMGECMimBqem7Yt65r0PnJabV4on28pmSwZfZZg4
         1xecE0SP+zma4GVIE+AkjnUhwoUdXg6uQjb5I3dA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arindam Nath <arindam.nath@amd.com>, Jon Mason <jdmason@kudzu.us>,
        Sasha Levin <sashal@kernel.org>, linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 08/37] NTB: set peer_sta within event handler itself
Date:   Sat, 11 Apr 2020 19:12:57 -0400
Message-Id: <20200411231327.26550-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arindam Nath <arindam.nath@amd.com>

[ Upstream commit 2465b87ce36ea2dbd97e5fb58a0efd284c9f687e ]

amd_ack_smu() should only set the corresponding
bits into SMUACK register. Setting the bitmask
of peer_sta should be done within the event handler.
They are two different things, and so should be
handled differently and at different places.

Signed-off-by: Arindam Nath <arindam.nath@amd.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/amd/ntb_hw_amd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
index f0788aae05c9c..4cdfcff21efd1 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -493,8 +493,6 @@ static void amd_ack_smu(struct amd_ntb_dev *ndev, u32 bit)
 	reg = readl(mmio + AMD_SMUACK_OFFSET);
 	reg |= bit;
 	writel(reg, mmio + AMD_SMUACK_OFFSET);
-
-	ndev->peer_sta |= bit;
 }
 
 static void amd_handle_event(struct amd_ntb_dev *ndev, int vec)
@@ -512,9 +510,11 @@ static void amd_handle_event(struct amd_ntb_dev *ndev, int vec)
 	status &= AMD_EVENT_INTMASK;
 	switch (status) {
 	case AMD_PEER_FLUSH_EVENT:
+		ndev->peer_sta |= AMD_PEER_FLUSH_EVENT;
 		dev_info(dev, "Flush is done.\n");
 		break;
 	case AMD_PEER_RESET_EVENT:
+		ndev->peer_sta |= AMD_PEER_RESET_EVENT;
 		amd_ack_smu(ndev, AMD_PEER_RESET_EVENT);
 
 		/* link down first */
@@ -527,6 +527,7 @@ static void amd_handle_event(struct amd_ntb_dev *ndev, int vec)
 	case AMD_PEER_PMETO_EVENT:
 	case AMD_LINK_UP_EVENT:
 	case AMD_LINK_DOWN_EVENT:
+		ndev->peer_sta |= status;
 		amd_ack_smu(ndev, status);
 
 		/* link down */
@@ -540,6 +541,7 @@ static void amd_handle_event(struct amd_ntb_dev *ndev, int vec)
 		if (status & 0x1)
 			dev_info(dev, "Wakeup is done.\n");
 
+		ndev->peer_sta |= AMD_PEER_D0_EVENT;
 		amd_ack_smu(ndev, AMD_PEER_D0_EVENT);
 
 		/* start a timer to poll link status */
-- 
2.20.1

