Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4DB69B893
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 08:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBRH6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 02:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBRH6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 02:58:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEBB2387F
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 23:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8469260765
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 07:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A590C433D2;
        Sat, 18 Feb 2023 07:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676707120;
        bh=/ek8vlnhUJbRjKKeNcXPTb0A4XiJ3m6k3MOw4banD5A=;
        h=Subject:To:Cc:From:Date:From;
        b=CjTb9Ix1TmeqgTQFHPOxidXzmmKJPnVhfZh9Pj+A2proI9RGPjO65H9czGZ7PW4Sb
         C3EODkjTgo2ep2DbT5nAQfL1oEeigfv3LazoGN3E0ySwgUSyotyJG4xYS+baFHd6KK
         vlaZ5nF25XXCx7Tth8bxUPAMW4DdJ006dR8UbVNQ=
Subject: FAILED: patch "[PATCH] mmc: mmc_spi: fix error handling in mmc_spi_probe()" failed to apply to 4.19-stable tree
To:     yangyingliang@huawei.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 08:58:37 +0100
Message-ID: <167670711711818@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

cf4c9d2ac1e4 ("mmc: mmc_spi: fix error handling in mmc_spi_probe()")
1ae51603528c ("mmc: mmc_spi: Indentation fixes")
5716fb9bd9c6 ("mmc: spi: Convert to use GPIO descriptors")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cf4c9d2ac1e42c7d18b921bec39486896645b714 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Tue, 31 Jan 2023 09:38:35 +0800
Subject: [PATCH] mmc: mmc_spi: fix error handling in mmc_spi_probe()

If mmc_add_host() fails, it doesn't need to call mmc_remove_host(),
or it will cause null-ptr-deref, because of deleting a not added
device in mmc_remove_host().

To fix this, goto label 'fail_glue_init', if mmc_add_host() fails,
and change the label 'fail_add_host' to 'fail_gpiod_request'.

Fixes: 15a0580ced08 ("mmc_spi host driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230131013835.3564011-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 106dd204b1a7..cc333ad67cac 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1437,7 +1437,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 
 	status = mmc_add_host(mmc);
 	if (status != 0)
-		goto fail_add_host;
+		goto fail_glue_init;
 
 	/*
 	 * Index 0 is card detect
@@ -1445,7 +1445,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 	 */
 	status = mmc_gpiod_request_cd(mmc, NULL, 0, false, 1000);
 	if (status == -EPROBE_DEFER)
-		goto fail_add_host;
+		goto fail_gpiod_request;
 	if (!status) {
 		/*
 		 * The platform has a CD GPIO signal that may support
@@ -1460,7 +1460,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 	/* Index 1 is write protect/read only */
 	status = mmc_gpiod_request_ro(mmc, NULL, 1, 0);
 	if (status == -EPROBE_DEFER)
-		goto fail_add_host;
+		goto fail_gpiod_request;
 	if (!status)
 		has_ro = true;
 
@@ -1474,7 +1474,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 				? ", cd polling" : "");
 	return 0;
 
-fail_add_host:
+fail_gpiod_request:
 	mmc_remove_host(mmc);
 fail_glue_init:
 	mmc_spi_dma_free(host);

