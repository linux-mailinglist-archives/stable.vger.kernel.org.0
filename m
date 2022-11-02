Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C296159A1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiKBDQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKBDPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:15:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C44252B7
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:14:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 833CA617BA
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4B0C433C1;
        Wed,  2 Nov 2022 03:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358884;
        bh=/Z+YHNnbeD4SEsZiyX07o7y0ZkjDd+0wYpSLS2WNi/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNY/yvzysJL/+BroLS4mqKiKU4jtJfP9LJIQS9Y7V6I4x07nwM969q7fmwq+2k6EM
         iACmMPvH34RLx5/Wt7jY6Vc1LKvfCgBdfieA3eZaSz8zm/HMcny9IHkEfayehLV8FV
         IbAMIILWdGO7+/7TfMa+OZMd2l47LxGi54eKmEb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shreeya Patel <shreeya.patel@collabora.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 15/91] iio: light: tsl2583: Fix module unloading
Date:   Wed,  2 Nov 2022 03:32:58 +0100
Message-Id: <20221102022055.477336128@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreeya Patel <shreeya.patel@collabora.com>

commit 0dec4d2f2636b9e54d9d29f17afc7687c5407f78 upstream.

tsl2583 probe() uses devm_iio_device_register() and calling
iio_device_unregister() causes the unregister to occur twice. s
Switch to iio_device_register() instead of devm_iio_device_register()
in probe to avoid the device managed cleanup.

Fixes: 371894f5d1a0 ("iio: tsl2583: add runtime power management support")
Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
Link: https://lore.kernel.org/r/20220826122352.288438-1-shreeya.patel@collabora.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2583.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -856,7 +856,7 @@ static int tsl2583_probe(struct i2c_clie
 					 TSL2583_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&clientp->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret) {
 		dev_err(&clientp->dev, "%s: iio registration failed\n",
 			__func__);


