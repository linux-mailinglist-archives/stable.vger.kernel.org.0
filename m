Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6BD411AA0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbhITQuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243742AbhITQuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F23BA6124C;
        Mon, 20 Sep 2021 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156517;
        bh=e3yvkwGqp2Vy9cKkHKiS14Ci8X3/ufrLWKBheCxYQeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKYNoSTvN02wtOzs4Rf730dQ1064pUjEjkaC62cARXdsnylaqZR/rpMi7Cy7wZzIf
         O2JG4fy4qfYGzM2hxpaXl78tFvd73IDN2d5nRfPAq5NMFECYk1KylhpTUjPtAxfPmP
         CxTbem2awku68gFXJRppIf1QYsS+hMpZJpp02wbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Alan Stern <stern@rowland.harvard.edu>,
        Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 064/133] usb: ehci-orion: Handle errors of clk_prepare_enable() in probe
Date:   Mon, 20 Sep 2021 18:42:22 +0200
Message-Id: <20210920163914.744392555@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 4720f1bf4ee4a784d9ece05420ba33c9222a3004 ]

ehci_orion_drv_probe() did not account for possible errors of
clk_prepare_enable() that in particular could cause invocation of
clk_disable_unprepare() on clocks that were not prepared/enabled yet,
e.g. in remove or on handling errors of usb_add_hcd() in probe. Though,
there were several patches fixing different issues with clocks in this
driver, they did not solve this problem.

Add handling of errors of clk_prepare_enable() in ehci_orion_drv_probe()
to avoid calls of clk_disable_unprepare() without previous successful
invocation of clk_prepare_enable().

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: 8c869edaee07 ("ARM: Orion: EHCI: Add support for enabling clocks")
Co-developed-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Link: https://lore.kernel.org/r/20210825170902.11234-1-novikov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-orion.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index ee8d5faa0194..3eecf47d4e89 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -218,8 +218,11 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	 * the clock does not exists.
 	 */
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(priv->clk))
-		clk_prepare_enable(priv->clk);
+	if (!IS_ERR(priv->clk)) {
+		err = clk_prepare_enable(priv->clk);
+		if (err)
+			goto err_put_hcd;
+	}
 
 	priv->phy = devm_phy_optional_get(&pdev->dev, "usb");
 	if (IS_ERR(priv->phy)) {
@@ -280,6 +283,7 @@ err_phy_init:
 err_phy_get:
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
+err_put_hcd:
 	usb_put_hcd(hcd);
 err:
 	dev_err(&pdev->dev, "init %s fail, %d\n",
-- 
2.30.2



