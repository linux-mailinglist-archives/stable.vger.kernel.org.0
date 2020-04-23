Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A701B693B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgDWXVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:21:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48538 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728200AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bI-Ej; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6jL-FH; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nikos Tsironis" <ntsironis@arrikto.com>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "Joe Thornber" <ejt@redhat.com>
Date:   Fri, 24 Apr 2020 00:04:52 +0100
Message-ID: <lsq.1587683028.792861446@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 065/245] dm thin metadata: Add support for a
 pre-commit callback
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nikos Tsironis <ntsironis@arrikto.com>

commit ecda7c0280e6b3398459dc589b9a41c1adb45529 upstream.

Add support for one pre-commit callback which is run right before the
metadata are committed.

This allows the thin provisioning target to run a callback before the
metadata are committed and is required by the next commit.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[bwh: Backported to 3.16:
 - Open-code pmd_write_{lock_in_core,unlock}()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-thin-metadata.c | 29 +++++++++++++++++++++++++++++
 drivers/md/dm-thin-metadata.h |  7 +++++++
 2 files changed, 36 insertions(+)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -198,6 +198,15 @@ struct dm_pool_metadata {
 	bool fail_io:1;
 
 	/*
+	 * Pre-commit callback.
+	 *
+	 * This allows the thin provisioning target to run a callback before
+	 * the metadata are committed.
+	 */
+	dm_pool_pre_commit_fn pre_commit_fn;
+	void *pre_commit_context;
+
+	/*
 	 * Reading the space map roots can fail, so we read it into these
 	 * buffers before the superblock is locked and updated.
 	 */
@@ -784,6 +793,14 @@ static int __commit_transaction(struct d
 	 */
 	BUILD_BUG_ON(sizeof(struct thin_disk_superblock) > 512);
 
+	if (pmd->pre_commit_fn) {
+		r = pmd->pre_commit_fn(pmd->pre_commit_context);
+		if (r < 0) {
+			DMERR("pre-commit callback failed");
+			return r;
+		}
+	}
+
 	r = __write_changed_details(pmd);
 	if (r < 0)
 		return r;
@@ -844,6 +861,8 @@ struct dm_pool_metadata *dm_pool_metadat
 	pmd->fail_io = false;
 	pmd->bdev = bdev;
 	pmd->data_block_size = data_block_size;
+	pmd->pre_commit_fn = NULL;
+	pmd->pre_commit_context = NULL;
 
 	r = __create_persistent_data_objects(pmd, format_device);
 	if (r) {
@@ -1789,6 +1808,16 @@ int dm_pool_register_metadata_threshold(
 	return r;
 }
 
+void dm_pool_register_pre_commit_callback(struct dm_pool_metadata *pmd,
+					  dm_pool_pre_commit_fn fn,
+					  void *context)
+{
+	down_write(&pmd->root_lock);
+	pmd->pre_commit_fn = fn;
+	pmd->pre_commit_context = context;
+	up_write(&pmd->root_lock);
+}
+
 int dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd)
 {
 	int r;
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -213,6 +213,13 @@ int dm_pool_register_metadata_threshold(
 int dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd);
 bool dm_pool_metadata_needs_check(struct dm_pool_metadata *pmd);
 
+/* Pre-commit callback */
+typedef int (*dm_pool_pre_commit_fn)(void *context);
+
+void dm_pool_register_pre_commit_callback(struct dm_pool_metadata *pmd,
+					  dm_pool_pre_commit_fn fn,
+					  void *context);
+
 /*----------------------------------------------------------------*/
 
 #endif

