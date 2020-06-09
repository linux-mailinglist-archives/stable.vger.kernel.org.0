Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE5D1F455B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgFISOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732716AbgFIRul (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:50:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F02920774;
        Tue,  9 Jun 2020 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725040;
        bh=I8e9rXkiQJBJOMniruow/r9QenuLuPUf8wI/t2e2w7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+sOFN/Oa9Rro/TmMo1gNXIZHZ6fDw7duo+UHO8ky+hw/Wm/lFjT1M9htzFQuZoXk
         Hj3+xwDByc+4Mh1fpuDgmwmzGreQuoaL6uVW/7P6gOImr6MPmMh21U5Iq3W85j7Fes
         wZRDT7/hWlmEC/pZxyn4xpSLOFqolWcjjuABX6Xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathieu Othacehe <m.othacehe@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 45/46] iio: vcnl4000: Fix i2c swapped word reading.
Date:   Tue,  9 Jun 2020 19:45:01 +0200
Message-Id: <20200609174031.043249048@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Othacehe <m.othacehe@gmail.com>

[ Upstream commit 18dfb5326370991c81a6d1ed6d1aeee055cb8c05 ]

The bytes returned by the i2c reading need to be swapped
unconditionally. Otherwise, on be16 platforms, an incorrect value will be
returned.

Taking the slow path via next merge window as its been around a while
and we have a patch set dependent on this which would be held up.

Fixes: 62a1efb9f868 ("iio: add vcnl4000 combined ALS and proximity sensor")
Signed-off-by: Mathieu Othacehe <m.othacehe@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/vcnl4000.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 360b6e98137a..5a3a532937ba 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -61,7 +61,6 @@ static int vcnl4000_measure(struct vcnl4000_data *data, u8 req_mask,
 				u8 rdy_mask, u8 data_reg, int *val)
 {
 	int tries = 20;
-	__be16 buf;
 	int ret;
 
 	mutex_lock(&data->lock);
@@ -88,13 +87,12 @@ static int vcnl4000_measure(struct vcnl4000_data *data, u8 req_mask,
 		goto fail;
 	}
 
-	ret = i2c_smbus_read_i2c_block_data(data->client,
-		data_reg, sizeof(buf), (u8 *) &buf);
+	ret = i2c_smbus_read_word_swapped(data->client, data_reg);
 	if (ret < 0)
 		goto fail;
 
 	mutex_unlock(&data->lock);
-	*val = be16_to_cpu(buf);
+	*val = ret;
 
 	return 0;
 
-- 
2.25.1



