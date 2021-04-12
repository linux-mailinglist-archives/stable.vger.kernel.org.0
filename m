Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9792835C0AD
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbhDLJPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239181AbhDLJI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:08:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FAE461019;
        Mon, 12 Apr 2021 09:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218266;
        bh=D28Ivy8chvDsGmeDTnEzdtp9wTeG/+JDNjP49oHAdqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CF8G/ZFuJZkcjVIiCY0acA7MKpbFOPw8QbVNnOzSQLJGS8cUESS9pKzg7kr8WrA4d
         hCuk+dkpILm3zssNnEnGczD0YHKFOFSDAr6x8yehnvQ+B1r8Ec7P5qRJXQZdF6yXqG
         ZSSNWktFX0aDzYlPnJxkli48pp2BU5iVA5+wjNRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Klaus Kudielka <klaus.kudielka@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, stable@kernel.org
Subject: [PATCH 5.11 088/210] i2c: turn recovery error on init to debug
Date:   Mon, 12 Apr 2021 10:39:53 +0200
Message-Id: <20210412084018.947625038@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit e409a6a3e0690efdef9b8a96197bc61ff117cfaf upstream.

In some configurations, recovery is optional. So, don't throw an error
when it is not used because e.g. pinctrl settings for recovery are not
provided. Reword the message and make it debug output.

Reported-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Tested-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -378,7 +378,7 @@ static int i2c_gpio_init_recovery(struct
 static int i2c_init_recovery(struct i2c_adapter *adap)
 {
 	struct i2c_bus_recovery_info *bri = adap->bus_recovery_info;
-	char *err_str;
+	char *err_str, *err_level = KERN_ERR;
 
 	if (!bri)
 		return 0;
@@ -387,7 +387,8 @@ static int i2c_init_recovery(struct i2c_
 		return -EPROBE_DEFER;
 
 	if (!bri->recover_bus) {
-		err_str = "no recover_bus() found";
+		err_str = "no suitable method provided";
+		err_level = KERN_DEBUG;
 		goto err;
 	}
 
@@ -414,7 +415,7 @@ static int i2c_init_recovery(struct i2c_
 
 	return 0;
  err:
-	dev_err(&adap->dev, "Not using recovery: %s\n", err_str);
+	dev_printk(err_level, &adap->dev, "Not using recovery: %s\n", err_str);
 	adap->bus_recovery_info = NULL;
 
 	return -EINVAL;


