Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 180E6119B0B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfLJWFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbfLJWFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:05:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C49F5214D8;
        Tue, 10 Dec 2019 22:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015500;
        bh=L20tOjEVEAi70ooVFlzfIgyn5KKlXFx0nlxe2Dzc2rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGvwCr3qe4y9D15/HBB8wiGMElA3M+2HjYG5VPPJGtOHXgC5RmK4S+NQuc+QrpOk2
         W1sOGEEsSEQKjL8MI+sqAne05+kFC+EqSYiF0LhFx7Mq9JrBTXdQGEfCxycSfx5zEY
         eBCo3VZVgM5rnSr9lGKIpUHFZQR0F81kkjIyqXzA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 100/130] media: si470x-i2c: add missed operations in remove
Date:   Tue, 10 Dec 2019 17:02:31 -0500
Message-Id: <20191210220301.13262-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 2df200ab234a86836a8879a05a8007d6b884eb14 ]

The driver misses calling v4l2_ctrl_handler_free and
v4l2_device_unregister in remove like what is done in probe failure.
Add the calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 8ce6f9cff7463..b60fb6ed5aeb5 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -455,6 +455,8 @@ static int si470x_i2c_remove(struct i2c_client *client)
 	video_unregister_device(&radio->videodev);
 	kfree(radio);
 
+	v4l2_ctrl_handler_free(&radio->hdl);
+	v4l2_device_unregister(&radio->v4l2_dev);
 	return 0;
 }
 
-- 
2.20.1

