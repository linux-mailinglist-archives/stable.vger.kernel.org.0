Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72FC635939
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbiKWKJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235989AbiKWKIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:08:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2426A56577
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4CD4B81EF1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C59C433D6;
        Wed, 23 Nov 2022 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197488;
        bh=QUh22GpSmKRc2joQsuFnzIGvTBQlEpNUPURdx8JPZsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENdXqxPGWSb3DXOt8IBICEf4OHJmDkJO/tQgq6q3wrNJPgaHv4dinyMQhO89Ua+X8
         17cCTrTmY4GijkPxdA+sZmZ5VJqsVojiKqvrsMGp+1wtC8SB8yt3UdvnvNX6z+1fm4
         EZjMHAi5OzO/YaUHTyFyjFws2t3ADkHxmvvKGJk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Norris <briannorris@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 6.0 268/314] firmware: coreboot: Register bus in module init
Date:   Wed, 23 Nov 2022 09:51:53 +0100
Message-Id: <20221123084637.668295230@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit 65946690ed8d972fdb91a74ee75ac0f0f0d68321 upstream.

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
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20221019180934.1.If29e167d8a4771b0bf4a39c89c6946ed764817b9@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/coreboot_table.c |   37 ++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 8 deletions(-)

--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -149,12 +149,8 @@ static int coreboot_table_probe(struct p
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
@@ -169,7 +165,6 @@ static int __cb_dev_unregister(struct de
 static int coreboot_table_remove(struct platform_device *pdev)
 {
 	bus_for_each_dev(&coreboot_bus_type, NULL, NULL, __cb_dev_unregister);
-	bus_unregister(&coreboot_bus_type);
 	return 0;
 }
 
@@ -199,6 +194,32 @@ static struct platform_driver coreboot_t
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


