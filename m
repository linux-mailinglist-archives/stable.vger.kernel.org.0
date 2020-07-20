Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31A522669E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbgGTQEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732882AbgGTQEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 855182064B;
        Mon, 20 Jul 2020 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261085;
        bh=tZbcvL0Yom+uemumx//KXJkqlGT24AfbHXyZqMG8DTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VN8r6BxjphBUiuVbAd3cxtJudvOaFaLfpnW5q0vfLRuUGggBajFjng/7eNT/7Y+3
         zz7aXWUOphqz2bjLc5mA+WB51g8xl8NnXfLx5HXfRiBW0XFxGHo4+f+KMFOrEqFFk+
         aEmXo/8kCfdzbcHCsmcL89yeIEjXi7ahls5OJEsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 5.4 196/215] misc: atmel-ssc: lock with mutex instead of spinlock
Date:   Mon, 20 Jul 2020 17:37:58 +0200
Message-Id: <20200720152829.495186822@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit b037d60a3b1d1227609fd858fa34321f41829911 upstream.

Uninterruptible context is not needed in the driver and causes lockdep
warning because of mutex taken in of_alias_get_id(). Convert the lock to
mutex to avoid the issue.

Cc: stable@vger.kernel.org
Fixes: 099343c64e16 ("ARM: at91: atmel-ssc: add device tree support")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/50f0d7fa107f318296afb49477c3571e4d6978c5.1592998403.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/atmel-ssc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -10,7 +10,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/atmel-ssc.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -20,7 +20,7 @@
 #include "../../sound/soc/atmel/atmel_ssc_dai.h"
 
 /* Serialize access to ssc_list and user count */
-static DEFINE_SPINLOCK(user_lock);
+static DEFINE_MUTEX(user_lock);
 static LIST_HEAD(ssc_list);
 
 struct ssc_device *ssc_request(unsigned int ssc_num)
@@ -28,7 +28,7 @@ struct ssc_device *ssc_request(unsigned
 	int ssc_valid = 0;
 	struct ssc_device *ssc;
 
-	spin_lock(&user_lock);
+	mutex_lock(&user_lock);
 	list_for_each_entry(ssc, &ssc_list, list) {
 		if (ssc->pdev->dev.of_node) {
 			if (of_alias_get_id(ssc->pdev->dev.of_node, "ssc")
@@ -44,18 +44,18 @@ struct ssc_device *ssc_request(unsigned
 	}
 
 	if (!ssc_valid) {
-		spin_unlock(&user_lock);
+		mutex_unlock(&user_lock);
 		pr_err("ssc: ssc%d platform device is missing\n", ssc_num);
 		return ERR_PTR(-ENODEV);
 	}
 
 	if (ssc->user) {
-		spin_unlock(&user_lock);
+		mutex_unlock(&user_lock);
 		dev_dbg(&ssc->pdev->dev, "module busy\n");
 		return ERR_PTR(-EBUSY);
 	}
 	ssc->user++;
-	spin_unlock(&user_lock);
+	mutex_unlock(&user_lock);
 
 	clk_prepare(ssc->clk);
 
@@ -67,14 +67,14 @@ void ssc_free(struct ssc_device *ssc)
 {
 	bool disable_clk = true;
 
-	spin_lock(&user_lock);
+	mutex_lock(&user_lock);
 	if (ssc->user)
 		ssc->user--;
 	else {
 		disable_clk = false;
 		dev_dbg(&ssc->pdev->dev, "device already free\n");
 	}
-	spin_unlock(&user_lock);
+	mutex_unlock(&user_lock);
 
 	if (disable_clk)
 		clk_unprepare(ssc->clk);
@@ -237,9 +237,9 @@ static int ssc_probe(struct platform_dev
 		return -ENXIO;
 	}
 
-	spin_lock(&user_lock);
+	mutex_lock(&user_lock);
 	list_add_tail(&ssc->list, &ssc_list);
-	spin_unlock(&user_lock);
+	mutex_unlock(&user_lock);
 
 	platform_set_drvdata(pdev, ssc);
 
@@ -258,9 +258,9 @@ static int ssc_remove(struct platform_de
 
 	ssc_sound_dai_remove(ssc);
 
-	spin_lock(&user_lock);
+	mutex_lock(&user_lock);
 	list_del(&ssc->list);
-	spin_unlock(&user_lock);
+	mutex_unlock(&user_lock);
 
 	return 0;
 }


