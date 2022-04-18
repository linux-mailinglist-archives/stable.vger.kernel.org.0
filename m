Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8F5504E86
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiDRJtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbiDRJty (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:49:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED09165A2
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C977611A1
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5967EC385A1;
        Mon, 18 Apr 2022 09:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650275235;
        bh=UkKNThrfBPcD6ZmCW/NSpAGo9kxXwYb6CvYu47rkwn8=;
        h=Subject:To:Cc:From:Date:From;
        b=yPN42YKLUeQMpPG6uwX1hloH2VsTQ6ekzgXAVtHnw1iy1CUcSbjECl9dxZ/132tsl
         Tu6Qr7TD/47yeAnp1s5NZdKJmGi4pO/2sre6K21FC93WIFCDhNkdkcpxrIvpKc8a2g
         4EV3P/bqpSo+VMjX6v1RoPHtqygAq/mQCX8575oU=
Subject: FAILED: patch "[PATCH] i2c: dev: check return value when calling dev_set_name()" failed to apply to 5.10-stable tree
To:     andriy.shevchenko@linux.intel.com, wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:46:58 +0200
Message-ID: <1650275218115105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 993eb48fa199b5f476df8204e652eff63dd19361 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 11 Apr 2022 21:07:51 +0300
Subject: [PATCH] i2c: dev: check return value when calling dev_set_name()

If dev_set_name() fails, the dev_name() is null, check the return
value of dev_set_name() to avoid the null-ptr-deref.

Fixes: 1413ef638aba ("i2c: dev: Fix the race between the release of i2c_dev and cdev")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index cf5d049342ea..6fd2b6718b08 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -668,16 +668,21 @@ static int i2cdev_attach_adapter(struct device *dev, void *dummy)
 	i2c_dev->dev.class = i2c_dev_class;
 	i2c_dev->dev.parent = &adap->dev;
 	i2c_dev->dev.release = i2cdev_dev_release;
-	dev_set_name(&i2c_dev->dev, "i2c-%d", adap->nr);
+
+	res = dev_set_name(&i2c_dev->dev, "i2c-%d", adap->nr);
+	if (res)
+		goto err_put_i2c_dev;
 
 	res = cdev_device_add(&i2c_dev->cdev, &i2c_dev->dev);
-	if (res) {
-		put_i2c_dev(i2c_dev, false);
-		return res;
-	}
+	if (res)
+		goto err_put_i2c_dev;
 
 	pr_debug("adapter [%s] registered as minor %d\n", adap->name, adap->nr);
 	return 0;
+
+err_put_i2c_dev:
+	put_i2c_dev(i2c_dev, false);
+	return res;
 }
 
 static int i2cdev_detach_adapter(struct device *dev, void *dummy)

