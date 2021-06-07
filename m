Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4DF39E262
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhFGQQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231799AbhFGQPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D989461435;
        Mon,  7 Jun 2021 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082413;
        bh=WAvtrtWWjjvzCVy0TOakzrb66OFhDwickR7bZRqaqAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPFvbRAj2+KaJwJz1sSveo/C4inoK5y7WtsyLvDcIcx/QKYqGXlLxmagt57+kWBhF
         oURsTDmQHI5eARWB+LeWR3RM8RcLGmOHQWPfbec1MQG/Kc9sQCzsEv4slGPDt3mJxE
         0PIDfBKNhVXYBJKhjmbBlILseXTzOV7yv4T0ooe502WrPyT9svftOnvchp+rQse3PX
         xSsqOKd8ukAtIHGbLrDA4mk8Ep0ATyp3PywaliK7Ahl+BGfenKYD9cSsJjMx005ZYw
         XwVsMOM7ylUYs8AS4OpUwDsYW3l5LEAqllJuUHfuJAuUG9sFs8St+VI5w2/JROHzU4
         XuYVZU3532faw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/39] gpu: host1x: Split up client initalization and registration
Date:   Mon,  7 Jun 2021 12:12:50 -0400
Message-Id: <20210607161318.3583636-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 0cfe5a6e758fb20be8ad3e8f10cb087cc8033eeb ]

In some cases we may need to initialize the host1x client first before
registering it. This commit adds a new helper that will do nothing but
the initialization of the data structure.

At the same time, the initialization is removed from the registration
function. Note, however, that for simplicity we explicitly initialize
the client when the host1x_client_register() function is called, as
opposed to the low-level __host1x_client_register() function. This
allows existing callers to remain unchanged.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/bus.c | 30 ++++++++++++++++++++++++------
 include/linux/host1x.h   | 30 ++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index 9e2cb6968819..6e3b49d0de66 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -703,6 +703,29 @@ void host1x_driver_unregister(struct host1x_driver *driver)
 }
 EXPORT_SYMBOL(host1x_driver_unregister);
 
+/**
+ * __host1x_client_init() - initialize a host1x client
+ * @client: host1x client
+ * @key: lock class key for the client-specific mutex
+ */
+void __host1x_client_init(struct host1x_client *client, struct lock_class_key *key)
+{
+	INIT_LIST_HEAD(&client->list);
+	__mutex_init(&client->lock, "host1x client lock", key);
+	client->usecount = 0;
+}
+EXPORT_SYMBOL(__host1x_client_init);
+
+/**
+ * host1x_client_exit() - uninitialize a host1x client
+ * @client: host1x client
+ */
+void host1x_client_exit(struct host1x_client *client)
+{
+	mutex_destroy(&client->lock);
+}
+EXPORT_SYMBOL(host1x_client_exit);
+
 /**
  * __host1x_client_register() - register a host1x client
  * @client: host1x client
@@ -715,16 +738,11 @@ EXPORT_SYMBOL(host1x_driver_unregister);
  * device and call host1x_device_init(), which will in turn call each client's
  * &host1x_client_ops.init implementation.
  */
-int __host1x_client_register(struct host1x_client *client,
-			     struct lock_class_key *key)
+int __host1x_client_register(struct host1x_client *client)
 {
 	struct host1x *host1x;
 	int err;
 
-	INIT_LIST_HEAD(&client->list);
-	__mutex_init(&client->lock, "host1x client lock", key);
-	client->usecount = 0;
-
 	mutex_lock(&devices_lock);
 
 	list_for_each_entry(host1x, &devices, list) {
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index 9eb77c87a83b..ed0005ce4285 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -320,12 +320,30 @@ static inline struct host1x_device *to_host1x_device(struct device *dev)
 int host1x_device_init(struct host1x_device *device);
 int host1x_device_exit(struct host1x_device *device);
 
-int __host1x_client_register(struct host1x_client *client,
-			     struct lock_class_key *key);
-#define host1x_client_register(class) \
-	({ \
-		static struct lock_class_key __key; \
-		__host1x_client_register(class, &__key); \
+void __host1x_client_init(struct host1x_client *client, struct lock_class_key *key);
+void host1x_client_exit(struct host1x_client *client);
+
+#define host1x_client_init(client)			\
+	({						\
+		static struct lock_class_key __key;	\
+		__host1x_client_init(client, &__key);	\
+	})
+
+int __host1x_client_register(struct host1x_client *client);
+
+/*
+ * Note that this wrapper calls __host1x_client_init() for compatibility
+ * with existing callers. Callers that want to separately initialize and
+ * register a host1x client must first initialize using either of the
+ * __host1x_client_init() or host1x_client_init() functions and then use
+ * the low-level __host1x_client_register() function to avoid the client
+ * getting reinitialized.
+ */
+#define host1x_client_register(client)			\
+	({						\
+		static struct lock_class_key __key;	\
+		__host1x_client_init(client, &__key);	\
+		__host1x_client_register(client);	\
 	})
 
 int host1x_client_unregister(struct host1x_client *client);
-- 
2.30.2

