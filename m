Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B5CEF075
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfKDVso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:48:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbfKDVso (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:48:44 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F4FD21655;
        Mon,  4 Nov 2019 21:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904123;
        bh=fUlzJ6SkT4/oN3tyB+l925n9kT9yk3a1WOh1+6ZEKuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2c/RCuIDOmO3EB1mu2lrVFtAGvxOCFrj9WSF1tz3otfeQC0CylWMDOm8QRdFp52xP
         YHerJg2cafLrjeXVD+X9puhe8w7vaR4qlxnf2rjttmTcRRD8iaGEo8jJ6d9XdSP8Pr
         eq8OVU8e9Ziw8REktba/f+bxG1+FUyekNOPHM0qM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 04/46] dm: Use kzalloc for all structs with embedded biosets/mempools
Date:   Mon,  4 Nov 2019 22:44:35 +0100
Message-Id: <20191104211835.436442738@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
References: <20191104211830.912265604@linuxfoundation.org>
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
 drivers/md/dm-bio-prison.c  | 2 +-
 drivers/md/dm-io.c          | 2 +-
 drivers/md/dm-kcopyd.c      | 2 +-
 drivers/md/dm-region-hash.c | 2 +-
 drivers/md/dm-snap.c        | 2 +-
 drivers/md/dm-thin.c        | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-bio-prison.c b/drivers/md/dm-bio-prison.c
index 03af174485d30..fa2432a89bace 100644
--- a/drivers/md/dm-bio-prison.c
+++ b/drivers/md/dm-bio-prison.c
@@ -32,7 +32,7 @@ static struct kmem_cache *_cell_cache;
  */
 struct dm_bio_prison *dm_bio_prison_create(void)
 {
-	struct dm_bio_prison *prison = kmalloc(sizeof(*prison), GFP_KERNEL);
+	struct dm_bio_prison *prison = kzalloc(sizeof(*prison), GFP_KERNEL);
 
 	if (!prison)
 		return NULL;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 1b84d2890fbf1..ad9a470e5382e 100644
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
index 04248394843e8..09df2c688ba9c 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -827,7 +827,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 	int r = -ENOMEM;
 	struct dm_kcopyd_client *kc;
 
-	kc = kmalloc(sizeof(*kc), GFP_KERNEL);
+	kc = kzalloc(sizeof(*kc), GFP_KERNEL);
 	if (!kc)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 74cb7b991d41d..a93a4e6839999 100644
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
index 98950c4bf939a..510b0cf430a8a 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1137,7 +1137,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		origin_mode = FMODE_WRITE;
 	}
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		ti->error = "Cannot allocate private snapshot structure";
 		r = -ENOMEM;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index d52ea584e0bc1..4d7eae3d32b02 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2882,7 +2882,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		return (struct pool *)pmd;
 	}
 
-	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool) {
 		*error = "Error allocating memory for pool";
 		err_p = ERR_PTR(-ENOMEM);
-- 
2.20.1



