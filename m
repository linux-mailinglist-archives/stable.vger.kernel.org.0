Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB535BD27
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237659AbhDLIsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237560AbhDLIq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8A6161289;
        Mon, 12 Apr 2021 08:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217201;
        bh=hABI2uo/CPejXo+88JY7OEPZdfIZ5wH0XIEDIKZ00X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReWJ/CgSaG+t8JsCu4AixETrXMd7YDMgED+odw3U3icdkOrmPzoV2kVTTO+ywXBM6
         7ScXSwpNjS1iKWhEFYNELanueF43RiEo0eZBdRqyelVkAmAcL09fVsP8rC1zeQ8vfQ
         vxO4GJVACE+oUZlc3+8yjDrl2iapK3c0L4HglUu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Klaus Kudielka <klaus.kudielka@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, stable@kernel.org
Subject: [PATCH 5.4 040/111] i2c: turn recovery error on init to debug
Date:   Mon, 12 Apr 2021 10:40:18 +0200
Message-Id: <20210412084005.589645783@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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
@@ -254,13 +254,14 @@ EXPORT_SYMBOL_GPL(i2c_recover_bus);
 static void i2c_init_recovery(struct i2c_adapter *adap)
 {
 	struct i2c_bus_recovery_info *bri = adap->bus_recovery_info;
-	char *err_str;
+	char *err_str, *err_level = KERN_ERR;
 
 	if (!bri)
 		return;
 
 	if (!bri->recover_bus) {
-		err_str = "no recover_bus() found";
+		err_str = "no suitable method provided";
+		err_level = KERN_DEBUG;
 		goto err;
 	}
 
@@ -290,7 +291,7 @@ static void i2c_init_recovery(struct i2c
 
 	return;
  err:
-	dev_err(&adap->dev, "Not using recovery: %s\n", err_str);
+	dev_printk(err_level, &adap->dev, "Not using recovery: %s\n", err_str);
 	adap->bus_recovery_info = NULL;
 }
 


