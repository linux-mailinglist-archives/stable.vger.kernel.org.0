Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C638A9B7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhETLFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239547AbhETLDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F45D61D14;
        Thu, 20 May 2021 10:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505069;
        bh=AL0y3Ulyq87lO2EIkGtAVDh3O0quA74rVMLpWusQE+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWJjUSp9n9sw8EaLaVis46tyDUD/sBEUs/KSR0D0gbop7jV1vYo1jk2AIXwiaUR8k
         7jDhkTUT+Kkw6fTyGq2LgKAWfZynre+MoDITbY9nqj8oPqSesogttgNBCzpxHUg96R
         i01pQeSB0n64Vo0Y6XrN6J5NLW5BjLqiN9skegCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 208/240] iio: proximity: pulsedlight: Fix rumtime PM imbalance on error
Date:   Thu, 20 May 2021 11:23:20 +0200
Message-Id: <20210520092115.648446005@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit a2fa9242e89f27696515699fe0f0296bf1ac1815 ]

When lidar_write_control() fails, a pairing PM usage counter
decrement is needed to keep the counter balanced.

Fixes: 4ac4e086fd8c5 ("iio: pulsedlight-lidar-lite: add runtime PM")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210412053204.4889-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
index 3141c3c161bb..46e969a3a9b7 100644
--- a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
+++ b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
@@ -166,6 +166,7 @@ static int lidar_get_measurement(struct lidar_data *data, u16 *reg)
 	ret = lidar_write_control(data, LIDAR_REG_CONTROL_ACQUIRE);
 	if (ret < 0) {
 		dev_err(&client->dev, "cannot send start measurement command");
+		pm_runtime_put_noidle(&client->dev);
 		return ret;
 	}
 
-- 
2.30.2



