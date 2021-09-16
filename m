Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC18A40E7E8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344463AbhIPRnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354030AbhIPRiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E916154B;
        Thu, 16 Sep 2021 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811024;
        bh=L+Zrw3R7HuZQRklNozrduxknMAPTxCggBqZfIcjfZ9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNsikHktXcwVAcYi7UQtg93PF7hs+ilypLwgPDueNiUv2EnNSErrDkdfhhLFqmjgH
         hXleTLDzowMVInQSPo2IJqhFCe4l61qeoPepAMcyiV6ZEKEohtR57Shaq1cSJeQWFC
         QPlaphyoaVxTvLH0yRzkX7z0IYfTDJrJxq1N+au0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 355/432] usb: musb: musb_dsps: request_irq() after initializing musb
Date:   Thu, 16 Sep 2021 18:01:44 +0200
Message-Id: <20210916155822.844615645@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit 7c75bde329d7e2a93cf86a5c15c61f96f1446cdc ]

If IRQ occurs between calling  dsps_setup_optional_vbus_irq()
and  dsps_create_musb_pdev(), then null pointer dereference occurs
since glue->musb wasn't initialized yet.

The patch puts initializing of neccesery data before registration
of the interrupt handler.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Link: https://lore.kernel.org/r/20210819163323.17714-1-lutovinova@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/musb_dsps.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 5892f3ce0cdc..ce9fc46c9266 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -890,23 +890,22 @@ static int dsps_probe(struct platform_device *pdev)
 	if (!glue->usbss_base)
 		return -ENXIO;
 
-	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
-		ret = dsps_setup_optional_vbus_irq(pdev, glue);
-		if (ret)
-			goto err_iounmap;
-	}
-
 	platform_set_drvdata(pdev, glue);
 	pm_runtime_enable(&pdev->dev);
 	ret = dsps_create_musb_pdev(glue, pdev);
 	if (ret)
 		goto err;
 
+	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
+		ret = dsps_setup_optional_vbus_irq(pdev, glue);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 
 err:
 	pm_runtime_disable(&pdev->dev);
-err_iounmap:
 	iounmap(glue->usbss_base);
 	return ret;
 }
-- 
2.30.2



