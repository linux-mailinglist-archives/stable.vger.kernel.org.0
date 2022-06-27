Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE5955D30B
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbiF0Lut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238588AbiF0Lss (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707E2D100;
        Mon, 27 Jun 2022 04:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02493611C9;
        Mon, 27 Jun 2022 11:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D350C3411D;
        Mon, 27 Jun 2022 11:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330156;
        bh=VS9xJwq5vrJSu3Sg10kO6/gABDXtsbDYzCr9Qs2oxFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyUUAVIj5uazDOY8K5AdFQce5DJV9e08A7Jsk9kDjVScQb6QDfOR+9DU4jtCevsDM
         Q2g08cmJYFQkAthTP1FNziwcXtAFzn4qAdysO6+V2xQZR4U0crMhVyRUvEr6e23iYU
         e5Hs1EXa/A2SvN+9nM1QXbuSa4FAXYlzi02mENJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 104/181] iio: mma8452: fix probe fail when device tree compatible is used.
Date:   Mon, 27 Jun 2022 13:21:17 +0200
Message-Id: <20220627111947.715254494@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
index 9c02c681c84c..4156d216c640 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1556,11 +1556,13 @@ static int mma8452_probe(struct i2c_client *client,
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
 
 	ret = iio_read_mount_matrix(&client->dev, &data->orientation);
-- 
2.35.1



