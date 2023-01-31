Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14A668298A
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjAaJwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjAaJwr (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:52:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884DC4EC2
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B933B81AC8
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680D3C4339B;
        Tue, 31 Jan 2023 09:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158762;
        bh=2HI0FG44KjtwgenQrPXWBRHbTmy0OZuQaO2lehFvuOE=;
        h=Subject:To:From:Date:From;
        b=QkGqkUi8ki6UekPrUBjmQLGJ+lkc0c0fDtrsC/9L35vwgqU4dpkqyQQ4VjKS5tG+V
         zd84lenaok7N1PNZ5VggiH4eCjNwpOHok9AgRW9YvxEWvsOyE3V7XfxvR/+ZXIPhyg
         324eOgYvQeQYPoHypldKniegtcBbW2IhvdYI/nqE=
Subject: patch "iio: adc: berlin2-adc: Add missing of_node_put() in error path" added to char-misc-linus
To:     wangxiongfeng2@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:36 +0100
Message-ID: <167515875620151@kroah.com>
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


This is a note to let you know that I've just added the patch titled

    iio: adc: berlin2-adc: Add missing of_node_put() in error path

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cbd3a0153cd18a2cbef6bf3cf31bb406c3fc9f55 Mon Sep 17 00:00:00 2001
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Date: Tue, 29 Nov 2022 10:03:16 +0800
Subject: iio: adc: berlin2-adc: Add missing of_node_put() in error path

of_get_parent() will return a device_node pointer with refcount
incremented. We need to use of_node_put() on it when done. Add the
missing of_node_put() in the error path of berlin2_adc_probe();

Fixes: 70f1937911ca ("iio: adc: add support for Berlin")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221129020316.191731-1-wangxiongfeng2@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/berlin2-adc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/berlin2-adc.c b/drivers/iio/adc/berlin2-adc.c
index 3d2e8b4db61a..a4e7c7eff5ac 100644
--- a/drivers/iio/adc/berlin2-adc.c
+++ b/drivers/iio/adc/berlin2-adc.c
@@ -298,8 +298,10 @@ static int berlin2_adc_probe(struct platform_device *pdev)
 	int ret;
 
 	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*priv));
-	if (!indio_dev)
+	if (!indio_dev) {
+		of_node_put(parent_np);
 		return -ENOMEM;
+	}
 
 	priv = iio_priv(indio_dev);
 
-- 
2.39.1


