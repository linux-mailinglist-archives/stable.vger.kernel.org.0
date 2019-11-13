Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FFAFA305
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbfKMCH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:07:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730550AbfKMCAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B7B22470;
        Wed, 13 Nov 2019 02:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610443;
        bh=uwR+ZkkgiwpN6ZchteRgte5Qy/AWfYAwBCYwH+Xv/ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhRD94IGCvYaj1I6hgP/+ALK4ik5W2u0GM48hkqjmFy0dwF4uuQ9bvYiYkkFUgc5e
         gD85Oja/Z6hkvlmegoDrVTHLmazmgMkOF205RlUmzEzL4+MJEYGMBN5seQFVDP7VPq
         UUtx8VCa2MdLo3JO6q2xTYGEKfLivKhxZiGjWEDY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Sax <jsbc@gmx.de>, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 40/68] Input: silead - try firmware reload after unsuccessful resume
Date:   Tue, 12 Nov 2019 20:59:04 -0500
Message-Id: <20191113015932.12655-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f502c8488be86..867772878c0c8 100644
--- a/drivers/input/touchscreen/silead.c
+++ b/drivers/input/touchscreen/silead.c
@@ -504,20 +504,33 @@ static int __maybe_unused silead_ts_suspend(struct device *dev)
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

