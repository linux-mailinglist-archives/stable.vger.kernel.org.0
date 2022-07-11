Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAA056FCEF
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiGKJtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiGKJsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:48:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5A621AA;
        Mon, 11 Jul 2022 02:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDEB6612FE;
        Mon, 11 Jul 2022 09:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD77C34115;
        Mon, 11 Jul 2022 09:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531413;
        bh=8Hp75SX0vLGmD71SdPF4zbXYt3vUEF4vh8eSbNgZBBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ocf4FM+1n1yXaOvkZnePe6GUa+G5Tsiyz9t1FOXAsdVwWMvLmzrasUXmyHwpwHOdg
         u4SV5Sr/gzAmfJNyd2P8HRrWYZNnoUsAlLWBpNk5viK6Va8HuLQVcVZpNEJqydYnAY
         QW0zJ1ByArjkn3xZA9sgH58irw5V9k43vEf0ky/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Martin Kepplinger <martink@posteo.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/230] iio: accel: mma8452: use the correct logic to get mma8452_data
Date:   Mon, 11 Jul 2022 11:05:53 +0200
Message-Id: <20220711090606.821624396@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit c87b7b12f48db86ac9909894f4dc0107d7df6375 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 373b59557afe..1f46a73aafea 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -380,8 +380,8 @@ static ssize_t mma8452_show_scale_avail(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct mma8452_data *data = iio_priv(i2c_get_clientdata(
-					     to_i2c_client(dev)));
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct mma8452_data *data = iio_priv(indio_dev);
 
 	return mma8452_show_int_plus_micros(buf, data->chip_info->mma_scales,
 		ARRAY_SIZE(data->chip_info->mma_scales));
-- 
2.35.1



