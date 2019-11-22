Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C30106D13
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbfKVK5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730068AbfKVK5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E30DE2071C;
        Fri, 22 Nov 2019 10:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420242;
        bh=MHLTiLMo6OoNuIgCw9aGwbaQZgICcAPVVuPD8MIH+yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1ssk3W7EKQZOmyJ9rHCEd3qVuX0ozDgWu5oV1cvLwZrxRmCb3RUz401gr+kEOsKQ
         meC4mXxM3sjbymPVWJSEp22uUzRSraucD5YqGEwU5jqlof9/BOcYq9SKwlu7y0ErEf
         +7yPHvM1+GtYqLpSu+TrJJP/R51VvHtYGJdtV/rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/220] PM / devfreq: Fix devfreq_add_device() when drivers are built as modules.
Date:   Fri, 22 Nov 2019 11:26:46 +0100
Message-Id: <20191122100915.244786602@linuxfoundation.org>
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

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 23c7b54ca1cd1797ef39169ab85e6d46f1c2d061 ]

When the devfreq driver and the governor driver are built as modules,
the call to devfreq_add_device() or governor_store() fails because the
governor driver is not loaded at the time the devfreq driver loads. The
devfreq driver has a build dependency on the governor but also should
have a runtime dependency. We need to make sure that the governor driver
is loaded before the devfreq driver.

This patch fixes this bug by adding a try_then_request_governor()
function. First tries to find the governor, and then, if it is not found,
it requests the module and tries again.

Fixes: 1b5c1be2c88e (PM / devfreq: map devfreq drivers to governor using name)
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 53 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 4c49bb1330b52..62ead442a8721 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/kmod.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/err.h>
@@ -221,6 +222,49 @@ static struct devfreq_governor *find_devfreq_governor(const char *name)
 	return ERR_PTR(-ENODEV);
 }
 
+/**
+ * try_then_request_governor() - Try to find the governor and request the
+ *                               module if is not found.
+ * @name:	name of the governor
+ *
+ * Search the list of devfreq governors and request the module and try again
+ * if is not found. This can happen when both drivers (the governor driver
+ * and the driver that call devfreq_add_device) are built as modules.
+ * devfreq_list_lock should be held by the caller. Returns the matched
+ * governor's pointer.
+ */
+static struct devfreq_governor *try_then_request_governor(const char *name)
+{
+	struct devfreq_governor *governor;
+	int err = 0;
+
+	if (IS_ERR_OR_NULL(name)) {
+		pr_err("DEVFREQ: %s: Invalid parameters\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+	WARN(!mutex_is_locked(&devfreq_list_lock),
+	     "devfreq_list_lock must be locked.");
+
+	governor = find_devfreq_governor(name);
+	if (IS_ERR(governor)) {
+		mutex_unlock(&devfreq_list_lock);
+
+		if (!strncmp(name, DEVFREQ_GOV_SIMPLE_ONDEMAND,
+			     DEVFREQ_NAME_LEN))
+			err = request_module("governor_%s", "simpleondemand");
+		else
+			err = request_module("governor_%s", name);
+		/* Restore previous state before return */
+		mutex_lock(&devfreq_list_lock);
+		if (err)
+			return NULL;
+
+		governor = find_devfreq_governor(name);
+	}
+
+	return governor;
+}
+
 static int devfreq_notify_transition(struct devfreq *devfreq,
 		struct devfreq_freqs *freqs, unsigned int state)
 {
@@ -646,9 +690,8 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	mutex_unlock(&devfreq->lock);
 
 	mutex_lock(&devfreq_list_lock);
-	list_add(&devfreq->node, &devfreq_list);
 
-	governor = find_devfreq_governor(devfreq->governor_name);
+	governor = try_then_request_governor(devfreq->governor_name);
 	if (IS_ERR(governor)) {
 		dev_err(dev, "%s: Unable to find governor for the device\n",
 			__func__);
@@ -664,12 +707,14 @@ struct devfreq *devfreq_add_device(struct device *dev,
 			__func__);
 		goto err_init;
 	}
+
+	list_add(&devfreq->node, &devfreq_list);
+
 	mutex_unlock(&devfreq_list_lock);
 
 	return devfreq;
 
 err_init:
-	list_del(&devfreq->node);
 	mutex_unlock(&devfreq_list_lock);
 
 	device_unregister(&devfreq->dev);
@@ -991,7 +1036,7 @@ static ssize_t governor_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	mutex_lock(&devfreq_list_lock);
-	governor = find_devfreq_governor(str_governor);
+	governor = try_then_request_governor(str_governor);
 	if (IS_ERR(governor)) {
 		ret = PTR_ERR(governor);
 		goto out;
-- 
2.20.1



