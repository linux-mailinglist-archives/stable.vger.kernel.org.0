Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B6E3CDBA7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbhGSOta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:49:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243877AbhGSOl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96BD261248;
        Mon, 19 Jul 2021 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708095;
        bh=kmGKFWbJJL9Hw2c1Zq2y3HJdEnTJrqSwgwIX2ATRWXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcts98jfj6+XRoEelJw31f6NoWrNM8Y7enUaOb0AlEB/iRgjdXpX6QMG13I1RtJ4a
         ETTzuBtkjnkwv+pVQ2JMCkgkGZbNpEPjARFtzoxZfsYO8X/UEdvG/7uTD+ztAECO1M
         cMpexaiZy5si/49XR3aIL9YGVkSf+2bMTP0VAPrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 177/315] dm space maps: dont reset space map allocation cursor when committing
Date:   Mon, 19 Jul 2021 16:51:06 +0200
Message-Id: <20210719144948.709362546@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

[ Upstream commit 5faafc77f7de69147d1e818026b9a0cbf036a7b2 ]

Current commit code resets the place where the search for free blocks
will begin back to the start of the metadata device.  There are a couple
of repercussions to this:

- The first allocation after the commit is likely to take longer than
  normal as it searches for a free block in an area that is likely to
  have very few free blocks (if any).

- Any free blocks it finds will have been recently freed.  Reusing them
  means we have fewer old copies of the metadata to aid recovery from
  hardware error.

Fix these issues by leaving the cursor alone, only resetting when the
search hits the end of the metadata device.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/persistent-data/dm-space-map-disk.c     | 9 ++++++++-
 drivers/md/persistent-data/dm-space-map-metadata.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index bf4c5e2ccb6f..e0acae7a3815 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -171,6 +171,14 @@ static int sm_disk_new_block(struct dm_space_map *sm, dm_block_t *b)
 	 * Any block we allocate has to be free in both the old and current ll.
 	 */
 	r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, smd->begin, smd->ll.nr_blocks, b);
+	if (r == -ENOSPC) {
+		/*
+		 * There's no free block between smd->begin and the end of the metadata device.
+		 * We search before smd->begin in case something has been freed.
+		 */
+		r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, 0, smd->begin, b);
+	}
+
 	if (r)
 		return r;
 
@@ -199,7 +207,6 @@ static int sm_disk_commit(struct dm_space_map *sm)
 		return r;
 
 	memcpy(&smd->old_ll, &smd->ll, sizeof(smd->old_ll));
-	smd->begin = 0;
 	smd->nr_allocated_this_transaction = 0;
 
 	r = sm_disk_get_nr_free(sm, &nr_free);
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 31a999458be9..b3ded452e573 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -451,6 +451,14 @@ static int sm_metadata_new_block_(struct dm_space_map *sm, dm_block_t *b)
 	 * Any block we allocate has to be free in both the old and current ll.
 	 */
 	r = sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, smm->begin, smm->ll.nr_blocks, b);
+	if (r == -ENOSPC) {
+		/*
+		 * There's no free block between smm->begin and the end of the metadata device.
+		 * We search before smm->begin in case something has been freed.
+		 */
+		r = sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, 0, smm->begin, b);
+	}
+
 	if (r)
 		return r;
 
@@ -502,7 +510,6 @@ static int sm_metadata_commit(struct dm_space_map *sm)
 		return r;
 
 	memcpy(&smm->old_ll, &smm->ll, sizeof(smm->old_ll));
-	smm->begin = 0;
 	smm->allocated_this_transaction = 0;
 
 	return 0;
-- 
2.30.2



