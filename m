Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A455498EF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380912AbiFMOHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382375AbiFMOFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:05:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5769549B;
        Mon, 13 Jun 2022 04:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D139B80D31;
        Mon, 13 Jun 2022 11:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2C4C341C4;
        Mon, 13 Jun 2022 11:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120435;
        bh=+lNjLZLQbeY+zNTSRXU8Q/ga2ssIT8vG9WFJSp3ZJkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2669vE5t15iXhzwQfyeHWIcaiQq9/RWmM9FIfBhdg7nFYA5ZNUcTD7Slg7DSnlqF
         oamrm9yinlb85z+grtvq+WJFcjz9bQlNwFsFFjlG+wJaNNuRMAIyxGXmDiD7EihVBw
         CDNlC/9nDyZsiGPprkrHVi892OphKZlNuBNxHY+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 031/298] iio: proximity: vl53l0x: Fix return value check of wait_for_completion_timeout
Date:   Mon, 13 Jun 2022 12:08:45 +0200
Message-Id: <20220613094925.875386367@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 50f2959113cb6756ffd73c4fedc712cf2661f711 ]

wait_for_completion_timeout() returns unsigned long not int.
It returns 0 if timed out, and positive if completed.
The check for <= 0 is ambiguous and should be == 0 here
indicating timeout which is the only error case.

Fixes: 3cef2e31b54b ("iio: proximity: vl53l0x: Add IRQ support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220412064210.10734-1-linmq006@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/proximity/vl53l0x-i2c.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/proximity/vl53l0x-i2c.c b/drivers/iio/proximity/vl53l0x-i2c.c
index cf38144b6f95..13a87d3e3544 100644
--- a/drivers/iio/proximity/vl53l0x-i2c.c
+++ b/drivers/iio/proximity/vl53l0x-i2c.c
@@ -104,6 +104,7 @@ static int vl53l0x_read_proximity(struct vl53l0x_data *data,
 	u16 tries = 20;
 	u8 buffer[12];
 	int ret;
+	unsigned long time_left;
 
 	ret = i2c_smbus_write_byte_data(client, VL_REG_SYSRANGE_START, 1);
 	if (ret < 0)
@@ -112,10 +113,8 @@ static int vl53l0x_read_proximity(struct vl53l0x_data *data,
 	if (data->client->irq) {
 		reinit_completion(&data->completion);
 
-		ret = wait_for_completion_timeout(&data->completion, HZ/10);
-		if (ret < 0)
-			return ret;
-		else if (ret == 0)
+		time_left = wait_for_completion_timeout(&data->completion, HZ/10);
+		if (time_left == 0)
 			return -ETIMEDOUT;
 
 		vl53l0x_clear_irq(data);
-- 
2.35.1



