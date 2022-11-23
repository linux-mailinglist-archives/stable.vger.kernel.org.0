Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B943B635491
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbiKWJIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiKWJIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:08:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DBB1659C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:08:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFE25B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44480C433D6;
        Wed, 23 Nov 2022 09:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194480;
        bh=DTqj4f3MFNEmt6NouOqFEfOk9mcw3yIgeLKT1w9SodY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKEXX8BLAhIotnaDPMBsbDNXJfpEKv0qInQ5msrHyeN79s3Jvbv79CfXTQoNRG27V
         2LD6ywY7z7J2XYjVN4ZYwnigo+wI0Ulo4y7g+sKgogdPPPxM+Lf8pX911kRmb23S6H
         cT5K2yc3JB3YVELdoV61CJ+97MnBmzLM0z4A3hto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 090/114] iio: trigger: sysfs: fix possible memory leak in iio_sysfs_trig_init()
Date:   Wed, 23 Nov 2022 09:51:17 +0100
Message-Id: <20221123084555.428085772@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

commit efa17e90e1711bdb084e3954fa44afb6647331c0 upstream.

dev_set_name() allocates memory for name, it need be freed
when device_add() fails, call put_device() to give up the
reference that hold in device_initialize(), so that it can
be freed in kobject_cleanup() when the refcount hit to 0.

Fault injection test can trigger this:

unreferenced object 0xffff8e8340a7b4c0 (size 32):
  comm "modprobe", pid 243, jiffies 4294678145 (age 48.845s)
  hex dump (first 32 bytes):
    69 69 6f 5f 73 79 73 66 73 5f 74 72 69 67 67 65  iio_sysfs_trigge
    72 00 a7 40 83 8e ff ff 00 86 13 c4 f6 ee ff ff  r..@............
  backtrace:
    [<0000000074999de8>] __kmem_cache_alloc_node+0x1e9/0x360
    [<00000000497fd30b>] __kmalloc_node_track_caller+0x44/0x1a0
    [<000000003636c520>] kstrdup+0x2d/0x60
    [<0000000032f84da2>] kobject_set_name_vargs+0x1e/0x90
    [<0000000092efe493>] dev_set_name+0x4e/0x70

Fixes: 1f785681a870 ("staging:iio:trigger sysfs userspace trigger rework.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221022074212.1386424-1-yangyingliang@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/trigger/iio-trig-sysfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -211,9 +211,13 @@ static int iio_sysfs_trigger_remove(int
 
 static int __init iio_sysfs_trig_init(void)
 {
+	int ret;
 	device_initialize(&iio_sysfs_trig_dev);
 	dev_set_name(&iio_sysfs_trig_dev, "iio_sysfs_trigger");
-	return device_add(&iio_sysfs_trig_dev);
+	ret = device_add(&iio_sysfs_trig_dev);
+	if (ret)
+		put_device(&iio_sysfs_trig_dev);
+	return ret;
 }
 module_init(iio_sysfs_trig_init);
 


