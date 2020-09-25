Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727C72787C4
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgIYMuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgIYMuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8585B21D7A;
        Fri, 25 Sep 2020 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038210;
        bh=YuY2dyqTlfSpGoZ3bomvVJkXzVBNlPvz1BGia67lRrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwEaDE7iyXwJCa44V0MCvV6wK+2Vt0s7FbCUEbNMJx1sOU726J7wPVm4Stfy2jiTn
         aJRU8JWzyBisr2lP/grluC5u3Gn3NgrK5uIBxRXeM2oGoeYCvsMGcWGxWLeUD37VNT
         sflihzCMOz6XkhlQC89PzXtvxC/3sH5dsIFDjZY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 43/56] net: ethernet: ti: cpsw_new: fix suspend/resume
Date:   Fri, 25 Sep 2020 14:48:33 +0200
Message-Id: <20200925124734.312102071@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 5760d9acbe9514eec68eb70821d6fa5764f57042 ]

Add missed suspend/resume callbacks to properly restore networking after
suspend/resume cycle.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw_new.c |   53 +++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -17,6 +17,7 @@
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
 #include <linux/delay.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of.h>
@@ -2070,9 +2071,61 @@ static int cpsw_remove(struct platform_d
 	return 0;
 }
 
+static int __maybe_unused cpsw_suspend(struct device *dev)
+{
+	struct cpsw_common *cpsw = dev_get_drvdata(dev);
+	int i;
+
+	rtnl_lock();
+
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct net_device *ndev = cpsw->slaves[i].ndev;
+
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		cpsw_ndo_stop(ndev);
+	}
+
+	rtnl_unlock();
+
+	/* Select sleep pin state */
+	pinctrl_pm_select_sleep_state(dev);
+
+	return 0;
+}
+
+static int __maybe_unused cpsw_resume(struct device *dev)
+{
+	struct cpsw_common *cpsw = dev_get_drvdata(dev);
+	int i;
+
+	/* Select default pin state */
+	pinctrl_pm_select_default_state(dev);
+
+	/* shut up ASSERT_RTNL() warning in netif_set_real_num_tx/rx_queues */
+	rtnl_lock();
+
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct net_device *ndev = cpsw->slaves[i].ndev;
+
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		cpsw_ndo_open(ndev);
+	}
+
+	rtnl_unlock();
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(cpsw_pm_ops, cpsw_suspend, cpsw_resume);
+
 static struct platform_driver cpsw_driver = {
 	.driver = {
 		.name	 = "cpsw-switch",
+		.pm	 = &cpsw_pm_ops,
 		.of_match_table = cpsw_of_mtable,
 	},
 	.probe = cpsw_probe,


