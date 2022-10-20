Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582AD6054B1
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 03:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJTBLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 21:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiJTBLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 21:11:05 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809001645CF
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 18:11:04 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q1so17806702pgl.11
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 18:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S8Tpplgbg87qo0/g/zAMmb2z5RHSuiV5J2IUDMBNfEc=;
        b=G0hL1zoRGGsjihjXU32+8JsjEhOY2MncZzEc20xvMpburVkRNBdPHXW3Q3WqNbr86j
         n+oXDnwOm+QoLBvITuRWiejRu622H8Gw8M3O/w/I30IjGItXzFVMlKtGYvYxP8hcGC+X
         1EQ9kJfImQkOipmNnUODUFe2QuOUU8bqqp31w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8Tpplgbg87qo0/g/zAMmb2z5RHSuiV5J2IUDMBNfEc=;
        b=tlNr3KtACWWnhgtDLRpDjKc/Qe2zbV1BX41Uj98D0Asbj2uuh7GW/SkHX7JPyfCjW3
         OzJB53Px+vYn7U97dfjPSjd75ukjN4siDCJ6hUu5pzMisJDEwTA1Lv3JuwLVvGfu0jQN
         4Ufh6ygwwYVYdQ/eEYd8BYLgeAsDWy8fk6N1T860rR6PZA9Jz1z0VC6v52JLpJxIlc6f
         ldyhLj87CWTLbg15hxn4Go4TFwonDmCE6g/PCGr53NNoW16DJRzrQJPHALKcb9y1Zkeh
         dpJMvda45MAS+QG6suWdW36Zo/0sOMuR1/uCe4R9XwfdAnknl3PxQfgAx4cN1qYFyA8D
         P7Jw==
X-Gm-Message-State: ACrzQf0foHfTABzXuTWzZ8h/0BDoBp/spP2rgqBWGlwOl9/MqqxwI6Kw
        0z8AWj9bYS4Qtkd3V/uOWRX3ow8WZ4xtqA==
X-Google-Smtp-Source: AMsMyM4uymnmTN6r6gP9WHfrd/3VsQnKPB6jSs7M3NKJ/LxjDbjWWI4YM0eHxB1y39zawjtNR92KEA==
X-Received: by 2002:a63:54b:0:b0:464:8e6:11e7 with SMTP id 72-20020a63054b000000b0046408e611e7mr9745907pgf.212.1666228263924;
        Wed, 19 Oct 2022 18:11:03 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:57b7:1f0e:44d1:f252])
        by smtp.gmail.com with UTF8SMTPSA id bf1-20020a170902b90100b0017f7d7e95d3sm11330738plb.167.2022.10.19.18.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 18:11:03 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Benson Leung <bleung@chromium.org>,
        chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>,
        Julius Werner <jwerner@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] firmware: coreboot: Register bus in module init
Date:   Wed, 19 Oct 2022 18:10:53 -0700
Message-Id: <20221019180934.1.If29e167d8a4771b0bf4a39c89c6946ed764817b9@changeid>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The coreboot_table driver registers a coreboot bus while probing a
"coreboot_table" device representing the coreboot table memory region.
Probing this device (i.e., registering the bus) is a dependency for the
module_init() functions of any driver for this bus (e.g.,
memconsole-coreboot.c / memconsole_driver_init()).

With synchronous probe, this dependency works OK, as the link order in
the Makefile ensures coreboot_table_driver_init() (and thus,
coreboot_table_probe()) completes before a coreboot device driver tries
to add itself to the bus.

With asynchronous probe, however, coreboot_table_probe() may race with
memconsole_driver_init(), and so we're liable to hit one of these two:

1. coreboot_driver_register() eventually hits "[...] the bus was not
   initialized.", and the memconsole driver fails to register; or
2. coreboot_driver_register() gets past #1, but still races with
   bus_register() and hits some other undefined/crashing behavior (e.g.,
   in driver_find() [1])

We can resolve this by registering the bus in our initcall, and only
deferring "device" work (scanning the coreboot memory region and
creating sub-devices) to probe().

[1] Example failure, using 'driver_async_probe=*' kernel command line:

[    0.114217] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
...
[    0.114307] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc1 #63
[    0.114316] Hardware name: Google Scarlet (DT)
...
[    0.114488] Call trace:
[    0.114494]  _raw_spin_lock+0x34/0x60
[    0.114502]  kset_find_obj+0x28/0x84
[    0.114511]  driver_find+0x30/0x50
[    0.114520]  driver_register+0x64/0x10c
[    0.114528]  coreboot_driver_register+0x30/0x3c
[    0.114540]  memconsole_driver_init+0x24/0x30
[    0.114550]  do_one_initcall+0x154/0x2e0
[    0.114560]  do_initcall_level+0x134/0x160
[    0.114571]  do_initcalls+0x60/0xa0
[    0.114579]  do_basic_setup+0x28/0x34
[    0.114588]  kernel_init_freeable+0xf8/0x150
[    0.114596]  kernel_init+0x2c/0x12c
[    0.114607]  ret_from_fork+0x10/0x20
[    0.114624] Code: 5280002b 1100054a b900092a f9800011 (885ffc01)
[    0.114631] ---[ end trace 0000000000000000 ]---

Fixes: b81e3140e412 ("firmware: coreboot: Make bus registration symmetric")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
Currently, get_maintainers.pl tells me Greg should pick this up. But I
CC the chrome-platform list too, since it seems reasonable for Google
folks (probably ChromeOS folks are most active here?) to maintain
Google/Chrome drivers.

Let me know if y'all would like this official, and I'll push out a
MAINTAINERS patch.

 drivers/firmware/google/coreboot_table.c | 37 +++++++++++++++++++-----
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index c52bcaa9def6..9ca21feb9d45 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -149,12 +149,8 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = bus_register(&coreboot_bus_type);
-	if (!ret) {
-		ret = coreboot_table_populate(dev, ptr);
-		if (ret)
-			bus_unregister(&coreboot_bus_type);
-	}
+	ret = coreboot_table_populate(dev, ptr);
+
 	memunmap(ptr);
 
 	return ret;
@@ -169,7 +165,6 @@ static int __cb_dev_unregister(struct device *dev, void *dummy)
 static int coreboot_table_remove(struct platform_device *pdev)
 {
 	bus_for_each_dev(&coreboot_bus_type, NULL, NULL, __cb_dev_unregister);
-	bus_unregister(&coreboot_bus_type);
 	return 0;
 }
 
@@ -199,6 +194,32 @@ static struct platform_driver coreboot_table_driver = {
 		.of_match_table = of_match_ptr(coreboot_of_match),
 	},
 };
-module_platform_driver(coreboot_table_driver);
+
+static int __init coreboot_table_driver_init(void)
+{
+	int ret;
+
+	ret = bus_register(&coreboot_bus_type);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&coreboot_table_driver);
+	if (ret) {
+		bus_unregister(&coreboot_bus_type);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit coreboot_table_driver_exit(void)
+{
+	platform_driver_unregister(&coreboot_table_driver);
+	bus_unregister(&coreboot_bus_type);
+}
+
+module_init(coreboot_table_driver_init);
+module_exit(coreboot_table_driver_exit);
+
 MODULE_AUTHOR("Google, Inc.");
 MODULE_LICENSE("GPL");
-- 
2.38.0.413.g74048e4d9e-goog

