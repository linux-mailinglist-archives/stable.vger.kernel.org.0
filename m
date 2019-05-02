Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255FE11F1F
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfEBPZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbfEBPZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:25:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122C920449;
        Thu,  2 May 2019 15:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810709;
        bh=UQbqGMDCgBNAjQjZMA67nwKs/q9PTTAcMDrta56byeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8/lYz316SZdjO54Vj5sFCb++yzja3ZzDgJMU9mCWhyU/+0MVzLDNfbCn4QOnFROp
         TWDxSSjupGmgYH5cP9PVQtJvC2AwZ6ybq3v4vJg2mJeoi1SqHK0h5cIJFFSJcCUSjm
         wLvHCp2563wjLkhL5BSI3H/bkiFh6JsVZ2Ph1how=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 49/49] leds: pca9532: fix a potential NULL pointer dereference
Date:   Thu,  2 May 2019 17:21:26 +0200
Message-Id: <20190502143330.077380974@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0aab8e4df4702b31314a27ec4b0631dfad0fae0a ]

In case of_match_device cannot find a match, return -EINVAL to avoid
NULL pointer dereference.

Fixes: fa4191a609f2 ("leds: pca9532: Add device tree support")
Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/leds/leds-pca9532.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 7fea18b0c15d..7cb4d685a1f1 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -513,6 +513,7 @@ static int pca9532_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
 	int devid;
+	const struct of_device_id *of_id;
 	struct pca9532_data *data = i2c_get_clientdata(client);
 	struct pca9532_platform_data *pca9532_pdata =
 			dev_get_platdata(&client->dev);
@@ -528,8 +529,11 @@ static int pca9532_probe(struct i2c_client *client,
 			dev_err(&client->dev, "no platform data\n");
 			return -EINVAL;
 		}
-		devid = (int)(uintptr_t)of_match_device(
-			of_pca9532_leds_match, &client->dev)->data;
+		of_id = of_match_device(of_pca9532_leds_match,
+				&client->dev);
+		if (unlikely(!of_id))
+			return -EINVAL;
+		devid = (int)(uintptr_t) of_id->data;
 	} else {
 		devid = id->driver_data;
 	}
-- 
2.19.1



