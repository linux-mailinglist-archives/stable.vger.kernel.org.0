Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B2740142B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbhIFBck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243311AbhIFB3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C71261186;
        Mon,  6 Sep 2021 01:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891402;
        bh=I5llsKYYxFWQTyhl7lYYfvhIRgWslQdGtn9D9lLw5jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSQ5gppWxEcQAUXnEqPkjUu/EDeRIdT8R/Nbn7nbDnOv2lFK8MB6sdmR9EXWJVnKm
         7CEUQ+dsAp94GwpZB3fKzRY8iKnhdcnhajqKg22clk2kk7spn3vJwXNBL8Hn+NdKxI
         RYy1VudLRrZWQy+j2TYQISQHCWJG5KH9uHSmBHNm3WMp75VG6iBgjH9UnNwAAn69i8
         SqMi9QoRDEZhUUiuQJVwS4WFQv/vOpbVZ93wdndZYNmEXWbyMtOfLC0MaxXwqs765U
         CrGD4gxO8uxdSShIEoRVAFyDUi837rY9f7/fe5QKCFU+RxIuzYZNR67NHv9HviUMc1
         QnKOpgKEiEJjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/30] s390/debug: fix debug area life cycle
Date:   Sun,  5 Sep 2021 21:22:43 -0400
Message-Id: <20210906012244.930338-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 9372a82892c2caa6bccab9a4081166fa769699f8 ]

Currently allocation and registration of s390dbf debug areas are tied
together. As a result, a debug area cannot be unregistered and
re-registered while any process has an associated debugfs file open.

Fix this by splitting alloc/release from register/unregister.

Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 102 +++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 46 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 7184d55d87aa..b1aadc3ad065 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -327,24 +327,6 @@ static debug_info_t *debug_info_create(const char *name, int pages_per_area,
 		goto out;
 
 	rc->mode = mode & ~S_IFMT;
-
-	/* create root directory */
-	rc->debugfs_root_entry = debugfs_create_dir(rc->name,
-						    debug_debugfs_root_entry);
-
-	/* append new element to linked list */
-	if (!debug_area_first) {
-		/* first element in list */
-		debug_area_first = rc;
-		rc->prev = NULL;
-	} else {
-		/* append element to end of list */
-		debug_area_last->next = rc;
-		rc->prev = debug_area_last;
-	}
-	debug_area_last = rc;
-	rc->next = NULL;
-
 	refcount_set(&rc->ref_count, 1);
 out:
 	return rc;
@@ -404,27 +386,10 @@ static void debug_info_get(debug_info_t *db_info)
  */
 static void debug_info_put(debug_info_t *db_info)
 {
-	int i;
-
 	if (!db_info)
 		return;
-	if (refcount_dec_and_test(&db_info->ref_count)) {
-		for (i = 0; i < DEBUG_MAX_VIEWS; i++) {
-			if (!db_info->views[i])
-				continue;
-			debugfs_remove(db_info->debugfs_entries[i]);
-		}
-		debugfs_remove(db_info->debugfs_root_entry);
-		if (db_info == debug_area_first)
-			debug_area_first = db_info->next;
-		if (db_info == debug_area_last)
-			debug_area_last = db_info->prev;
-		if (db_info->prev)
-			db_info->prev->next = db_info->next;
-		if (db_info->next)
-			db_info->next->prev = db_info->prev;
+	if (refcount_dec_and_test(&db_info->ref_count))
 		debug_info_free(db_info);
-	}
 }
 
 /*
@@ -648,6 +613,31 @@ static int debug_close(struct inode *inode, struct file *file)
 	return 0; /* success */
 }
 
+/* Create debugfs entries and add to internal list. */
+static void _debug_register(debug_info_t *id)
+{
+	/* create root directory */
+	id->debugfs_root_entry = debugfs_create_dir(id->name,
+						    debug_debugfs_root_entry);
+
+	/* append new element to linked list */
+	if (!debug_area_first) {
+		/* first element in list */
+		debug_area_first = id;
+		id->prev = NULL;
+	} else {
+		/* append element to end of list */
+		debug_area_last->next = id;
+		id->prev = debug_area_last;
+	}
+	debug_area_last = id;
+	id->next = NULL;
+
+	debug_register_view(id, &debug_level_view);
+	debug_register_view(id, &debug_flush_view);
+	debug_register_view(id, &debug_pages_view);
+}
+
 /**
  * debug_register_mode() - creates and initializes debug area.
  *
@@ -677,19 +667,16 @@ debug_info_t *debug_register_mode(const char *name, int pages_per_area,
 	if ((uid != 0) || (gid != 0))
 		pr_warn("Root becomes the owner of all s390dbf files in sysfs\n");
 	BUG_ON(!initialized);
-	mutex_lock(&debug_mutex);
 
 	/* create new debug_info */
 	rc = debug_info_create(name, pages_per_area, nr_areas, buf_size, mode);
-	if (!rc)
-		goto out;
-	debug_register_view(rc, &debug_level_view);
-	debug_register_view(rc, &debug_flush_view);
-	debug_register_view(rc, &debug_pages_view);
-out:
-	if (!rc)
+	if (rc) {
+		mutex_lock(&debug_mutex);
+		_debug_register(rc);
+		mutex_unlock(&debug_mutex);
+	} else {
 		pr_err("Registering debug feature %s failed\n", name);
-	mutex_unlock(&debug_mutex);
+	}
 	return rc;
 }
 EXPORT_SYMBOL(debug_register_mode);
@@ -718,6 +705,27 @@ debug_info_t *debug_register(const char *name, int pages_per_area,
 }
 EXPORT_SYMBOL(debug_register);
 
+/* Remove debugfs entries and remove from internal list. */
+static void _debug_unregister(debug_info_t *id)
+{
+	int i;
+
+	for (i = 0; i < DEBUG_MAX_VIEWS; i++) {
+		if (!id->views[i])
+			continue;
+		debugfs_remove(id->debugfs_entries[i]);
+	}
+	debugfs_remove(id->debugfs_root_entry);
+	if (id == debug_area_first)
+		debug_area_first = id->next;
+	if (id == debug_area_last)
+		debug_area_last = id->prev;
+	if (id->prev)
+		id->prev->next = id->next;
+	if (id->next)
+		id->next->prev = id->prev;
+}
+
 /**
  * debug_unregister() - give back debug area.
  *
@@ -731,8 +739,10 @@ void debug_unregister(debug_info_t *id)
 	if (!id)
 		return;
 	mutex_lock(&debug_mutex);
-	debug_info_put(id);
+	_debug_unregister(id);
 	mutex_unlock(&debug_mutex);
+
+	debug_info_put(id);
 }
 EXPORT_SYMBOL(debug_unregister);
 
-- 
2.30.2

