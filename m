Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E37106DA5
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbfKVLBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731241AbfKVLBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:01:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3344520840;
        Fri, 22 Nov 2019 11:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420510;
        bh=4wa0y7siKNPCymmJxLw0kfiWr913Znmfw02HWPsD7t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqj6mOlaz4UdgCLVvhHI14+8eJFMlDAQFxTd8DFFfZJ3QExeCfvcaSC93B6Q5PLI0
         VL5EPgq5IwEXnK4HnY0I7gGIaqfu3FBWsBHM+AQc64LY7xKDigsCrkUKrTFbKUJ81d
         d+/ApqZeP9DeDOhr+o6v4Hmu5zVcFzGzI0Lrd2ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sax <jsbc@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/220] Input: silead - try firmware reload after unsuccessful resume
Date:   Fri, 22 Nov 2019 11:28:17 +0100
Message-Id: <20191122100922.317692050@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Sax <jsbc@gmx.de>

[ Upstream commit dde27443211062e841806feaf690674b7c3a599f ]

A certain silead controller (Chip ID: 0x56810000) loses its firmware
after suspend, causing the resume to fail. This patch tries to load
the firmware, should a resume error occur and retries the resuming.

Signed-off-by: Julian Sax <jsbc@gmx.de>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/silead.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/input/touchscreen/silead.c b/drivers/input/touchscreen/silead.c
index e5c3b066bd2a1..06f0eb04a8fd4 100644
--- a/drivers/input/touchscreen/silead.c
+++ b/drivers/input/touchscreen/silead.c
@@ -558,20 +558,33 @@ static int __maybe_unused silead_ts_suspend(struct device *dev)
 static int __maybe_unused silead_ts_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	bool second_try = false;
 	int error, status;
 
 	silead_ts_set_power(client, SILEAD_POWER_ON);
 
+ retry:
 	error = silead_ts_reset(client);
 	if (error)
 		return error;
 
+	if (second_try) {
+		error = silead_ts_load_fw(client);
+		if (error)
+			return error;
+	}
+
 	error = silead_ts_startup(client);
 	if (error)
 		return error;
 
 	status = silead_ts_get_status(client);
 	if (status != SILEAD_STATUS_OK) {
+		if (!second_try) {
+			second_try = true;
+			dev_dbg(dev, "Reloading firmware after unsuccessful resume\n");
+			goto retry;
+		}
 		dev_err(dev, "Resume error, status: 0x%02x\n", status);
 		return -ENODEV;
 	}
-- 
2.20.1



