Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD80357C29
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 08:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhDHGLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 02:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhDHGLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 02:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E29C610CB;
        Thu,  8 Apr 2021 06:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617862271;
        bh=UExMJ4r8/ECjtQ9Lwxi6lZicLpdEygSujrBTAavCgVU=;
        h=Subject:To:From:Date:From;
        b=SuhWwPnHno5IGEIPTMo8WuzWbETUZK8kdQAW9LNmfnoDPBrzmnABtOjeN/iRynWEm
         84AWk4Ej5xvlWaceNbpAnmKDMATpc8d7aZoqzmq7Ru66u7IClUL+GVYKGrx4PAOvOR
         cU/4Jyymcw+ujca5ixcfrUZf8QaY+vSETQVMgbLM=
Subject: patch "phy: cadence: Sierra: Fix PHY power_on sequence" added to char-misc-next
To:     kishon@ti.com, p.zabel@pengutronix.de, stable@vger.kernel.org,
        vkoul@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 08 Apr 2021 08:08:08 +0200
Message-ID: <1617862088236125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    phy: cadence: Sierra: Fix PHY power_on sequence

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 5b4f5757f83be34d1428a1ffbb68d4a1966e9aae Mon Sep 17 00:00:00 2001
From: Kishon Vijay Abraham I <kishon@ti.com>
Date: Fri, 19 Mar 2021 18:11:16 +0530
Subject: phy: cadence: Sierra: Fix PHY power_on sequence

Commit 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
de-asserts PHY_RESET even before the configurations are loaded in
phy_init(). However PHY_RESET should be de-asserted only after
all the configurations has been initialized, instead of de-asserting
in probe. Fix it here.

Fixes: 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20210319124128.13308-2-kishon@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/phy/cadence/phy-cadence-sierra.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/cadence/phy-cadence-sierra.c b/drivers/phy/cadence/phy-cadence-sierra.c
index 26a0badabe38..19f32ae877b9 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -319,6 +319,12 @@ static int cdns_sierra_phy_on(struct phy *gphy)
 	u32 val;
 	int ret;
 
+	ret = reset_control_deassert(sp->phy_rst);
+	if (ret) {
+		dev_err(dev, "Failed to take the PHY out of reset\n");
+		return ret;
+	}
+
 	/* Take the PHY lane group out of reset */
 	ret = reset_control_deassert(ins->lnk_rst);
 	if (ret) {
@@ -616,7 +622,6 @@ static int cdns_sierra_phy_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	reset_control_deassert(sp->phy_rst);
 	return PTR_ERR_OR_ZERO(phy_provider);
 
 put_child:
-- 
2.31.1


