Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135C724739B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbgHQPtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387745AbgHQPtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:49:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C85702065D;
        Mon, 17 Aug 2020 15:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679360;
        bh=r/97GU+YHqJuzF5uO5WtAAq5nQtAD/oOjr2scckSSzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTi3LSg2cG3OmVdfKZiFeWn+dD45MzZ0sMKxzPtOljzj+RQyoPxv8ISQPs/a5fc5S
         Likcia/Bqy5w/XR82AU6Xam5ye4y/1yYX7III02jRqUo8opN21yotVdWn9gOh5TxCW
         GNXD9icHoIw2ovNTtCEFuSloMcaZ16RorQ2QpPmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 183/393] media: tvp5150: Add missed media_entity_cleanup()
Date:   Mon, 17 Aug 2020 17:13:53 +0200
Message-Id: <20200817143828.498741111@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit d000e9b5e4a23dd700b3f58a4738c94bb5179ff0 ]

This driver does not call media_entity_cleanup() in the error handler
of tvp5150_registered() and tvp5150_remove(), while it has called
media_entity_pads_init() at first.
Add the missed calls to fix it.

Fixes: 0556f1d580d4 ("media: tvp5150: add input source selection of_graph support")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tvp5150.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index eb39cf5ea0895..9df575238952a 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1664,8 +1664,10 @@ static int tvp5150_registered(struct v4l2_subdev *sd)
 	return 0;
 
 err:
-	for (i = 0; i < decoder->connectors_num; i++)
+	for (i = 0; i < decoder->connectors_num; i++) {
 		media_device_unregister_entity(&decoder->connectors[i].ent);
+		media_entity_cleanup(&decoder->connectors[i].ent);
+	}
 	return ret;
 #endif
 
@@ -2248,8 +2250,10 @@ static int tvp5150_remove(struct i2c_client *c)
 
 	for (i = 0; i < decoder->connectors_num; i++)
 		v4l2_fwnode_connector_free(&decoder->connectors[i].base);
-	for (i = 0; i < decoder->connectors_num; i++)
+	for (i = 0; i < decoder->connectors_num; i++) {
 		media_device_unregister_entity(&decoder->connectors[i].ent);
+		media_entity_cleanup(&decoder->connectors[i].ent);
+	}
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
 	pm_runtime_disable(&c->dev);
-- 
2.25.1



