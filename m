Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D020CA886
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390304AbfJCQ2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390643AbfJCQ2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:28:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CEF32054F;
        Thu,  3 Oct 2019 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120090;
        bh=fKDOifOsBYF0DMQPzAQ/DZmDI8+D34sivsnDb+H7i50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gi0Ygc5A84wazC8e8ZYGl7tzoqFn5HQTtJtmozCp3OumGN6tD7JJHpbfPOfgfJdTR
         L185h27jU8ZkB2+OrXrUcMXPO2GTYMWhXx9X8TNCD/JzBoiCYk8xW7BOrgmZJhFjuG
         xItNJLtzGKIVPrjJwleIIWkFAWCFa3N1vZN44hgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 094/313] media: i2c: tda1997x: prevent potential NULL pointer access
Date:   Thu,  3 Oct 2019 17:51:12 +0200
Message-Id: <20191003154542.122641384@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



