Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226B120E2F6
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgF2VK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbgF2TAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F994254FC;
        Mon, 29 Jun 2020 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446061;
        bh=qPqhZbaBo0od5NWPsru4eNGCRDQdrdwliNF/YonIXJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFpxt1f4tb2q0aGO+pVIssxIql0T8xxw2oFLqBkGQS5BKkaTcw1jp+eNslh1BtPIh
         hcdN9BVmdevcw7eXvyUjnhXHcY7lJlyVBOYTeZc3d7Sau1ijeiiyYytkQ++4tGCgKX
         Z0WL+Hjzpn5tg8LsKZ6OtEejQM/P/+HE6Io5oL4E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 060/135] libata: Use per port sync for detach
Date:   Mon, 29 Jun 2020 11:51:54 -0400
Message-Id: <20200629155309.2495516-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit b5292111de9bb70cba3489075970889765302136 ]

Commit 130f4caf145c ("libata: Ensure ata_port probe has completed before
detach") may cause system freeze during suspend.

Using async_synchronize_full() in PM callbacks is wrong, since async
callbacks that are already scheduled may wait for not-yet-scheduled
callbacks, causes a circular dependency.

Instead of using big hammer like async_synchronize_full(), use async
cookie to make sure port probe are synced, without affecting other
scheduled PM callbacks.

Fixes: 130f4caf145c ("libata: Ensure ata_port probe has completed before detach")
Suggested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: John Garry <john.garry@huawei.com>
BugLink: https://bugs.launchpad.net/bugs/1867983
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 11 +++++------
 include/linux/libata.h    |  3 +++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fc4bf8ff40ead..17cebfe5acc82 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -56,7 +56,6 @@
 #include <linux/workqueue.h>
 #include <linux/scatterlist.h>
 #include <linux/io.h>
-#include <linux/async.h>
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/glob.h>
@@ -6222,7 +6221,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	/* perform each probe asynchronously */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
-		async_schedule(async_port_probe, ap);
+		ap->cookie = async_schedule(async_port_probe, ap);
 	}
 
 	return 0;
@@ -6355,11 +6354,11 @@ void ata_host_detach(struct ata_host *host)
 {
 	int i;
 
-	/* Ensure ata_port probe has completed */
-	async_synchronize_full();
-
-	for (i = 0; i < host->n_ports; i++)
+	for (i = 0; i < host->n_ports; i++) {
+		/* Ensure ata_port probe has completed */
+		async_synchronize_cookie(host->ports[i]->cookie + 1);
 		ata_port_detach(host->ports[i]);
+	}
 
 	/* the host is dead now, dissociate ACPI */
 	ata_acpi_dissociate(host);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6428ac4746dee..af561d33221d6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -38,6 +38,7 @@
 #include <linux/acpi.h>
 #include <linux/cdrom.h>
 #include <linux/sched.h>
+#include <linux/async.h>
 
 /*
  * Define if arch has non-standard setup.  This is a _PCI_ standard
@@ -872,6 +873,8 @@ struct ata_port {
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
 
+	async_cookie_t		cookie;
+
 	int			em_message_type;
 	void			*private_data;
 
-- 
2.25.1

