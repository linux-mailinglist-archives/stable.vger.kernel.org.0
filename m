Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645572F3142
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbhALM5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389788AbhALM5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B226623133;
        Tue, 12 Jan 2021 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456164;
        bh=eCWatQ31FO3AivDi5FAeTDE1Kbblb++Bkw5IzvuubZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLvrkylc/0A09kXvjLBIKUuNEvxJaSRCxr6WBQW/Br41HVU05Sf+Sr1mxLGyc+R3s
         3YU1JTbrSEHPVkzMrSQWX9NntbGbeHEq5Q1upQlaj/La46WXBLZlHAdBS3LJESBj2j
         VesxK6Fys8unx9LSqlcPOyBzsxmOGhCMMNrtQJ/HeKbEkwz31uUpysbmvglByOSIWX
         0v7zLg9htkiJvVlyXGgcMZ03vyD1rTUywbNYHXlWwW18DfvrRnbQ3AAqUAkzcLZcEa
         3dpTE8iKsgTcbYSJGGkNvglPyh/qB4bTj0edqhPqet9l6qHAWIGGJgBn+drxO4p39N
         dlES85iVc3vLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 22/51] staging: spmi: hisi-spmi-controller: Fix some error handling paths
Date:   Tue, 12 Jan 2021 07:55:04 -0500
Message-Id: <20210112125534.70280-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

