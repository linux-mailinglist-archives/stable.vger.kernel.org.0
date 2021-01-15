Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAD22F795D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732014AbhAOMfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387630AbhAOMfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCF442333E;
        Fri, 15 Jan 2021 12:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714074;
        bh=os7dohcj4+JctHTLwnzDesgBjZRrYjO2vXdt/AByoF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2BjGDEF896uNVTPC5++D8gMt4Q7VDZdOOyx98/3gt0cDHVilxfPb5F6kUb9bVpuZ
         n3w+wep9ve4+/Xg06cqbsMB+mQ9TLA6o3mZFQN7igzbvO20x9c8KNMczOj5ITc5QXa
         XF4EFrbRJtr9xBu3hbin5ilW4DAkHYIOjcbtYFrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linhua Xu <linhua.xu@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.4 34/62] i2c: sprd: use a specific timeout to avoid system hang up issue
Date:   Fri, 15 Jan 2021 13:27:56 +0100
Message-Id: <20210115122000.049519779@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

commit 0b884fe71f9ee6a5df35e677154256ea2099ebb8 upstream.

If the i2c device SCL bus being pulled up due to some exception before
message transfer done, the system cannot receive the completing interrupt
signal any more, it would not exit waiting loop until MAX_SCHEDULE_TIMEOUT
jiffies eclipse, that would make the system seemed hang up. To avoid that
happen, this patch adds a specific timeout for message transfer.

Fixes: 8b9ec0719834 ("i2c: Add Spreadtrum I2C controller driver")
Signed-off-by: Linhua Xu <linhua.xu@unisoc.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
[wsa: changed errno to ETIMEDOUT]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-sprd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-sprd.c
+++ b/drivers/i2c/busses/i2c-sprd.c
@@ -72,6 +72,8 @@
 
 /* timeout (ms) for pm runtime autosuspend */
 #define SPRD_I2C_PM_TIMEOUT	1000
+/* timeout (ms) for transfer message */
+#define I2C_XFER_TIMEOUT	1000
 
 /* SPRD i2c data structure */
 struct sprd_i2c {
@@ -244,6 +246,7 @@ static int sprd_i2c_handle_msg(struct i2
 			       struct i2c_msg *msg, bool is_last_msg)
 {
 	struct sprd_i2c *i2c_dev = i2c_adap->algo_data;
+	unsigned long time_left;
 
 	i2c_dev->msg = msg;
 	i2c_dev->buf = msg->buf;
@@ -273,7 +276,10 @@ static int sprd_i2c_handle_msg(struct i2
 
 	sprd_i2c_opt_start(i2c_dev);
 
-	wait_for_completion(&i2c_dev->complete);
+	time_left = wait_for_completion_timeout(&i2c_dev->complete,
+				msecs_to_jiffies(I2C_XFER_TIMEOUT));
+	if (!time_left)
+		return -ETIMEDOUT;
 
 	return i2c_dev->err;
 }


