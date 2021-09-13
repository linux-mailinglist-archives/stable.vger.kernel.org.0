Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCD1408DED
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241286AbhIMNak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241301AbhIMNXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAA7D610D2;
        Mon, 13 Sep 2021 13:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539288;
        bh=E080KnkcT6EvMHaaLGSmtuIvM6PZcJ0ayg+8hQXC2Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uokiU4wUarkvxPzxJs8GTdpVJl9/YNkjgpjiCB3q3OnYkYnDsjopD0+t1j6vyzYHh
         7D5/LjKyMm210Rr97m/+qKMnb5tAiQ3UGTTmJwHwVHQr0YWTZCacw+5vw236u0NWuY
         vdiaDqRSGiDbOAjkLFzdC8EVpCuUrTodJcNzmDQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Alan Stern <stern@rowland.harvard.edu>,
        Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/144] usb: ehci-orion: Handle errors of clk_prepare_enable() in probe
Date:   Mon, 13 Sep 2021 15:14:53 +0200
Message-Id: <20210913131051.684777561@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index a319b1df3011..3626758b3e2a 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -264,8 +264,11 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
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
@@ -311,6 +314,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 err_dis_clk:
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
+err_put_hcd:
 	usb_put_hcd(hcd);
 err:
 	dev_err(&pdev->dev, "init %s fail, %d\n",
-- 
2.30.2



