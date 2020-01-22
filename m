Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4655D1455B1
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgAVNYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbgAVNYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:22 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 673902468A;
        Wed, 22 Jan 2020 13:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699462;
        bh=4EbajuRZsUnZKJ3OzlpYEySvgEwAm9G1z/wFKtlybhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivs2CYIfoU4z3YZBw5sksuR4UcZP85t5Kt++cSbB2dIVzuQwUGE/ds9vsIFtX7MuX
         6syzafveyIp//96I9YIFdYujV3LwC5pBrPDGhRVqB+v8ee2p1vtrl3OqY2kG2lHN9Z
         /2X/n1ICYutKGNauJYhjp6FxNJoQw4v68+r1M4Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.4 117/222] i2c: tegra: Properly disable runtime PM on drivers probe error
Date:   Wed, 22 Jan 2020 10:28:23 +0100
Message-Id: <20200122092842.109113952@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 24a49678f5e20f18006e71b90ac1531876b27eb1 upstream.

One of the recent Tegra I2C commits made a change that resumes runtime PM
during driver's probe, but it missed to put the RPM in a case of error.
Note that it's not correct to use pm_runtime_status_suspended because it
breaks RPM refcounting.

Fixes: 8ebf15e9c869 ("i2c: tegra: Move suspend handling to NOIRQ phase")
Cc: <stable@vger.kernel.org> # v5.4+
Tested-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-tegra.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1608,14 +1608,18 @@ static int tegra_i2c_probe(struct platfo
 	}
 
 	pm_runtime_enable(&pdev->dev);
-	if (!pm_runtime_enabled(&pdev->dev))
+	if (!pm_runtime_enabled(&pdev->dev)) {
 		ret = tegra_i2c_runtime_resume(&pdev->dev);
-	else
+		if (ret < 0) {
+			dev_err(&pdev->dev, "runtime resume failed\n");
+			goto unprepare_div_clk;
+		}
+	} else {
 		ret = pm_runtime_get_sync(i2c_dev->dev);
-
-	if (ret < 0) {
-		dev_err(&pdev->dev, "runtime resume failed\n");
-		goto unprepare_div_clk;
+		if (ret < 0) {
+			dev_err(&pdev->dev, "runtime resume failed\n");
+			goto disable_rpm;
+		}
 	}
 
 	if (i2c_dev->is_multimaster_mode) {
@@ -1623,7 +1627,7 @@ static int tegra_i2c_probe(struct platfo
 		if (ret < 0) {
 			dev_err(i2c_dev->dev, "div_clk enable failed %d\n",
 				ret);
-			goto disable_rpm;
+			goto put_rpm;
 		}
 	}
 
@@ -1671,11 +1675,16 @@ disable_div_clk:
 	if (i2c_dev->is_multimaster_mode)
 		clk_disable(i2c_dev->div_clk);
 
-disable_rpm:
-	pm_runtime_disable(&pdev->dev);
-	if (!pm_runtime_status_suspended(&pdev->dev))
+put_rpm:
+	if (pm_runtime_enabled(&pdev->dev))
+		pm_runtime_put_sync(&pdev->dev);
+	else
 		tegra_i2c_runtime_suspend(&pdev->dev);
 
+disable_rpm:
+	if (pm_runtime_enabled(&pdev->dev))
+		pm_runtime_disable(&pdev->dev);
+
 unprepare_div_clk:
 	clk_unprepare(i2c_dev->div_clk);
 


