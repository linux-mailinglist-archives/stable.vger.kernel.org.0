Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5372A383513
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbhEQPP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242973AbhEQPMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:12:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC79361C4B;
        Mon, 17 May 2021 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261888;
        bh=k4uUDStQ7ujxB3fGTQkOMujr04HsFPyRqc+btpgBL/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NS0XRmBwffD8ExqDyrWWpzpM7VIPhEUJ51Ns2D8jucZWKkJpYZHX2oegMDNKHbmz3
         TQrfleXVHbAJJTEEJ38YNzqKtRFD82+4P7dA3cJJM1TcHwriNn+1QV6Lb5g0uTojBG
         tpG4hh9O+O+a3bZaK783wbv4dKLFCTuq7WkcPf2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/141] iio: proximity: pulsedlight: Fix rumtime PM imbalance on error
Date:   Mon, 17 May 2021 16:02:37 +0200
Message-Id: <20210517140246.316675082@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
index 47af54f14756..67f85268b63d 100644
--- a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
+++ b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
@@ -158,6 +158,7 @@ static int lidar_get_measurement(struct lidar_data *data, u16 *reg)
 	ret = lidar_write_control(data, LIDAR_REG_CONTROL_ACQUIRE);
 	if (ret < 0) {
 		dev_err(&client->dev, "cannot send start measurement command");
+		pm_runtime_put_noidle(&client->dev);
 		return ret;
 	}
 
-- 
2.30.2



