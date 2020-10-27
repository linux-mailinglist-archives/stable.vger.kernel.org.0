Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3166229AFB5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507081AbgJ0OMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2508845AbgJ0OFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:05:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F57C22258;
        Tue, 27 Oct 2020 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807544;
        bh=QG/7ueEdEbsOxP7DxEbnpurwvC9xet4KgQ6y7mIGmCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYqbLct4nn8LP8U0J1+a8vfixncb8neUu5oHiXn6rjkfRzcnzleRHLeiM0Mhh7LL7
         RnF19rPcS1J82kN+xon/3umJZ2eFlN5AlP2ljZmOqDdPdCtUkSuT2J2s3qgJsAW3yr
         ieGYTdEd7N/vhDfmfo10J1X6ohh0Rq1fe/pihmU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 091/139] powerpc/powernv/dump: Fix race while processing OPAL dump
Date:   Tue, 27 Oct 2020 14:49:45 +0100
Message-Id: <20201027134906.454688257@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>

[ Upstream commit 0a43ae3e2beb77e3481d812834d33abe270768ab ]

Every dump reported by OPAL is exported to userspace through a sysfs
interface and notified using kobject_uevent(). The userspace daemon
(opal_errd) then reads the dump and acknowledges that the dump is
saved safely to disk. Once acknowledged the kernel removes the
respective sysfs file entry causing respective resources to be
released including kobject.

However it's possible the userspace daemon may already be scanning
dump entries when a new sysfs dump entry is created by the kernel.
User daemon may read this new entry and ack it even before kernel can
notify userspace about it through kobject_uevent() call. If that
happens then we have a potential race between
dump_ack_store->kobject_put() and kobject_uevent which can lead to
use-after-free of a kernfs object resulting in a kernel crash.

This patch fixes this race by protecting the sysfs file
creation/notification by holding a reference count on kobject until we
safely send kobject_uevent().

The function create_dump_obj() returns the dump object which if used
by caller function will end up in use-after-free problem again.
However, the return value of create_dump_obj() function isn't being
used today and there is no need as well. Hence change it to return
void to make this fix complete.

Fixes: c7e64b9ce04a ("powerpc/powernv Platform dump interface")
Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201017164210.264619-1-hegdevasant@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-dump.c | 41 +++++++++++++++-------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-dump.c b/arch/powerpc/platforms/powernv/opal-dump.c
index 4c827826c05eb..e21e2c0af69d2 100644
--- a/arch/powerpc/platforms/powernv/opal-dump.c
+++ b/arch/powerpc/platforms/powernv/opal-dump.c
@@ -319,15 +319,14 @@ static ssize_t dump_attr_read(struct file *filep, struct kobject *kobj,
 	return count;
 }
 
-static struct dump_obj *create_dump_obj(uint32_t id, size_t size,
-					uint32_t type)
+static void create_dump_obj(uint32_t id, size_t size, uint32_t type)
 {
 	struct dump_obj *dump;
 	int rc;
 
 	dump = kzalloc(sizeof(*dump), GFP_KERNEL);
 	if (!dump)
-		return NULL;
+		return;
 
 	dump->kobj.kset = dump_kset;
 
@@ -347,21 +346,39 @@ static struct dump_obj *create_dump_obj(uint32_t id, size_t size,
 	rc = kobject_add(&dump->kobj, NULL, "0x%x-0x%x", type, id);
 	if (rc) {
 		kobject_put(&dump->kobj);
-		return NULL;
+		return;
 	}
 
+	/*
+	 * As soon as the sysfs file for this dump is created/activated there is
+	 * a chance the opal_errd daemon (or any userspace) might read and
+	 * acknowledge the dump before kobject_uevent() is called. If that
+	 * happens then there is a potential race between
+	 * dump_ack_store->kobject_put() and kobject_uevent() which leads to a
+	 * use-after-free of a kernfs object resulting in a kernel crash.
+	 *
+	 * To avoid that, we need to take a reference on behalf of the bin file,
+	 * so that our reference remains valid while we call kobject_uevent().
+	 * We then drop our reference before exiting the function, leaving the
+	 * bin file to drop the last reference (if it hasn't already).
+	 */
+
+	/* Take a reference for the bin file */
+	kobject_get(&dump->kobj);
 	rc = sysfs_create_bin_file(&dump->kobj, &dump->dump_attr);
-	if (rc) {
+	if (rc == 0) {
+		kobject_uevent(&dump->kobj, KOBJ_ADD);
+
+		pr_info("%s: New platform dump. ID = 0x%x Size %u\n",
+			__func__, dump->id, dump->size);
+	} else {
+		/* Drop reference count taken for bin file */
 		kobject_put(&dump->kobj);
-		return NULL;
 	}
 
-	pr_info("%s: New platform dump. ID = 0x%x Size %u\n",
-		__func__, dump->id, dump->size);
-
-	kobject_uevent(&dump->kobj, KOBJ_ADD);
-
-	return dump;
+	/* Drop our reference */
+	kobject_put(&dump->kobj);
+	return;
 }
 
 static irqreturn_t process_dump(int irq, void *data)
-- 
2.25.1



