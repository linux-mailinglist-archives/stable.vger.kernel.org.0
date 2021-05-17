Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4817A38368E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243128AbhEQPd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241265AbhEQPb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:31:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E6EA61401;
        Mon, 17 May 2021 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262306;
        bh=nrLbR1qS2oetQEG6q1ppywEyY3I4leNoq2ksalzIrvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3Nhm1p5e832dRDuWJjpGoWMd8w+X/wPAcLaqZrnKH67ddDZuPIUj6tVlrWB4unxh
         vbuv0gTPR9FXMsmPF5+sXip03rOnTxwwVcwivXzU0QvlL4Wqj7GOsy+nH9vUC/ZKPF
         wqSGWu2Lg2z22ofbBikmrYAf69nISLT8ThpNKsk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 261/329] iio: light: gp2ap002: Fix rumtime PM imbalance on error
Date:   Mon, 17 May 2021 16:02:52 +0200
Message-Id: <20210517140310.940874820@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 8edb79af88efc6e49e735f9baf61d9f0748b881f ]

When devm_request_threaded_irq() fails, we should decrease the
runtime PM counter to keep the counter balanced. But when
iio_device_register() fails, we need not to decrease it because
we have already decreased it before.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: 97d642e23037 ("iio: light: Add a driver for Sharp GP2AP002x00F")
Link: https://lore.kernel.org/r/20210407034927.16882-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/gp2ap002.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/gp2ap002.c b/drivers/iio/light/gp2ap002.c
index 7ba7aa59437c..040d8429a6e0 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -583,7 +583,7 @@ static int gp2ap002_probe(struct i2c_client *client,
 					"gp2ap002", indio_dev);
 	if (ret) {
 		dev_err(dev, "unable to request IRQ\n");
-		goto out_disable_vio;
+		goto out_put_pm;
 	}
 	gp2ap002->irq = client->irq;
 
@@ -613,8 +613,9 @@ static int gp2ap002_probe(struct i2c_client *client,
 
 	return 0;
 
-out_disable_pm:
+out_put_pm:
 	pm_runtime_put_noidle(dev);
+out_disable_pm:
 	pm_runtime_disable(dev);
 out_disable_vio:
 	regulator_disable(gp2ap002->vio);
-- 
2.30.2



