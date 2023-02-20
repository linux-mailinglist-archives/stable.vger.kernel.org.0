Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5280B69CE86
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjBTN77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbjBTN7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D161EFE3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C52EDB80D4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DE0C4339B;
        Mon, 20 Feb 2023 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901546;
        bh=rEmNlg9Pb5gEY0lFuUhUUM+5ORgqsXHqwJoigvhaVvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ct9zSd+YjwYVIZS8h1VBfk6KoiQZXBSdtwEYqR69qfzveKr90X+ABPLVDyQs2a3TK
         PVmkD4p0FOTvnFVVjJow83KSRVTpGYCg1bl74SRbjTQoggncHAorR8zf1roVfezY6x
         QKb2XrvJI4ibFnZqkJEM1IqhOrIRhJSnJqsxPJMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 058/118] mmc: mmc_spi: fix error handling in mmc_spi_probe()
Date:   Mon, 20 Feb 2023 14:36:14 +0100
Message-Id: <20230220133602.767385745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

commit cf4c9d2ac1e42c7d18b921bec39486896645b714 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmc_spi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1437,7 +1437,7 @@ static int mmc_spi_probe(struct spi_devi
 
 	status = mmc_add_host(mmc);
 	if (status != 0)
-		goto fail_add_host;
+		goto fail_glue_init;
 
 	/*
 	 * Index 0 is card detect
@@ -1445,7 +1445,7 @@ static int mmc_spi_probe(struct spi_devi
 	 */
 	status = mmc_gpiod_request_cd(mmc, NULL, 0, false, 1000);
 	if (status == -EPROBE_DEFER)
-		goto fail_add_host;
+		goto fail_gpiod_request;
 	if (!status) {
 		/*
 		 * The platform has a CD GPIO signal that may support
@@ -1460,7 +1460,7 @@ static int mmc_spi_probe(struct spi_devi
 	/* Index 1 is write protect/read only */
 	status = mmc_gpiod_request_ro(mmc, NULL, 1, 0);
 	if (status == -EPROBE_DEFER)
-		goto fail_add_host;
+		goto fail_gpiod_request;
 	if (!status)
 		has_ro = true;
 
@@ -1474,7 +1474,7 @@ static int mmc_spi_probe(struct spi_devi
 				? ", cd polling" : "");
 	return 0;
 
-fail_add_host:
+fail_gpiod_request:
 	mmc_remove_host(mmc);
 fail_glue_init:
 	mmc_spi_dma_free(host);


