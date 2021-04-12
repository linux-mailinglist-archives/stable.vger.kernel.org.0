Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D5335BE20
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbhDLI5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238883AbhDLIzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 181A06137C;
        Mon, 12 Apr 2021 08:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217616;
        bh=D28Ivy8chvDsGmeDTnEzdtp9wTeG/+JDNjP49oHAdqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7zi2EaYLq6cSvATfaO0+850zNbJ8eKgQFFFhy8X54oPW5ergfxiFVgQ/06DOWFC6
         mc7ITDF1wpDKPayzTunCfmiOnv+qANK+tJ9NhBQYb3NQEDmuTsl44TWtWKDgNHP0Ll
         n2f/tbSo2YDZ+3VZXTJH39OpKOAOMf6UEGE3werE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Klaus Kudielka <klaus.kudielka@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, stable@kernel.org
Subject: [PATCH 5.10 081/188] i2c: turn recovery error on init to debug
Date:   Mon, 12 Apr 2021 10:39:55 +0200
Message-Id: <20210412084016.337371761@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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


