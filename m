Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCF22A5863
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbgKCVuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731634AbgKCUst (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2C3A22409;
        Tue,  3 Nov 2020 20:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436528;
        bh=1dwYbPMQBXAQKaz+SOdJ4IiZ66CnPun/MaRc7YvlahA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgnoxVn6hFiNCeB0m0k1cBXvT/MdTcv70RE3YFb8htq0iC8IDiwXZXd2fmiWEE4sJ
         4BzioKa6cUhk8ov7k7piWhHrBONv3dx3asfTra+oUnCc3g8GEgPGl+T7w70SBQDjr7
         BmtHS43LFjZaMBudVfIpqaQ7Wsm/k6+HRrSddw1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 289/391] powerpc/powernv/elog: Fix race while processing OPAL error log event.
Date:   Tue,  3 Nov 2020 21:35:40 +0100
Message-Id: <20201103203406.550411806@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.ibm.com>

commit aea948bb80b478ddc2448f7359d574387521a52d upstream.

Every error log reported by OPAL is exported to userspace through a
sysfs interface and notified using kobject_uevent(). The userspace
daemon (opal_errd) then reads the error log and acknowledges the error
log is saved safely to disk. Once acknowledged the kernel removes the
respective sysfs file entry causing respective resources to be
released including kobject.

However it's possible the userspace daemon may already be scanning
elog entries when a new sysfs elog entry is created by the kernel.
User daemon may read this new entry and ack it even before kernel can
notify userspace about it through kobject_uevent() call. If that
happens then we have a potential race between
elog_ack_store->kobject_put() and kobject_uevent which can lead to
use-after-free of a kernfs object resulting in a kernel crash. eg:

  BUG: Unable to handle kernel data access on read at 0x6b6b6b6b6b6b6bfb
  Faulting instruction address: 0xc0000000008ff2a0
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA PowerNV
  CPU: 27 PID: 805 Comm: irq/29-opal-elo Not tainted 5.9.0-rc2-gcc-8.2.0-00214-g6f56a67bcbb5-dirty #363
  ...
  NIP kobject_uevent_env+0xa0/0x910
  LR  elog_event+0x1f4/0x2d0
  Call Trace:
    0x5deadbeef0000122 (unreliable)
    elog_event+0x1f4/0x2d0
    irq_thread_fn+0x4c/0xc0
    irq_thread+0x1c0/0x2b0
    kthread+0x1c4/0x1d0
    ret_from_kernel_thread+0x5c/0x6c

This patch fixes this race by protecting the sysfs file
creation/notification by holding a reference count on kobject until we
safely send kobject_uevent().

The function create_elog_obj() returns the elog object which if used
by caller function will end up in use-after-free problem again.
However, the return value of create_elog_obj() function isn't being
used today and there is no need as well. Hence change it to return
void to make this fix complete.

Fixes: 774fea1a38c6 ("powerpc/powernv: Read OPAL error log and export it through sysfs")
Cc: stable@vger.kernel.org # v3.15+
Reported-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Oliver O'Halloran <oohall@gmail.com>
Reviewed-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
[mpe: Rework the logic to use a single return, reword comments, add oops]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201006122051.190176-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal-elog.c |   33 ++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/arch/powerpc/platforms/powernv/opal-elog.c
+++ b/arch/powerpc/platforms/powernv/opal-elog.c
@@ -179,14 +179,14 @@ static ssize_t raw_attr_read(struct file
 	return count;
 }
 
-static struct elog_obj *create_elog_obj(uint64_t id, size_t size, uint64_t type)
+static void create_elog_obj(uint64_t id, size_t size, uint64_t type)
 {
 	struct elog_obj *elog;
 	int rc;
 
 	elog = kzalloc(sizeof(*elog), GFP_KERNEL);
 	if (!elog)
-		return NULL;
+		return;
 
 	elog->kobj.kset = elog_kset;
 
@@ -219,18 +219,37 @@ static struct elog_obj *create_elog_obj(
 	rc = kobject_add(&elog->kobj, NULL, "0x%llx", id);
 	if (rc) {
 		kobject_put(&elog->kobj);
-		return NULL;
+		return;
 	}
 
+	/*
+	 * As soon as the sysfs file for this elog is created/activated there is
+	 * a chance the opal_errd daemon (or any userspace) might read and
+	 * acknowledge the elog before kobject_uevent() is called. If that
+	 * happens then there is a potential race between
+	 * elog_ack_store->kobject_put() and kobject_uevent() which leads to a
+	 * use-after-free of a kernfs object resulting in a kernel crash.
+	 *
+	 * To avoid that, we need to take a reference on behalf of the bin file,
+	 * so that our reference remains valid while we call kobject_uevent().
+	 * We then drop our reference before exiting the function, leaving the
+	 * bin file to drop the last reference (if it hasn't already).
+	 */
+
+	/* Take a reference for the bin file */
+	kobject_get(&elog->kobj);
 	rc = sysfs_create_bin_file(&elog->kobj, &elog->raw_attr);
-	if (rc) {
+	if (rc == 0) {
+		kobject_uevent(&elog->kobj, KOBJ_ADD);
+	} else {
+		/* Drop the reference taken for the bin file */
 		kobject_put(&elog->kobj);
-		return NULL;
 	}
 
-	kobject_uevent(&elog->kobj, KOBJ_ADD);
+	/* Drop our reference */
+	kobject_put(&elog->kobj);
 
-	return elog;
+	return;
 }
 
 static irqreturn_t elog_event(int irq, void *data)


