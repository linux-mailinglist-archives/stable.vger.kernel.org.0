Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EFE26EBC4
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgIRCHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgIRCGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95DF82388E;
        Fri, 18 Sep 2020 02:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394800;
        bh=4QEX68LXmMj1dBXpx9bC+bzvAKqkEWyUNcAaYFv82EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rngAtvDbZ3YWBYPbNN6wKKpAzCEspLDrzVKw3Vgju7fBJS9xHdAPpini/fbGaLG+u
         JPu46DjCzNDFUZrYxrJFwVe+Hxz+AhGx6arMubhDzg6b3VugWTQnEte+DwGqXKlo5S
         IYFkySsFNGoPMHfTP1wjeDDqhix0uq+3s0yNG3E0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tang Bin <tangbin@cmss.chinamobile.com>,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 269/330] ipmi:bt-bmc: Fix error handling and status check
Date:   Thu, 17 Sep 2020 22:00:09 -0400
Message-Id: <20200918020110.2063155-269-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 49826937e7c7917140515aaf10c17bedcc4acaad ]

If the function platform_get_irq() failed, the negative value
returned will not be detected here. So fix error handling in
bt_bmc_config_irq(). And in the function bt_bmc_probe(),
when get irq failed, it will print error message. So use
platform_get_irq_optional() to simplify code. Finally in the
function bt_bmc_remove() should make the right status check
if get irq failed.

Signed-off-by: Shengju Zhang <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Message-Id: <20200505102906.17196-1-tangbin@cmss.chinamobile.com>
[Also set bt_bmc->irq to a negative value if devm_request_irq() fails.]
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/bt-bmc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/ipmi/bt-bmc.c b/drivers/char/ipmi/bt-bmc.c
index 40b9927c072c9..89a8faa9b6cfa 100644
--- a/drivers/char/ipmi/bt-bmc.c
+++ b/drivers/char/ipmi/bt-bmc.c
@@ -399,15 +399,15 @@ static int bt_bmc_config_irq(struct bt_bmc *bt_bmc,
 	struct device *dev = &pdev->dev;
 	int rc;
 
-	bt_bmc->irq = platform_get_irq(pdev, 0);
-	if (!bt_bmc->irq)
-		return -ENODEV;
+	bt_bmc->irq = platform_get_irq_optional(pdev, 0);
+	if (bt_bmc->irq < 0)
+		return bt_bmc->irq;
 
 	rc = devm_request_irq(dev, bt_bmc->irq, bt_bmc_irq, IRQF_SHARED,
 			      DEVICE_NAME, bt_bmc);
 	if (rc < 0) {
 		dev_warn(dev, "Unable to request IRQ %d\n", bt_bmc->irq);
-		bt_bmc->irq = 0;
+		bt_bmc->irq = rc;
 		return rc;
 	}
 
@@ -479,7 +479,7 @@ static int bt_bmc_probe(struct platform_device *pdev)
 
 	bt_bmc_config_irq(bt_bmc, pdev);
 
-	if (bt_bmc->irq) {
+	if (bt_bmc->irq >= 0) {
 		dev_info(dev, "Using IRQ %d\n", bt_bmc->irq);
 	} else {
 		dev_info(dev, "No IRQ; using timer\n");
@@ -505,7 +505,7 @@ static int bt_bmc_remove(struct platform_device *pdev)
 	struct bt_bmc *bt_bmc = dev_get_drvdata(&pdev->dev);
 
 	misc_deregister(&bt_bmc->miscdev);
-	if (!bt_bmc->irq)
+	if (bt_bmc->irq < 0)
 		del_timer_sync(&bt_bmc->poll_timer);
 	return 0;
 }
-- 
2.25.1

