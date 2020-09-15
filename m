Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF2826B5EF
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgIOXyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgIOObd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 819F122286;
        Tue, 15 Sep 2020 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179809;
        bh=SHuSU+k8OrvLzPJRltIRpm+dwKO3tCsWi5jsnzDI+iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKctlNJxW+kaS/QgxV08+CMovkKzqgFLj34y/Gb+gw8Zl8DiRoqyTWiLafRAwyNXP
         SbXAg2BpC742v46T4jI3e6jiTNLqYjPdM+6SjiK7i4V5csY9nkxq5TBcSl+RZ4It3b
         zR0+fSOckLdqoOOwn2H5yPuqQxYErTDtjxu7JpnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 097/132] regulator: push allocations in create_regulator() outside of lock
Date:   Tue, 15 Sep 2020 16:13:19 +0200
Message-Id: <20200915140649.008785093@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 87fe29b61f9522a3d7b60a4580851f548558186f upstream.

Move all allocations outside of the regulator_lock()ed section.

======================================================
WARNING: possible circular locking dependency detected
5.7.13+ #535 Not tainted
------------------------------------------------------
f2fs_discard-179:7/702 is trying to acquire lock:
c0e5d920 (regulator_list_mutex){+.+.}-{3:3}, at: regulator_lock_dependent+0x54/0x2c0

but task is already holding lock:
cb95b080 (&dcc->cmd_lock){+.+.}-{3:3}, at: __issue_discard_cmd+0xec/0x5f8

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

[...]

-> #3 (fs_reclaim){+.+.}-{0:0}:
       fs_reclaim_acquire.part.11+0x40/0x50
       fs_reclaim_acquire+0x24/0x28
       __kmalloc_track_caller+0x54/0x218
       kstrdup+0x40/0x5c
       create_regulator+0xf4/0x368
       regulator_resolve_supply+0x1a0/0x200
       regulator_register+0x9c8/0x163c

[...]

other info that might help us debug this:

Chain exists of:
  regulator_list_mutex --> &sit_i->sentry_lock --> &dcc->cmd_lock

[...]

Fixes: f8702f9e4aa7 ("regulator: core: Use ww_mutex for regulators locking")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/6eebc99b2474f4ffaa0405b15178ece0e7e4f608.1597195321.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   53 ++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1575,44 +1575,53 @@ static struct regulator *create_regulato
 					  const char *supply_name)
 {
 	struct regulator *regulator;
-	char buf[REG_STR_SIZE];
-	int err, size;
+	int err;
+
+	if (dev) {
+		char buf[REG_STR_SIZE];
+		int size;
+
+		size = snprintf(buf, REG_STR_SIZE, "%s-%s",
+				dev->kobj.name, supply_name);
+		if (size >= REG_STR_SIZE)
+			return NULL;
+
+		supply_name = kstrdup(buf, GFP_KERNEL);
+		if (supply_name == NULL)
+			return NULL;
+	} else {
+		supply_name = kstrdup_const(supply_name, GFP_KERNEL);
+		if (supply_name == NULL)
+			return NULL;
+	}
 
 	regulator = kzalloc(sizeof(*regulator), GFP_KERNEL);
-	if (regulator == NULL)
+	if (regulator == NULL) {
+		kfree(supply_name);
 		return NULL;
+	}
 
-	regulator_lock(rdev);
 	regulator->rdev = rdev;
+	regulator->supply_name = supply_name;
+
+	regulator_lock(rdev);
 	list_add(&regulator->list, &rdev->consumer_list);
+	regulator_unlock(rdev);
 
 	if (dev) {
 		regulator->dev = dev;
 
 		/* Add a link to the device sysfs entry */
-		size = snprintf(buf, REG_STR_SIZE, "%s-%s",
-				dev->kobj.name, supply_name);
-		if (size >= REG_STR_SIZE)
-			goto overflow_err;
-
-		regulator->supply_name = kstrdup(buf, GFP_KERNEL);
-		if (regulator->supply_name == NULL)
-			goto overflow_err;
-
 		err = sysfs_create_link_nowarn(&rdev->dev.kobj, &dev->kobj,
-					buf);
+					       supply_name);
 		if (err) {
 			rdev_dbg(rdev, "could not add device link %s err %d\n",
 				  dev->kobj.name, err);
 			/* non-fatal */
 		}
-	} else {
-		regulator->supply_name = kstrdup_const(supply_name, GFP_KERNEL);
-		if (regulator->supply_name == NULL)
-			goto overflow_err;
 	}
 
-	regulator->debugfs = debugfs_create_dir(regulator->supply_name,
+	regulator->debugfs = debugfs_create_dir(supply_name,
 						rdev->debugfs);
 	if (!regulator->debugfs) {
 		rdev_dbg(rdev, "Failed to create debugfs directory\n");
@@ -1637,13 +1646,7 @@ static struct regulator *create_regulato
 	    _regulator_is_enabled(rdev))
 		regulator->always_on = true;
 
-	regulator_unlock(rdev);
 	return regulator;
-overflow_err:
-	list_del(&regulator->list);
-	kfree(regulator);
-	regulator_unlock(rdev);
-	return NULL;
 }
 
 static int _regulator_get_enable_time(struct regulator_dev *rdev)


