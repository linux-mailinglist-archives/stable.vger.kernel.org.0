Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C2F39E1ED
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhFGQOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231380AbhFGQO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55BC5613BD;
        Mon,  7 Jun 2021 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082355;
        bh=LWe4nsbdJinjqdQMzeE2+qRiLbJd5/AiKwAPmIQ8lJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKMq+JPs3NF9tDPxLsf0Y8mDSTFDKWh9lhNNO26h0MBoqcg86yTyED1AUcCwOqYF0
         TKpWqXvBG214tJYijpkxmLO/CTLdEy/czggB7hZkpbp0SwLdkRP9jAaKykTE1pNI7t
         3P4YLdoIOCzZrDZjLkHtJYx1S6gQwQ9bpqIW6d15C57K9o83XpIaEVkA2M3FfII4k/
         aWSYu+jx4WtQzvTNeJsT/Buky81hA62NQlSkPJgE9Hq2W57pNwPdIdQdLCPOrALz3L
         mXOdzwElgIbG18biDqi0lGvl/gKPPtlp17yQmsf2hVnY8rq1rj7gAsPF9ZnXj2hj9P
         QUZ9G5TeKZq0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 15/49] gpu: host1x: Split up client initalization and registration
Date:   Mon,  7 Jun 2021 12:11:41 -0400
Message-Id: <20210607161215.3583176-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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
index 68a766ff0e9d..b98d746141a8 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -704,6 +704,29 @@ void host1x_driver_unregister(struct host1x_driver *driver)
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
@@ -716,16 +739,11 @@ EXPORT_SYMBOL(host1x_driver_unregister);
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

