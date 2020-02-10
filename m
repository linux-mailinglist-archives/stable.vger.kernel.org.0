Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780DD1579CE
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgBJNSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbgBJMhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:54 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3911424687;
        Mon, 10 Feb 2020 12:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338274;
        bh=RC5LyErzA5QLiIz6fXV5CAXcGDg3k+bE+UcIo5ET3PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARXYI+xvV+Hm+73v5Nkvq+GSGCf5COUe1TrWhWx6kWpCgvDJD8HKssvZODaSyL9gG
         JRDf6+u9FiMw0YCyfRSppzlUtFhYP9AltEjilt8oO3e7RLeYVyu5kS3mjo0pZiQWND
         oDTDBoKP0v6HDdeYhNF65PvP4+kJrCtKL+XBv9oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 132/309] dm thin metadata: use pool locking at end of dm_pool_metadata_close
Date:   Mon, 10 Feb 2020 04:31:28 -0800
Message-Id: <20200210122419.047329981@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 44d8ebf436399a40fcd10dd31b29d37823d62fcc upstream.

Ensure that the pool is locked during calls to __commit_transaction and
__destroy_persistent_data_objects.  Just being consistent with locking,
but reality is dm_pool_metadata_close is called once pool is being
destroyed so access to pool shouldn't be contended.

Also, use pmd_write_lock_in_core rather than __pmd_write_lock in
dm_pool_commit_metadata and rename __pmd_write_lock to
pmd_write_lock_in_core -- there was no need for the alias.

In addition, verify that the pool is locked in __commit_transaction().

Fixes: 873f258becca ("dm thin metadata: do not write metadata if no changes occurred")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -387,16 +387,15 @@ static int subtree_equal(void *context,
  * Variant that is used for in-core only changes or code that
  * shouldn't put the pool in service on its own (e.g. commit).
  */
-static inline void __pmd_write_lock(struct dm_pool_metadata *pmd)
+static inline void pmd_write_lock_in_core(struct dm_pool_metadata *pmd)
 	__acquires(pmd->root_lock)
 {
 	down_write(&pmd->root_lock);
 }
-#define pmd_write_lock_in_core(pmd) __pmd_write_lock((pmd))
 
 static inline void pmd_write_lock(struct dm_pool_metadata *pmd)
 {
-	__pmd_write_lock(pmd);
+	pmd_write_lock_in_core(pmd);
 	if (unlikely(!pmd->in_service))
 		pmd->in_service = true;
 }
@@ -831,6 +830,7 @@ static int __commit_transaction(struct d
 	 * We need to know if the thin_disk_superblock exceeds a 512-byte sector.
 	 */
 	BUILD_BUG_ON(sizeof(struct thin_disk_superblock) > 512);
+	BUG_ON(!rwsem_is_locked(&pmd->root_lock));
 
 	if (unlikely(!pmd->in_service))
 		return 0;
@@ -953,6 +953,7 @@ int dm_pool_metadata_close(struct dm_poo
 		return -EBUSY;
 	}
 
+	pmd_write_lock_in_core(pmd);
 	if (!dm_bm_is_read_only(pmd->bm) && !pmd->fail_io) {
 		r = __commit_transaction(pmd);
 		if (r < 0)
@@ -961,6 +962,7 @@ int dm_pool_metadata_close(struct dm_poo
 	}
 	if (!pmd->fail_io)
 		__destroy_persistent_data_objects(pmd);
+	pmd_write_unlock(pmd);
 
 	kfree(pmd);
 	return 0;
@@ -1841,7 +1843,7 @@ int dm_pool_commit_metadata(struct dm_po
 	 * Care is taken to not have commit be what
 	 * triggers putting the thin-pool in-service.
 	 */
-	__pmd_write_lock(pmd);
+	pmd_write_lock_in_core(pmd);
 	if (pmd->fail_io)
 		goto out;
 


