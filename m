Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463ABB8123
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392156AbfISTCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 15:02:14 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33420 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389629AbfISTCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 15:02:14 -0400
Received: by mail-io1-f67.google.com with SMTP id m11so10451528ioo.0;
        Thu, 19 Sep 2019 12:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=4X6G5fyDOE+8qDzwdcGrWs6Ga+WuHS2SnviPyZtHUSo=;
        b=UQnxMIdqhSQFf91e+sM59Ud05JHhPy1Y8x8zf8DHNpthxD4L3VNTOT1PAxUOKb5NJw
         Qrk6R4Zix8EvhguGv8GUkZG1MTR+KGGzm5auozkogFEgNRJZsMQu4X5ALpt5N9U41GTR
         p9faY6p4FpozIMwFlB/VXT4+zgptSr+C9USZMyyE2Up4dDkrwejqzDABE6u7IQ2lYJIo
         3Ni4KbZ9m3gCTBL/XvAP5Ey/+C5Tx6jsQv4X6xbMLTdl8OoCYO20CXMCDsbZcNPZH5/z
         epUENUSBYwQ0QmkBG2i2+QFWW6gX2cPc0fCa1dxdUbH5//iUyy68BLHN8tofcDskx3a5
         YOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=4X6G5fyDOE+8qDzwdcGrWs6Ga+WuHS2SnviPyZtHUSo=;
        b=cewtcT3ymdRPW6XyJwHEcXPA9la+hTX6IQqLTLbL9mk1peHJJWWAITUJ0cPeAbNdc6
         h56VrGz96JRXR5O4WpXUce6w9K5Z96FqoTr+uJL4rJ23Xivv/ihnsY6l2+RNpyCL+gMW
         vnfhMjaLkD6ORHGfg6w34pP4c5IEEqHi0ydNeF7FFByvwZFoHumdRoqS0TowT2x2xepr
         os3iBMjIgrYn9WLYi+Rwf+U6Bx0fYhsZ0a4G9VoKzjnHBJZMRzV6kVl/RdG9Sa6A22N7
         KSU0T59Dy1SoYNSYStcmXIJ9jk3C75/1sB7ZrQB5lpmzQfR7xy/ipmO+FV7OmuARuYY8
         RajA==
X-Gm-Message-State: APjAAAW4MACAMihXeTg3LYbHi4fYZtu+Cjk6c3L0G17AQIZvnRgBWkVx
        GcPEhQsYQ3y7FNZtUSVNVzzHUlAY
X-Google-Smtp-Source: APXvYqwxuhM2iQg+2+pWNOMaj8I4qbFEjgrjcTphhnZk1Wcc+KxOLuQmdjDzx9HbY+koj0p1gxZctQ==
X-Received: by 2002:a02:8644:: with SMTP id e62mr14360370jai.115.1568919732897;
        Thu, 19 Sep 2019 12:02:12 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id e139sm9182234iof.60.2019.09.19.12.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 12:02:12 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: [PATCH 4.4 v1] power: supply: ltc2941-battery-gauge: fix use-after-free
Date:   Thu, 19 Sep 2019 15:02:08 -0400
Message-Id: <20190919190208.13648-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190919151137.9960-1-TheSven73@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This driver's remove path calls cancel_delayed_work().
However, that function does not wait until the work function
finishes. This could mean that the work function is still
running after the driver's remove function has finished,
which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
that the work is properly cancelled, no longer running, and
unable to re-schedule itself.

This issue was detected with the help of Coccinelle.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 drivers/power/ltc2941-battery-gauge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/ltc2941-battery-gauge.c b/drivers/power/ltc2941-battery-gauge.c
index da49436176cd..30a9014b2f95 100644
--- a/drivers/power/ltc2941-battery-gauge.c
+++ b/drivers/power/ltc2941-battery-gauge.c
@@ -449,7 +449,7 @@ static int ltc294x_i2c_remove(struct i2c_client *client)
 {
 	struct ltc294x_info *info = i2c_get_clientdata(client);
 
-	cancel_delayed_work(&info->work);
+	cancel_delayed_work_sync(&info->work);
 	power_supply_unregister(info->supply);
 	return 0;
 }
-- 
2.17.1

