Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591084F24E6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiDEHmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiDEHl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649D34C422;
        Tue,  5 Apr 2022 00:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAD816123C;
        Tue,  5 Apr 2022 07:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A06C340EE;
        Tue,  5 Apr 2022 07:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144395;
        bh=5cicE8wXFGrywxq8t02W8D1aDh83JQelIgtx4cJIqeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H49HIMLWDfo97xsDEWfgT4lwq70Q+outzUeVkFlm25W4yWzIpu7f1mdUOrx31U4a6
         5Qg7BoUCzPWZ9hK8zd61Hq9yhueCtpKKwwyvsKi6SjXTZiPiusH/c2xk+ILAaeK/Mo
         ZjVAKryQrJlWTdMsfA1HKZZy71R4Ogt1L2QFMRyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Martin Kepplinger <martink@posteo.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.17 0030/1126] iio: accel: mma8452: use the correct logic to get mma8452_data
Date:   Tue,  5 Apr 2022 09:12:57 +0200
Message-Id: <20220405070408.437343816@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

commit c87b7b12f48db86ac9909894f4dc0107d7df6375 upstream.

The original logic to get mma8452_data is wrong, the *dev point to
the device belong to iio_dev. we can't use this dev to find the
correct i2c_client. The original logic happen to work because it
finally use dev->driver_data to get iio_dev. Here use the API
to_i2c_client() is wrong and make reader confuse. To correct the
logic, it should be like this

  struct mma8452_data *data = iio_priv(dev_get_drvdata(dev));

But after commit 8b7651f25962 ("iio: iio_device_alloc(): Remove
unnecessary self drvdata"), the upper logic also can't work.
When try to show the avialable scale in userspace, will meet kernel
dump, kernel handle NULL pointer dereference.

So use dev_to_iio_dev() to correct the logic.

Dual fixes tags as the second reflects when the bug was exposed, whilst
the first reflects when the original bug was introduced.

Fixes: c3cdd6e48e35 ("iio: mma8452: refactor for seperating chip specific data")
Fixes: 8b7651f25962 ("iio: iio_device_alloc(): Remove unnecessary self drvdata")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Martin Kepplinger <martink@posteo.de>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1645497741-5402-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/mma8452.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -379,8 +379,8 @@ static ssize_t mma8452_show_scale_avail(
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct mma8452_data *data = iio_priv(i2c_get_clientdata(
-					     to_i2c_client(dev)));
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct mma8452_data *data = iio_priv(indio_dev);
 
 	return mma8452_show_int_plus_micros(buf, data->chip_info->mma_scales,
 		ARRAY_SIZE(data->chip_info->mma_scales));


