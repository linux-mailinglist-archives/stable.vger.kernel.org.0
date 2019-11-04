Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E910BEEFEB
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfKDVwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730830AbfKDVws (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:48 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A5F2184C;
        Mon,  4 Nov 2019 21:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904366;
        bh=tDrUm+qwbUyXKsPEjhJF9Vdx2TT6I+dx62GC67rx3Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Ozy4BHEwWRmmne+ApxTMFOZghHAY8H5fjT3XmQym0tXoousN7IjGjXA9wB7ty7gV
         QYIxmb0HyIYa4bHQBmuE9S347dt5kVi6cMlWg0nlkUmAnq6PU9S8ExSqBIo7GICs2/
         r+zTDk+zk0lDrmHw4+7y3H0VVIOW34O06OcJfc90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/95] dm: Use kzalloc for all structs with embedded biosets/mempools
Date:   Mon,  4 Nov 2019 22:44:03 +0100
Message-Id: <20191104212040.275218135@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>

[ Upstream commit d377535405686f735b90a8ad4ba269484cd7c96e ]

mempool_init()/bioset_init() require that the mempools/biosets be zeroed
first; they probably should not _require_ this, but not allocating those
structs with kzalloc is a fairly nonsensical thing to do (calling
mempool_exit()/bioset_exit() on an uninitialized mempool/bioset is legal
and safe, but only works if said memory was zeroed.)

Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c | 2 +-
 drivers/md/dm-bio-prison-v2.c | 2 +-
 drivers/md/dm-io.c            | 2 +-
 drivers/md/dm-kcopyd.c        | 2 +-
 drivers/md/dm-region-hash.c   | 2 +-
 drivers/md/dm-snap.c          | 2 +-
 drivers/md/dm-thin.c          | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 874841f0fc837..10532a76688ea 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -33,7 +33,7 @@ static struct kmem_cache *_cell_cache;
  */
 struct dm_bio_prison *dm_bio_prison_create(void)
 {
-	struct dm_bio_prison *prison = kmalloc(sizeof(*prison), GFP_KERNEL);
+	struct dm_bio_prison *prison = kzalloc(sizeof(*prison), GFP_KERNEL);
 
 	if (!prison)
 		return NULL;
diff --git a/drivers/md/dm-bio-prison-v2.c b/drivers/md/dm-bio-prison-v2.c
index 8ce3a1a588cfd..c34ec615420f2 100644
--- a/drivers/md/dm-bio-prison-v2.c
+++ b/drivers/md/dm-bio-prison-v2.c
@@ -35,7 +35,7 @@ static struct kmem_cache *_cell_cache;
  */
 struct dm_bio_prison_v2 *dm_bio_prison_create_v2(struct workqueue_struct *wq)
 {
-	struct dm_bio_prison_v2 *prison = kmalloc(sizeof(*prison), GFP_KERNEL);
+	struct dm_bio_prison_v2 *prison = kzalloc(sizeof(*prison), GFP_KERNEL);
 
 	if (!prison)
 		return NULL;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index b4357ed4d5416..56e2c0e079d78 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -50,7 +50,7 @@ struct dm_io_client *dm_io_client_create(void)
 	struct dm_io_client *client;
 	unsigned min_ios = dm_get_reserved_bio_based_ios();
 
-	client = kmalloc(sizeof(*client), GFP_KERNEL);
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (!client)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index bd9a45b94b552..7ca2b1aaa79d4 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -892,7 +892,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 	int r = -ENOMEM;
 	struct dm_kcopyd_client *kc;
 
-	kc = kmalloc(sizeof(*kc), GFP_KERNEL);
+	kc = kzalloc(sizeof(*kc), GFP_KERNEL);
 	if (!kc)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 85c32b22a420a..91c6f6d72eeec 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -179,7 +179,7 @@ struct dm_region_hash *dm_region_hash_create(
 		;
 	nr_buckets >>= 1;
 
-	rh = kmalloc(sizeof(*rh), GFP_KERNEL);
+	rh = kzalloc(sizeof(*rh), GFP_KERNEL);
 	if (!rh) {
 		DMERR("unable to allocate region hash memory");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 95c564b60d79a..2170f6c118b89 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1136,7 +1136,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		origin_mode = FMODE_WRITE;
 	}
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		ti->error = "Cannot allocate private snapshot structure";
 		r = -ENOMEM;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index aa77959909894..0ee5eae716909 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2962,7 +2962,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		return (struct pool *)pmd;
 	}
 
-	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool) {
 		*error = "Error allocating memory for pool";
 		err_p = ERR_PTR(-ENOMEM);
-- 
2.20.1



