Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C4C3BD7F4
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 15:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhGFNnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 09:43:16 -0400
Received: from relay.sw.ru ([185.231.240.75]:36062 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232064AbhGFNnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 09:43:15 -0400
X-Greylist: delayed 1047 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jul 2021 09:43:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=zYN3y6K/Ru9pQCFBk1RENryPpJolMihOWyrIBqKeHAs=; b=XpVGZ1TNzgAa
        HS2iTgdubgzW26aKd5UbMIb4b3ZiYUYCj4zWSkxoB/iMNwoufRImmMsdzSnelRiDK8q8FTox4fNgH
        R2Kj/H/OsVIUZMNgbSgODzTY/CK/SLFBx6r5r1iSNO0smRxCLQJrQurtOdRs9C2WpJO+SFm0P9rjJ
        QD3ZU=;
Received: from [192.168.15.247] (helo=mikhalitsyn-laptop.sw.ru)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1m0l2a-0034RU-31; Tue, 06 Jul 2021 16:23:08 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Milton Miller <miltonm@bga.com>,
        Jack Miller <millerjo@us.ibm.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] shm: skip shm_destroy if task IPC namespace was changed
Date:   Tue,  6 Jul 2021 16:22:58 +0300
Message-Id: <20210706132259.71740-2-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210706132259.71740-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210706132259.71740-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Task may change IPC namespace by doing setns() but sysvshm
objects remains at the origin IPC namespace (=IPC namespace
where task was when shmget() was called). Let's skip forced
shm destroy in such case because we can't determine IPC
namespace by shm only. These problematic sysvshm's will
be destroyed on ipc namespace cleanup.

Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Milton Miller <miltonm@bga.com>
Cc: Jack Miller <millerjo@us.ibm.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 ipc/shm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 748933e376ca..70a41171b8bb 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -173,6 +173,14 @@ static inline struct shmid_kernel *shm_obtain_object_check(struct ipc_namespace
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
 
+static inline bool is_shm_in_ns(struct ipc_namespace *ns, struct shmid_kernel *shp)
+{
+	int idx = ipcid_to_idx(shp->shm_perm.id);
+	struct shmid_kernel *tshp = shm_obtain_object(ns, idx);
+
+	return !IS_ERR(tshp) && tshp == shp;
+}
+
 /*
  * shm_lock_(check_) routines are called in the paths where the rwsem
  * is not necessarily held.
@@ -415,7 +423,7 @@ void exit_shm(struct task_struct *task)
 	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
 		shp->shm_creator = NULL;
 
-		if (shm_may_destroy(ns, shp)) {
+		if (is_shm_in_ns(ns, shp) && shm_may_destroy(ns, shp)) {
 			shm_lock_by_ptr(shp);
 			shm_destroy(ns, shp);
 		}
-- 
2.31.1

