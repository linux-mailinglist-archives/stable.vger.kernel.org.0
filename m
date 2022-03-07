Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721D34CF84B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbiCGJwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240295AbiCGJus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB6E74DDC;
        Mon,  7 Mar 2022 01:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D7360F62;
        Mon,  7 Mar 2022 09:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4688AC36AE5;
        Mon,  7 Mar 2022 09:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646259;
        bh=VfEIdLUz6bH6L/JeAHwklQGWBPhkXIBpMuMn3x4wokQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8ZABe0ZSzjE5t86wqkCZ1jLSorT47nHhXUwzEU75X6oWMYeA+/SrtGM3VAf7BuCo
         4Pwq8Q7jW5cisRumP3r/MaDlTp0NF1VmplHdvISDF6HmkaAFf+qWMBpylFsI3ScfUS
         BFC0NvlHlOz0AUlnI0RECduZ04yLCIsPKokE087Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Poeschel <poeschel@lemonage.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 5.15 186/262] auxdisplay: lcd2s: Fix memory leak in ->remove()
Date:   Mon,  7 Mar 2022 10:18:50 +0100
Message-Id: <20220307091707.695840636@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 898c0a15425a5bcaa8d44bd436eae5afd2483796 upstream.

Once allocated the struct lcd2s_data is never freed.
Fix the memory leak by switching to devm_kzalloc().

Fixes: 8c9108d014c5 ("auxdisplay: add a driver for lcd2s character display")
Cc: Lars Poeschel <poeschel@lemonage.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/lcd2s.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/auxdisplay/lcd2s.c
+++ b/drivers/auxdisplay/lcd2s.c
@@ -298,6 +298,10 @@ static int lcd2s_i2c_probe(struct i2c_cl
 			I2C_FUNC_SMBUS_WRITE_BLOCK_DATA))
 		return -EIO;
 
+	lcd2s = devm_kzalloc(&i2c->dev, sizeof(*lcd2s), GFP_KERNEL);
+	if (!lcd2s)
+		return -ENOMEM;
+
 	/* Test, if the display is responding */
 	err = lcd2s_i2c_smbus_write_byte(i2c, LCD2S_CMD_DISPLAY_OFF);
 	if (err < 0)
@@ -307,12 +311,6 @@ static int lcd2s_i2c_probe(struct i2c_cl
 	if (!lcd)
 		return -ENOMEM;
 
-	lcd2s = kzalloc(sizeof(struct lcd2s_data), GFP_KERNEL);
-	if (!lcd2s) {
-		err = -ENOMEM;
-		goto fail1;
-	}
-
 	lcd->drvdata = lcd2s;
 	lcd2s->i2c = i2c;
 	lcd2s->charlcd = lcd;
@@ -321,24 +319,22 @@ static int lcd2s_i2c_probe(struct i2c_cl
 	err = device_property_read_u32(&i2c->dev, "display-height-chars",
 			&lcd->height);
 	if (err)
-		goto fail2;
+		goto fail1;
 
 	err = device_property_read_u32(&i2c->dev, "display-width-chars",
 			&lcd->width);
 	if (err)
-		goto fail2;
+		goto fail1;
 
 	lcd->ops = &lcd2s_ops;
 
 	err = charlcd_register(lcd2s->charlcd);
 	if (err)
-		goto fail2;
+		goto fail1;
 
 	i2c_set_clientdata(i2c, lcd2s);
 	return 0;
 
-fail2:
-	kfree(lcd2s);
 fail1:
 	kfree(lcd);
 	return err;


