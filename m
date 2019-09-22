Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98941BAB44
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406759AbfIVTgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729100AbfIVSqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2411121928;
        Sun, 22 Sep 2019 18:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177972;
        bh=fKDOifOsBYF0DMQPzAQ/DZmDI8+D34sivsnDb+H7i50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgHxkp8rr9ZfcwfKJ+7lPmXd0hq9WhAX96prJZYdBkPQjnrDKC3Nt3Z9LCR1U00eg
         R4yt7skiJJ0ZigbFq/TLiNCXx6aqKxuPsa2nWfBIdv0FjzkfETzp3EVVuNNspPhMW5
         YgFhie8BnaoPuNot7NiHHnpwJmwsYnFLonZZkeN0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 071/203] media: i2c: tda1997x: prevent potential NULL pointer access
Date:   Sun, 22 Sep 2019 14:41:37 -0400
Message-Id: <20190922184350.30563-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 2f822f1da08ac5c93e351e79d22920f08fa51baf ]

i2c_new_dummy() can fail returning a NULL pointer. This is not checked
and the returned pointer is blindly used. Convert to
devm_i2c_new_dummy_client() which returns an ERR_PTR and also add a
validity check. Using devm_* here also fixes a leak because the dummy
client was not released in the probe error path.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tda1997x.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index a62ede0966361..5e68182001ecc 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2691,7 +2691,13 @@ static int tda1997x_probe(struct i2c_client *client,
 	}
 
 	ret = 0x34 + ((io_read(sd, REG_SLAVE_ADDR)>>4) & 0x03);
-	state->client_cec = i2c_new_dummy(client->adapter, ret);
+	state->client_cec = devm_i2c_new_dummy_device(&client->dev,
+						      client->adapter, ret);
+	if (IS_ERR(state->client_cec)) {
+		ret = PTR_ERR(state->client_cec);
+		goto err_free_mutex;
+	}
+
 	v4l_info(client, "CEC slave address 0x%02x\n", ret);
 
 	ret = tda1997x_core_init(sd);
@@ -2798,7 +2804,6 @@ static int tda1997x_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(&state->hdl);
 	regulator_bulk_disable(TDA1997X_NUM_SUPPLIES, state->supplies);
-	i2c_unregister_device(state->client_cec);
 	cancel_delayed_work(&state->delayed_work_enable_hpd);
 	mutex_destroy(&state->page_lock);
 	mutex_destroy(&state->lock);
-- 
2.20.1

