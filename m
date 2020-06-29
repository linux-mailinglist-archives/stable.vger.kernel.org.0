Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257E420E717
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404629AbgF2Vxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbgF2Sfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03FF92417E;
        Mon, 29 Jun 2020 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443949;
        bh=sO2xBJT9t+KEVHko+8omTjreYu5x0FMEHORvarc5ou0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yz63zDOCutQh4/WGEzsPmK8qNDvLW9u8DZRifDflkHDD/bUMA/cmocsgdTalXfk5q
         QjkbGsPXZkHuDyg2exaCvHVIop2NbwGA+FU7rUNJTLUffzlGVu8RE1a2TEzfAa/ODl
         8ACfG+8RMPdis6dzUfesaqsxCWpBL/2wowTC2lFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dejin Zheng <zhengdejin5@gmail.com>,
        Kevin Groeneveld <kgroeneveld@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 051/265] net: phy: smsc: fix printing too many logs
Date:   Mon, 29 Jun 2020 11:14:44 -0400
Message-Id: <20200629151818.2493727-52-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit 6d61f483f148b856d47a6c96d5d84054d5a9f849 ]

Commit 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout()
to simplify the code") will print a lot of logs as follows when Ethernet
cable is not connected:

[    4.473105] SMSC LAN8710/LAN8720 2188000.ethernet-1:00: lan87xx_read_status failed: -110

When wait 640 ms for check ENERGYON bit, the timeout should not be
regarded as an actual error and an error message also should not be
printed. due to a hardware bug in LAN87XX device, it leads to unstable
detection of plugging in Ethernet cable when LAN87xx is in Energy Detect
Power-Down mode. the workaround for it involves, when the link is down,
and at each read_status() call:

- disable EDPD mode, forcing the PHY out of low-power mode
- waiting 640ms to see if we have any energy detected from the media
- re-enable entry to EDPD mode

This is presumably enough to allow the PHY to notice that a cable is
connected, and resume normal operations to negotiate with the partner.
The problem is that when no media is detected, the 640ms wait times
out and this commit was modified to prints an error message. it is an
inappropriate conversion by used phy_read_poll_timeout() to introduce
this bug. so fix this issue by use read_poll_timeout() to replace
phy_read_poll_timeout().

Fixes: 7ae7ad2f11ef47 ("net: phy: smsc: use phy_read_poll_timeout() to simplify the code")
Reported-by: Kevin Groeneveld <kgroeneveld@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/smsc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 93da7d3d0954c..74568ae161253 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -122,10 +122,13 @@ static int lan87xx_read_status(struct phy_device *phydev)
 		if (rc < 0)
 			return rc;
 
-		/* Wait max 640 ms to detect energy */
-		phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS, rc,
-				      rc & MII_LAN83C185_ENERGYON, 10000,
-				      640000, true);
+		/* Wait max 640 ms to detect energy and the timeout is not
+		 * an actual error.
+		 */
+		read_poll_timeout(phy_read, rc,
+				  rc & MII_LAN83C185_ENERGYON || rc < 0,
+				  10000, 640000, true, phydev,
+				  MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
 			return rc;
 
-- 
2.25.1

