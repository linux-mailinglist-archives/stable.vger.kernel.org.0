Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6147FF4748
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbfKHLtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:49:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391733AbfKHLsY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:48:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C44FB21924;
        Fri,  8 Nov 2019 11:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213704;
        bh=xmteAW81h2blFb8tQocIaklh7OglFSJcqZ7I45f1uC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5h8Y0ACW7Kd3KI0moAo0jlnP7xuxCfhsoBDWu6ITfz7CjI9rysVbsyPxBJzSPQZ9
         6YGZrThKkUWNiPR2veRCaP7a+OJrL5Wv8l8SHjfwBodlfUxIOO/Q1jf8seulNB5H3v
         4vlY5OjtPfR5/x1p4xoSQY1sjqTpET2NtlY+0/YA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 42/44] power: supply: ab8500_fg: silence uninitialized variable warnings
Date:   Fri,  8 Nov 2019 06:47:18 -0500
Message-Id: <20191108114721.15944-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 54baff8d4e5dce2cef61953b1dc22079cda1ddb1 ]

If kstrtoul() fails then we print "charge_full" when it's uninitialized.
The debug printk doesn't add anything so I deleted it and cleaned these
two functions up a bit.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/ab8500_fg.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 3830dade5d69d..d91111200dde2 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2447,17 +2447,14 @@ static ssize_t charge_full_store(struct ab8500_fg *di, const char *buf,
 				 size_t count)
 {
 	unsigned long charge_full;
-	ssize_t ret;
+	int ret;
 
 	ret = kstrtoul(buf, 10, &charge_full);
+	if (ret)
+		return ret;
 
-	dev_dbg(di->dev, "Ret %zd charge_full %lu", ret, charge_full);
-
-	if (!ret) {
-		di->bat_cap.max_mah = (int) charge_full;
-		ret = count;
-	}
-	return ret;
+	di->bat_cap.max_mah = (int) charge_full;
+	return count;
 }
 
 static ssize_t charge_now_show(struct ab8500_fg *di, char *buf)
@@ -2469,20 +2466,16 @@ static ssize_t charge_now_store(struct ab8500_fg *di, const char *buf,
 				 size_t count)
 {
 	unsigned long charge_now;
-	ssize_t ret;
+	int ret;
 
 	ret = kstrtoul(buf, 10, &charge_now);
+	if (ret)
+		return ret;
 
-	dev_dbg(di->dev, "Ret %zd charge_now %lu was %d",
-		ret, charge_now, di->bat_cap.prev_mah);
-
-	if (!ret) {
-		di->bat_cap.user_mah = (int) charge_now;
-		di->flags.user_cap = true;
-		ret = count;
-		queue_delayed_work(di->fg_wq, &di->fg_periodic_work, 0);
-	}
-	return ret;
+	di->bat_cap.user_mah = (int) charge_now;
+	di->flags.user_cap = true;
+	queue_delayed_work(di->fg_wq, &di->fg_periodic_work, 0);
+	return count;
 }
 
 static struct ab8500_fg_sysfs_entry charge_full_attr =
-- 
2.20.1

