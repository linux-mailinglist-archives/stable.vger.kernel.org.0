Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A4B55D449
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbiF0L0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiF0LZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AC1658C;
        Mon, 27 Jun 2022 04:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 245CD61456;
        Mon, 27 Jun 2022 11:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E6EC36AEF;
        Mon, 27 Jun 2022 11:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329139;
        bh=Jj2MpJhgOYgpnYmCUyynlb6JE4n+GizxYB1VAY7mPs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIT9RDDoMZEPYWNHUc2acrmNg6TNaDgnEKJPfalKmulfsNQ2Mxr6otQhbD0CBksog
         bb3JV1f7WbzsyvPL+o/ivEoxcNUKSu2ju3FdZFk6Gh1OiOXQHhBujvfeYatfbGknNh
         DQvqd4phGH3va8onRx7nekA+cffAYwR4qomClfjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/102] iio: mma8452: fix probe fail when device tree compatible is used.
Date:   Mon, 27 Jun 2022 13:21:14 +0200
Message-Id: <20220627111935.341374641@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit fe18894930a025617114aa8ca0adbf94d5bffe89 ]

Correct the logic for the probe. First check of_match_table, if
not meet, then check i2c_driver.id_table. If both not meet, then
return fail.

Fixes: a47ac019e7e8 ("iio: mma8452: Fix probe failing when an i2c_device_id is used")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/1650876060-17577-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index e7e280282774..67463be797de 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1542,11 +1542,13 @@ static int mma8452_probe(struct i2c_client *client,
 	mutex_init(&data->lock);
 
 	data->chip_info = device_get_match_data(&client->dev);
-	if (!data->chip_info && id) {
-		data->chip_info = &mma_chip_info_table[id->driver_data];
-	} else {
-		dev_err(&client->dev, "unknown device model\n");
-		return -ENODEV;
+	if (!data->chip_info) {
+		if (id) {
+			data->chip_info = &mma_chip_info_table[id->driver_data];
+		} else {
+			dev_err(&client->dev, "unknown device model\n");
+			return -ENODEV;
+		}
 	}
 
 	data->vdd_reg = devm_regulator_get(&client->dev, "vdd");
-- 
2.35.1



