Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73177408F06
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbhIMNjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241958AbhIMNg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:36:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD1F613A8;
        Mon, 13 Sep 2021 13:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539677;
        bh=VXE0TY40WKo3a6aWGZjd72SExSfJt/UYR8dPRxbWiTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ai6K0hJquSw0pLz0/JBBrvF4tSHWh7zzSwSXQB8wZnSmNhB/Gia3kS853jiBuNkWE
         qUkVpx4T85/YKD1SltABoLCJXFlvy1OE+T8pncXcjEi5eKHYcHBLc4iYj/ycZcgWf9
         LGuJVY7EQsFRrHtP3LgF8I0kliR05J8dPiM1KORk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yizhuo <yzhai003@ucr.edu>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/236] media: atomisp: fix the uninitialized use and rename "retvalue"
Date:   Mon, 13 Sep 2021 15:13:24 +0200
Message-Id: <20210913131103.716053859@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yizhuo <yzhai003@ucr.edu>

[ Upstream commit c275e5d349b0d2b1143607d28b9c7c14a8a0a9b4 ]

Inside function mt9m114_detect(), variable "retvalue" could
be uninitialized if mt9m114_read_reg() returns error, however, it
is used in the later if statement, which is potentially unsafe.

The local variable "retvalue" is renamed to "model" to avoid
confusion.

Link: https://lore.kernel.org/linux-media/20210625053858.3862-1-yzhai003@ucr.edu
Fixes: ad85094 (media / atomisp: fix the uninitialized use of model ID)
Signed-off-by: Yizhuo <yzhai003@ucr.edu>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
index f5de81132177..77293579a134 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
@@ -1533,16 +1533,19 @@ static struct v4l2_ctrl_config mt9m114_controls[] = {
 static int mt9m114_detect(struct mt9m114_device *dev, struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
-	u32 retvalue;
+	u32 model;
+	int ret;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
 		dev_err(&client->dev, "%s: i2c error", __func__);
 		return -ENODEV;
 	}
-	mt9m114_read_reg(client, MISENSOR_16BIT, (u32)MT9M114_PID, &retvalue);
-	dev->real_model_id = retvalue;
+	ret = mt9m114_read_reg(client, MISENSOR_16BIT, MT9M114_PID, &model);
+	if (ret)
+		return ret;
+	dev->real_model_id = model;
 
-	if (retvalue != MT9M114_MOD_ID) {
+	if (model != MT9M114_MOD_ID) {
 		dev_err(&client->dev, "%s: failed: client->addr = %x\n",
 			__func__, client->addr);
 		return -ENODEV;
-- 
2.30.2



