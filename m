Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5C7B923A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390654AbfITOa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:30:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36952 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388419AbfITOZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:17 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-00051E-Ki; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007sV-9m; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Slava Pestov" <sp@daterainc.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.196882684@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 049/132] bcache: fix memory corruption in init error path
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Slava Pestov <sp@daterainc.com>

commit c9a78332b42cbdcdd386a95192a716b67d1711a4 upstream.

If register_cache_set() failed, we would touch ca->set after
it had already been freed. Also, fix an assertion to catch
this.

Change-Id: I748e5f5b223e2d9b2602075dec2f997cced2394d
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/bcache/super.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1365,8 +1365,11 @@ static void cache_set_free(struct closur
 	bch_journal_free(c);
 
 	for_each_cache(ca, c, i)
-		if (ca)
+		if (ca) {
+			ca->set = NULL;
+			c->cache[ca->sb.nr_this_dev] = NULL;
 			kobject_put(&ca->kobj);
+		}
 
 	bch_bset_sort_state_free(&c->sort);
 	free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
@@ -1804,8 +1807,10 @@ void bch_cache_release(struct kobject *k
 	struct cache *ca = container_of(kobj, struct cache, kobj);
 	unsigned i;
 
-	if (ca->set)
+	if (ca->set) {
+		BUG_ON(ca->set->cache[ca->sb.nr_this_dev] != ca);
 		ca->set->cache[ca->sb.nr_this_dev] = NULL;
+	}
 
 	bio_split_pool_free(&ca->bio_split_hook);
 
@@ -1868,7 +1873,7 @@ static int cache_alloc(struct cache_sb *
 }
 
 static int register_cache(struct cache_sb *sb, struct page *sb_page,
-				  struct block_device *bdev, struct cache *ca)
+				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
 	const char *err = NULL; /* must be set for any error case */

