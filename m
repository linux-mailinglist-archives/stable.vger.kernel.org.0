Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C3D106B55
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfKVKnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbfKVKnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:43:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594F120707;
        Fri, 22 Nov 2019 10:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419400;
        bh=lxaBYjJ5B0CHoLiYBCq+c4Te2XzDh6prC0xrVXJ31bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02ikqq6uluY2vMDEa3kE7RVE/4NqfUSb1vNNn459ls1SSXLk4MpbwrSTdJxGszK6N
         moV4JFJlbT+rvcVYQcn+oHWGCHa787Y6/bqF/+Ya/lzP180qftbOfoPYIK6MZgXJR1
         ZbEWATuEU2wZTTi8ITHxlX3iyDIp3npfMKJuksD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 072/222] power: supply: ab8500_fg: silence uninitialized variable warnings
Date:   Fri, 22 Nov 2019 11:26:52 +0100
Message-Id: <20191122100907.048522137@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/power/supply/ab8500_fg.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 2199f673118c0..ea8c26a108f00 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2437,17 +2437,14 @@ static ssize_t charge_full_store(struct ab8500_fg *di, const char *buf,
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
@@ -2459,20 +2456,16 @@ static ssize_t charge_now_store(struct ab8500_fg *di, const char *buf,
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



