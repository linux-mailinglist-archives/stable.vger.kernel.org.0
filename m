Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4881C141A
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgEANfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730286AbgEANfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:35:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D44DD216FD;
        Fri,  1 May 2020 13:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340141;
        bh=q71kAljo8EsKoOPHLSzW1gYD6pwZKfe8hSDVn1gDtrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JBnQfS6b0ZyXxnLu47eVKZADEwCQNfpsxqnFky5PqWaVzi5BAJ4XHmVq9lcTJyCQ
         HnDBWNnFKiwr3jRIx9Zguiseh3V+UQr04yIcrnM55LZKfn8aTY1LFcjvoaxfiFvc+H
         4am0fWR9V5JO3UVhhcJ/rOSE8lqjVsjtvqWf5ON4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 110/117] hwmon: (jc42) Fix name to have no illegal characters
Date:   Fri,  1 May 2020 15:22:26 +0200
Message-Id: <20200501131558.235440648@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit c843b382e61b5f28a3d917712c69a344f632387c ]

The jc42 driver passes I2C client's name as hwmon device name. In case
of device tree probed devices this ends up being part of the compatible
string, "jc-42.4-temp". This name contains hyphens and the hwmon core
doesn't like this:

jc42 2-0018: hwmon: 'jc-42.4-temp' is not a valid name attribute, please fix

This changes the name to "jc42" which doesn't have any illegal
characters.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20200417092853.31206-1-s.hauer@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/jc42.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index e5234f953a6d1..b6e5aaa54963d 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -527,7 +527,7 @@ static int jc42_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 	data->config = config;
 
-	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
+	hwmon_dev = devm_hwmon_device_register_with_info(dev, "jc42",
 							 data, &jc42_chip_info,
 							 NULL);
 	return PTR_ERR_OR_ZERO(hwmon_dev);
-- 
2.20.1



