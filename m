Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E405411D64
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245250AbhITRUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244754AbhITRRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:17:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29BCD61A09;
        Mon, 20 Sep 2021 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157161;
        bh=24/E/U+6FDqECccTGlcsh9mtP/uLKfWS5SKnNvV4lgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv3FbS2TiEvKomqYOlas5TKxyN926CIWfiWJwZXrQ6MkJCuyeTAF8OfJFk5H3vPJ7
         M746QnIik3GmsHeeivm70ZX5u1v2K5t1TFLsts5ggzESTK1HNv0QRvUPfYHi2gO9vh
         A47vjoWobAhdxJGdcu20GlyQRjWRm6kQL9Y+GUlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Alan Stern <stern@rowland.harvard.edu>,
        Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/217] usb: ehci-orion: Handle errors of clk_prepare_enable() in probe
Date:   Mon, 20 Sep 2021 18:41:43 +0200
Message-Id: <20210920163927.413480588@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index 1aec87ec68df..753c73624fb6 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -253,8 +253,11 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
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
@@ -315,6 +318,7 @@ err_phy_init:
 err_phy_get:
 	if (!IS_ERR(priv->clk))
 		clk_disable_unprepare(priv->clk);
+err_put_hcd:
 	usb_put_hcd(hcd);
 err:
 	dev_err(&pdev->dev, "init %s fail, %d\n",
-- 
2.30.2



