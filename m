Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFF9658462
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbiL1Q5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbiL1Q4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E557F1CFCA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:51:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A1961568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9450EC433EF;
        Wed, 28 Dec 2022 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246309;
        bh=d93DpPv2go7FgopcNy33Qrh+lFbxT7wWSPRDvxvRWiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhh14oPyl4UlncA9HcxT/KMIw1InhQ7D2tr6aVwAUoLdj0ERM30glRbHqgQu1hrtv
         MNimmggROMCfc6DBhO2hS9HfLWyDw4dnE0Al4d5YPdMN55g6CP2PWADTiWF/huytOf
         mVKrhClNfxynr3XStkALGDYuts0VAvzN0KhGmStk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 1047/1073] iio: fix memory leak in iio_device_register_eventset()
Date:   Wed, 28 Dec 2022 15:43:55 +0100
Message-Id: <20221228144356.642816504@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

commit 86fdd15e10e404e70ecb2a3bff24d70356d42b36 upstream.

When iio_device_register_sysfs_group() returns failed,
iio_device_register_eventset() needs to free attrs array.

Otherwise, kmemleak would scan & report memory leak as below:

unreferenced object 0xffff88810a1cc3c0 (size 32):
  comm "100-i2c-vcnl302", pid 728, jiffies 4295052307 (age 156.027s)
  backtrace:
    __kmalloc+0x46/0x1b0
    iio_device_register_eventset at drivers/iio/industrialio-event.c:541
    __iio_device_register at drivers/iio/industrialio-core.c:1959
    __devm_iio_device_register at drivers/iio/industrialio-core.c:2040

Fixes: 32f171724e5c ("iio: core: rework iio device group creation")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20221115023712.3726854-1-zengheng4@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-event.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -550,7 +550,7 @@ int iio_device_register_eventset(struct
 
 	ret = iio_device_register_sysfs_group(indio_dev, &ev_int->group);
 	if (ret)
-		goto error_free_setup_event_lines;
+		goto error_free_group_attrs;
 
 	ev_int->ioctl_handler.ioctl = iio_event_ioctl;
 	iio_device_ioctl_handler_register(&iio_dev_opaque->indio_dev,
@@ -558,6 +558,8 @@ int iio_device_register_eventset(struct
 
 	return 0;
 
+error_free_group_attrs:
+	kfree(ev_int->group.attrs);
 error_free_setup_event_lines:
 	iio_free_chan_devattr_list(&ev_int->dev_attr_list);
 	kfree(ev_int);


