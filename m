Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4043FDB79
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbhIAMlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344896AbhIAMkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CFBE610E7;
        Wed,  1 Sep 2021 12:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499769;
        bh=jVGFFhgQPDsIekeU6Mj58mUSZo3WAIr1rV2jD2J8/kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm4iVubeHqfAI01LyABwTe1qx05lGvytHK34hub3B8oIxPPOdjzfN/3j/AFDJvkta
         VIU9+0xt7nkYbYFXKhadCMNioGPUM9tecdZFxwv0wsltewJthB7v24wb2HrouYpP59
         MfjBa9U4f/SjVaoj0SF5/e+hPw/TcdI4xu1roT3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/103] tools/virtio: fix build
Date:   Wed,  1 Sep 2021 14:28:11 +0200
Message-Id: <20210901122302.613323933@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit a24ce06c70fe7df795a846ad713ccaa9b56a7666 ]

We use a spinlock now so add a stub.
Ignore bogus uninitialized variable warnings.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/Makefile         |  3 +-
 tools/virtio/linux/spinlock.h | 56 +++++++++++++++++++++++++++++++++++
 tools/virtio/linux/virtio.h   |  2 ++
 3 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 tools/virtio/linux/spinlock.h

diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index b587b9a7a124..0d7bbe49359d 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -4,7 +4,8 @@ test: virtio_test vringh_test
 virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
-CFLAGS += -g -O2 -Werror -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
+CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
+LDFLAGS += -lpthread
 vpath %.c ../../drivers/virtio ../../drivers/vhost
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test V=${V}
diff --git a/tools/virtio/linux/spinlock.h b/tools/virtio/linux/spinlock.h
new file mode 100644
index 000000000000..028e3cdcc5d3
--- /dev/null
+++ b/tools/virtio/linux/spinlock.h
@@ -0,0 +1,56 @@
+#ifndef SPINLOCK_H_STUB
+#define SPINLOCK_H_STUB
+
+#include <pthread.h>
+
+typedef pthread_spinlock_t  spinlock_t;
+
+static inline void spin_lock_init(spinlock_t *lock)
+{
+	int r = pthread_spin_init(lock, 0);
+	assert(!r);
+}
+
+static inline void spin_lock(spinlock_t *lock)
+{
+	int ret = pthread_spin_lock(lock);
+	assert(!ret);
+}
+
+static inline void spin_unlock(spinlock_t *lock)
+{
+	int ret = pthread_spin_unlock(lock);
+	assert(!ret);
+}
+
+static inline void spin_lock_bh(spinlock_t *lock)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_bh(spinlock_t *lock)
+{
+	spin_unlock(lock);
+}
+
+static inline void spin_lock_irq(spinlock_t *lock)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_irq(spinlock_t *lock)
+{
+	spin_unlock(lock);
+}
+
+static inline void spin_lock_irqsave(spinlock_t *lock, unsigned long f)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_irqrestore(spinlock_t *lock, unsigned long f)
+{
+	spin_unlock(lock);
+}
+
+#endif
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 5d90254ddae4..363b98228301 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -3,6 +3,7 @@
 #define LINUX_VIRTIO_H
 #include <linux/scatterlist.h>
 #include <linux/kernel.h>
+#include <linux/spinlock.h>
 
 struct device {
 	void *parent;
@@ -12,6 +13,7 @@ struct virtio_device {
 	struct device dev;
 	u64 features;
 	struct list_head vqs;
+	spinlock_t vqs_list_lock;
 };
 
 struct virtqueue {
-- 
2.30.2



