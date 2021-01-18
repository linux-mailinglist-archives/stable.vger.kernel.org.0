Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E6E2FA2C9
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392894AbhAROTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390554AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C25622E03;
        Mon, 18 Jan 2021 11:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970257;
        bh=eCWatQ31FO3AivDi5FAeTDE1Kbblb++Bkw5IzvuubZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3xCohP6V1uQQor0gBwvX6aeqgDDHvYQo/WkUtMDStcUQovMfApGnHRZ3ZGUkbBUz
         SeM0h5KokwVbtpIfbYTwequUO6ylZYG4gpMKAb/7kP3CQvhCNqU0MM5zEVCHAp6KSD
         pTEl+3arTJg9Kfr9KwqDIAUnNaZ2BRZIKRP1XyDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/152] staging: spmi: hisi-spmi-controller: Fix some error handling paths
Date:   Mon, 18 Jan 2021 12:34:07 +0100
Message-Id: <20210118113356.237500672@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 12b38ea040b3bb2a30eb9cd488376df5be7ea81f ]

IN the probe function, if an error occurs after calling
'spmi_controller_alloc()', it must be undone by a corresponding
'spmi_controller_put() call.

In the remove function, use 'spmi_controller_put(ctrl)' instead of
'kfree(ctrl)'.

While a it fix an error message
(s/spmi_add_controller/spmi_controller_add/)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201213151105.137731-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/hikey9xx/hisi-spmi-controller.c   | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hikey9xx/hisi-spmi-controller.c b/drivers/staging/hikey9xx/hisi-spmi-controller.c
index f831c43f4783f..29f226503668d 100644
--- a/drivers/staging/hikey9xx/hisi-spmi-controller.c
+++ b/drivers/staging/hikey9xx/hisi-spmi-controller.c
@@ -278,21 +278,24 @@ static int spmi_controller_probe(struct platform_device *pdev)
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!iores) {
 		dev_err(&pdev->dev, "can not get resource!\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_put_controller;
 	}
 
 	spmi_controller->base = devm_ioremap(&pdev->dev, iores->start,
 					     resource_size(iores));
 	if (!spmi_controller->base) {
 		dev_err(&pdev->dev, "can not remap base addr!\n");
-		return -EADDRNOTAVAIL;
+		ret = -EADDRNOTAVAIL;
+		goto err_put_controller;
 	}
 
 	ret = of_property_read_u32(pdev->dev.of_node, "spmi-channel",
 				   &spmi_controller->channel);
 	if (ret) {
 		dev_err(&pdev->dev, "can not get channel\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_put_controller;
 	}
 
 	platform_set_drvdata(pdev, spmi_controller);
@@ -309,9 +312,15 @@ static int spmi_controller_probe(struct platform_device *pdev)
 	ctrl->write_cmd = spmi_write_cmd;
 
 	ret = spmi_controller_add(ctrl);
-	if (ret)
-		dev_err(&pdev->dev, "spmi_add_controller failed with error %d!\n", ret);
+	if (ret) {
+		dev_err(&pdev->dev, "spmi_controller_add failed with error %d!\n", ret);
+		goto err_put_controller;
+	}
+
+	return 0;
 
+err_put_controller:
+	spmi_controller_put(ctrl);
 	return ret;
 }
 
@@ -320,7 +329,7 @@ static int spmi_del_controller(struct platform_device *pdev)
 	struct spmi_controller *ctrl = platform_get_drvdata(pdev);
 
 	spmi_controller_remove(ctrl);
-	kfree(ctrl);
+	spmi_controller_put(ctrl);
 	return 0;
 }
 
-- 
2.27.0



