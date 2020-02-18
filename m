Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECCB1631CB
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgBRUCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728994AbgBRUCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA20924673;
        Tue, 18 Feb 2020 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056164;
        bh=AxIFDZl3bXYO08f8cH7vwWk4gl2vtpQa9tmD9xZTEkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyTeGvVSsGl6IgXJUt9QwLBd0Rdjj3Usxxp/OZRm0cha7g+VyUdj31d2R5Ujw4Lb3
         bmDczcNMP+lUOsuJAdsKgsIUcqVtw9RQXcife/K7YR2imcf+41KUkgLqPuF2jO8MCS
         6neupaFntrK3d4Sx+opJS4GJnXEbnED6B9mpy7YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.5 59/80] Input: ili210x - fix return value of is_visible function
Date:   Tue, 18 Feb 2020 20:55:20 +0100
Message-Id: <20200218190437.752831132@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

commit fbd1ec000213c8b457dd4fb15b6de9ba02ec5482 upstream.

The is_visible function expects the permissions associated with an
attribute of the sysfs group or 0 if an attribute is not visible.

Change the code to return the attribute permissions when the attribute
should be visible which resolves the warning:

  Attribute calibrate: Invalid permissions 01

Fixes: cc12ba1872c6 ("Input: ili210x - optionally show calibrate sysfs attribute")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Sven Van Asbroeck <TheSven73@gmail.com>
Link: https://lore.kernel.org/r/20200209145628.649409-1-luca@z3ntu.xyz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/ili210x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -321,7 +321,7 @@ static umode_t ili210x_calibrate_visible
 	struct i2c_client *client = to_i2c_client(dev);
 	struct ili210x *priv = i2c_get_clientdata(client);
 
-	return priv->chip->has_calibrate_reg;
+	return priv->chip->has_calibrate_reg ? attr->mode : 0;
 }
 
 static const struct attribute_group ili210x_attr_group = {


