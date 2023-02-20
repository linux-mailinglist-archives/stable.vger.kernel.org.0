Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592C269CD72
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjBTNtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjBTNtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:49:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832361CF47
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:49:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6655760CEB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA10C433EF;
        Mon, 20 Feb 2023 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900951;
        bh=OKz2nLCJ0BZpV+X9fcCZEheSDM+KLG8wtY5yRhthFgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LER/mqZIxDKhRkpD0qE5QDe9B9fLI9/B0313KSnVEFSH3OZ3demZ3b0Mz2G6WZ7rr
         7SDTU0NfO5zgf57TUy6l4mT+9vm9HoEkFBAH40GHyqUU11odx3s0OjQs3xQN40oEO/
         JBwVXj7O/ZZfz9gpmySK0ye/tz2zvE5bfu1jgNdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 129/156] mmc: sdio: fix possible resource leaks in some error paths
Date:   Mon, 20 Feb 2023 14:36:13 +0100
Message-Id: <20230220133607.976904753@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 605d9fb9556f8f5fb4566f4df1480f280f308ded upstream.

If sdio_add_func() or sdio_init_func() fails, sdio_remove_func() can
not release the resources, because the sdio function is not presented
in these two cases, it won't call of_node_put() or put_device().

To fix these leaks, make sdio_func_present() only control whether
device_del() needs to be called or not, then always call of_node_put()
and put_device().

In error case in sdio_init_func(), the reference of 'card->dev' is
not get, to avoid redundant put in sdio_free_func_cis(), move the
get_device() to sdio_alloc_func() and put_device() to sdio_release_func(),
it can keep the get/put function be balanced.

Without this patch, while doing fault inject test, it can get the
following leak reports, after this fix, the leak is gone.

unreferenced object 0xffff888112514000 (size 2048):
  comm "kworker/3:2", pid 65, jiffies 4294741614 (age 124.774s)
  hex dump (first 32 bytes):
    00 e0 6f 12 81 88 ff ff 60 58 8d 06 81 88 ff ff  ..o.....`X......
    10 40 51 12 81 88 ff ff 10 40 51 12 81 88 ff ff  .@Q......@Q.....
  backtrace:
    [<000000009e5931da>] kmalloc_trace+0x21/0x110
    [<000000002f839ccb>] mmc_alloc_card+0x38/0xb0 [mmc_core]
    [<0000000004adcbf6>] mmc_sdio_init_card+0xde/0x170 [mmc_core]
    [<000000007538fea0>] mmc_attach_sdio+0xcb/0x1b0 [mmc_core]
    [<00000000d4fdeba7>] mmc_rescan+0x54a/0x640 [mmc_core]

unreferenced object 0xffff888112511000 (size 2048):
  comm "kworker/3:2", pid 65, jiffies 4294741623 (age 124.766s)
  hex dump (first 32 bytes):
    00 40 51 12 81 88 ff ff e0 58 8d 06 81 88 ff ff  .@Q......X......
    10 10 51 12 81 88 ff ff 10 10 51 12 81 88 ff ff  ..Q.......Q.....
  backtrace:
    [<000000009e5931da>] kmalloc_trace+0x21/0x110
    [<00000000fcbe706c>] sdio_alloc_func+0x35/0x100 [mmc_core]
    [<00000000c68f4b50>] mmc_attach_sdio.cold.18+0xb1/0x395 [mmc_core]
    [<00000000d4fdeba7>] mmc_rescan+0x54a/0x640 [mmc_core]

Fixes: 3d10a1ba0d37 ("sdio: fix reference counting in sdio_remove_func()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230130125808.3471254-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio_bus.c |   17 ++++++++++++++---
 drivers/mmc/core/sdio_cis.c |   12 ------------
 2 files changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -269,6 +269,12 @@ static void sdio_release_func(struct dev
 	if (!(func->card->quirks & MMC_QUIRK_NONSTD_SDIO))
 		sdio_free_func_cis(func);
 
+	/*
+	 * We have now removed the link to the tuples in the
+	 * card structure, so remove the reference.
+	 */
+	put_device(&func->card->dev);
+
 	kfree(func->info);
 	kfree(func->tmpbuf);
 	kfree(func);
@@ -299,6 +305,12 @@ struct sdio_func *sdio_alloc_func(struct
 
 	device_initialize(&func->dev);
 
+	/*
+	 * We may link to tuples in the card structure,
+	 * we need make sure we have a reference to it.
+	 */
+	get_device(&func->card->dev);
+
 	func->dev.parent = &card->dev;
 	func->dev.bus = &sdio_bus_type;
 	func->dev.release = sdio_release_func;
@@ -352,10 +364,9 @@ int sdio_add_func(struct sdio_func *func
  */
 void sdio_remove_func(struct sdio_func *func)
 {
-	if (!sdio_func_present(func))
-		return;
+	if (sdio_func_present(func))
+		device_del(&func->dev);
 
-	device_del(&func->dev);
 	of_node_put(func->dev.of_node);
 	put_device(&func->dev);
 }
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -384,12 +384,6 @@ int sdio_read_func_cis(struct sdio_func
 		return ret;
 
 	/*
-	 * Since we've linked to tuples in the card structure,
-	 * we must make sure we have a reference to it.
-	 */
-	get_device(&func->card->dev);
-
-	/*
 	 * Vendor/device id is optional for function CIS, so
 	 * copy it from the card structure as needed.
 	 */
@@ -414,11 +408,5 @@ void sdio_free_func_cis(struct sdio_func
 	}
 
 	func->tuples = NULL;
-
-	/*
-	 * We have now removed the link to the tuples in the
-	 * card structure, so remove the reference.
-	 */
-	put_device(&func->card->dev);
 }
 


