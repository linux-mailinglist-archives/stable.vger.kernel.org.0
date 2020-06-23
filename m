Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96967206328
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389386AbgFWUSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389329AbgFWUSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677432064B;
        Tue, 23 Jun 2020 20:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943488;
        bh=YGsIDItN95h1rPeyRWo05Da3ZqlmUTAwMlfmX1pfVUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5cewsCA8KqNazQr6FCrX04vl88CehIkSzMYBHLTy08RyDaXNO4Q9Z+/3tMf46rXP
         kaaatQ14Iexfs1iESeiwR6T8Kwe25Jt0NkP/W95SAkbNhoQ9NdTSNajhKDcP4D9DWt
         607qd+R5QmewVutFFEDdwbwyTtI77WbWf5E3GdmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 412/477] libata: Use per port sync for detach
Date:   Tue, 23 Jun 2020 21:56:49 +0200
Message-Id: <20200623195427.003726589@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index beca5f91bb4c7..e74c8fe2a5fdb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -42,7 +42,6 @@
 #include <linux/workqueue.h>
 #include <linux/scatterlist.h>
 #include <linux/io.h>
-#include <linux/async.h>
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/glob.h>
@@ -5778,7 +5777,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	/* perform each probe asynchronously */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
-		async_schedule(async_port_probe, ap);
+		ap->cookie = async_schedule(async_port_probe, ap);
 	}
 
 	return 0;
@@ -5920,11 +5919,11 @@ void ata_host_detach(struct ata_host *host)
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
index cffa4714bfa84..ae6dfc107ea82 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -22,6 +22,7 @@
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



