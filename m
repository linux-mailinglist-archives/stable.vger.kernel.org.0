Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6DB354421
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242076AbhDEQEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242023AbhDEQEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9201F613BD;
        Mon,  5 Apr 2021 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638659;
        bh=KiRO2M5P4mOboiQ2OeqLUThTGmklM83OiWk9WfyDFAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZ+ht9qn8xB3ug4Q/ojXX6R+1jex9y9roljd9Bh6wk6qhZskqzWMc08wZQOuRXLlW
         tkjXV3VFAZ649I+UBcAPgsZld7jGAv0E+d2B6D2kbxK68GbL9o09om+aVTSN/YTXAM
         Epjw6KOe7PVDqvkRjRxIpzKS6xehBATv63k8ucFs5Ld6OMTRHNNpEmUMcss6rRPy3O
         4OIKBAhvHFcQK3Fluxlo3fHKddY4RbvKCxbI8q5oSBWa/zVMoE2JKO4lGE+xtlqhBi
         L1gHTQIRolgNEHvcFqAeS+lk5oqQQrDwncFc7K3OgtTRRqIG/QY3voyWWdtr9OULig
         DfbfE/RwSNkCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 11/22] gpu: host1x: Use different lock classes for each client
Date:   Mon,  5 Apr 2021 12:03:54 -0400
Message-Id: <20210405160406.268132-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit a24f98176d1efae2c37d3438c57a624d530d9c33 ]

To avoid false lockdep warnings, give each client lock a different
lock class, passed from the initialization site by macro.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/bus.c | 10 ++++++----
 include/linux/host1x.h   |  9 ++++++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index 347fb962b6c9..68a766ff0e9d 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -705,8 +705,9 @@ void host1x_driver_unregister(struct host1x_driver *driver)
 EXPORT_SYMBOL(host1x_driver_unregister);
 
 /**
- * host1x_client_register() - register a host1x client
+ * __host1x_client_register() - register a host1x client
  * @client: host1x client
+ * @key: lock class key for the client-specific mutex
  *
  * Registers a host1x client with each host1x controller instance. Note that
  * each client will only match their parent host1x controller and will only be
@@ -715,13 +716,14 @@ EXPORT_SYMBOL(host1x_driver_unregister);
  * device and call host1x_device_init(), which will in turn call each client's
  * &host1x_client_ops.init implementation.
  */
-int host1x_client_register(struct host1x_client *client)
+int __host1x_client_register(struct host1x_client *client,
+			     struct lock_class_key *key)
 {
 	struct host1x *host1x;
 	int err;
 
 	INIT_LIST_HEAD(&client->list);
-	mutex_init(&client->lock);
+	__mutex_init(&client->lock, "host1x client lock", key);
 	client->usecount = 0;
 
 	mutex_lock(&devices_lock);
@@ -742,7 +744,7 @@ int host1x_client_register(struct host1x_client *client)
 
 	return 0;
 }
-EXPORT_SYMBOL(host1x_client_register);
+EXPORT_SYMBOL(__host1x_client_register);
 
 /**
  * host1x_client_unregister() - unregister a host1x client
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index ce59a6a6a008..9eb77c87a83b 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -320,7 +320,14 @@ static inline struct host1x_device *to_host1x_device(struct device *dev)
 int host1x_device_init(struct host1x_device *device);
 int host1x_device_exit(struct host1x_device *device);
 
-int host1x_client_register(struct host1x_client *client);
+int __host1x_client_register(struct host1x_client *client,
+			     struct lock_class_key *key);
+#define host1x_client_register(class) \
+	({ \
+		static struct lock_class_key __key; \
+		__host1x_client_register(class, &__key); \
+	})
+
 int host1x_client_unregister(struct host1x_client *client);
 
 int host1x_client_suspend(struct host1x_client *client);
-- 
2.30.2

