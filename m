Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0459C3A9FBD
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbhFPPk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235166AbhFPPi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86B0561001;
        Wed, 16 Jun 2021 15:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857794;
        bh=WAvtrtWWjjvzCVy0TOakzrb66OFhDwickR7bZRqaqAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nd1UAr6N4zQmpb9qaAWCTUbjQb67nT/sTfIBJL+M+VMhj2pisy1JaXmdYRLTGLcVH
         l0qJmNfuflVXv507ryCsTWl1QBwyg6ospJSvxyZW129e0rUeNqPOs3BdpAptUwhydH
         st2NKNMkYlTmG909itx707O5JcDHdPd+VnV6kGzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/38] gpu: host1x: Split up client initalization and registration
Date:   Wed, 16 Jun 2021 17:33:20 +0200
Message-Id: <20210616152835.757052232@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



