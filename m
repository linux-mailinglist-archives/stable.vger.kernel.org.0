Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79712516520
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 18:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348925AbiEAQUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 12:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbiEAQUN (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 1 May 2022 12:20:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6599E1118
        for <Stable@vger.kernel.org>; Sun,  1 May 2022 09:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F030860F32
        for <Stable@vger.kernel.org>; Sun,  1 May 2022 16:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4A2C385AA;
        Sun,  1 May 2022 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651421806;
        bh=mmWarpoDmksDkL6JlzoHitXTFNV6FTuzzNCnxD+k89g=;
        h=Subject:To:Cc:From:Date:From;
        b=oCZywopfOxIgEiL1LoymR2hA4Q48YcvzglzCrI1yTRq21bJgxgNdTe7yiRG5fvbq1
         LMLWoi0yVOprmV1qaj/WAbcZb19Dx4Wd3ZRXG2bg5X6h9o4Nbi6lBqCV1eIql/eztW
         6DvMKVt9fs/nbHki7gsIkfXjLnrNJQ9GpWe9I+SQ=
Subject: FAILED: patch "[PATCH] iio:proximity:sx_common: Fix device property parsing on DT" failed to apply to 5.17-stable tree
To:     swboyd@chromium.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, gwendal@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 18:16:38 +0200
Message-ID: <165142179815630@kroah.com>
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 74a53a959028e5f28e3c0e9445a876e5c8da147c Mon Sep 17 00:00:00 2001
From: Stephen Boyd <swboyd@chromium.org>
Date: Thu, 31 Mar 2022 14:04:25 -0700
Subject: [PATCH] iio:proximity:sx_common: Fix device property parsing on DT
 systems

After commit 7a3605bef878 ("iio: sx9310: Support ACPI property") we
started using the 'indio_dev->dev' to extract device properties for
various register settings in sx9310_get_default_reg(). This broke DT
based systems because dev_fwnode() used in the device_property*() APIs
can't find an 'of_node'. That's because the 'indio_dev->dev.of_node'
pointer isn't set until iio_device_register() is called. Set the pointer
earlier, next to where the ACPI companion is set, so that the device
property APIs work on DT systems.

Cc: Gwendal Grignou <gwendal@chromium.org>
Fixes: 7a3605bef878 ("iio: sx9310: Support ACPI property")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20220331210425.3908278-1-swboyd@chromium.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/proximity/sx_common.c b/drivers/iio/proximity/sx_common.c
index a7c07316a0a9..8ad814d96b7e 100644
--- a/drivers/iio/proximity/sx_common.c
+++ b/drivers/iio/proximity/sx_common.c
@@ -521,6 +521,7 @@ int sx_common_probe(struct i2c_client *client,
 		return dev_err_probe(dev, ret, "error reading WHOAMI\n");
 
 	ACPI_COMPANION_SET(&indio_dev->dev, ACPI_COMPANION(dev));
+	indio_dev->dev.of_node = client->dev.of_node;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
 	indio_dev->channels =  data->chip_info->iio_channels;

