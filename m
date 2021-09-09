Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A061140525C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353514AbhIIMnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352566AbhIIMi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:38:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99F2D61BB6;
        Thu,  9 Sep 2021 11:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188476;
        bh=L+Zrw3R7HuZQRklNozrduxknMAPTxCggBqZfIcjfZ9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvM3cohXPwEzKhGk7zBbhoLhULhGxoaSocpVqvodedVRR7GAmbbo1k4K2tdkbrstm
         wYX/rOucb1XCUql77lDwiB/VqDQrL1K+b0qrDQFRI2unvUXTK2esePur2eZ75gTj7+
         6NkEPImyFA98+gdhFvHpYgs/YFZgTVGqeXFazuBJHcx4B6cD8XUDMic764gCmN1nz5
         IYCxKS7vKDFUg2cJS52auBVyDAzdMwwmQAILhOtX13endibG7zDMJfpsEj8TjZVQCH
         3tZxzTGCcApSOa1fB0aGBX9oyPFInAaWoQUN28WZ9FbkjBderVQZY+K4Tchj1zj/oF
         IuwzG6ReAv+aQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadezda Lutovinova <lutovinova@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 153/176] usb: musb: musb_dsps: request_irq() after initializing musb
Date:   Thu,  9 Sep 2021 07:50:55 -0400
Message-Id: <20210909115118.146181-153-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

