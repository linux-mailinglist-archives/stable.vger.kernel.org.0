Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA2C22F148
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731588AbgG0OU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731638AbgG0OU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8D1B2070A;
        Mon, 27 Jul 2020 14:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859656;
        bh=ebxccEJRHPOOC7cjposBDMtnXGLMNHK5sBFz01mP/R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/YqtaRsD36vpPwtE7CGFMwEI9PFJSb5q2R1WkOVD5B5bJjguyXpfLkr3d2Uw6wlr
         bTwfk7a7NCIMkyeS7anXCFPPzg/o0zaUhL2omBF5KbrlZ7/V+FOJspiGpOPSIIVxtb
         u9QckGMHPr3Ld/ajjsOQ7A5Pd5z3r10PW18LL7L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 024/179] dm mpath: pass IO start time to path selector
Date:   Mon, 27 Jul 2020 16:03:19 +0200
Message-Id: <20200727134933.846667790@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 087615bf3acdafd0ba7c7c9ed5286e7b7c80fe1b ]

The HST path selector needs this information to perform path
prediction. For request-based mpath, struct request's io_start_time_ns
is used, while for bio-based, use the start_time stored in dm_io.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-mpath.c         | 9 ++++++---
 drivers/md/dm-path-selector.h | 2 +-
 drivers/md/dm-queue-length.c  | 2 +-
 drivers/md/dm-service-time.c  | 2 +-
 drivers/md/dm.c               | 9 +++++++++
 include/linux/device-mapper.h | 2 ++
 6 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e0c800cf87a9b..74246d7c7d68e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -567,7 +567,8 @@ static void multipath_release_clone(struct request *clone,
 		if (pgpath && pgpath->pg->ps.type->end_io)
 			pgpath->pg->ps.type->end_io(&pgpath->pg->ps,
 						    &pgpath->path,
-						    mpio->nr_bytes);
+						    mpio->nr_bytes,
+						    clone->io_start_time_ns);
 	}
 
 	blk_put_request(clone);
@@ -1617,7 +1618,8 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 		struct path_selector *ps = &pgpath->pg->ps;
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes,
+					 clone->io_start_time_ns);
 	}
 
 	return r;
@@ -1661,7 +1663,8 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 		struct path_selector *ps = &pgpath->pg->ps;
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes,
+					 dm_start_time_ns_from_clone(clone));
 	}
 
 	return r;
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index b6eb5365b1a46..c47bc0e20275b 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -74,7 +74,7 @@ struct path_selector_type {
 	int (*start_io) (struct path_selector *ps, struct dm_path *path,
 			 size_t nr_bytes);
 	int (*end_io) (struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes);
+		       size_t nr_bytes, u64 start_time);
 };
 
 /* Register a path selector */
diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index 969c4f1a36336..5fd018d184187 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -227,7 +227,7 @@ static int ql_start_io(struct path_selector *ps, struct dm_path *path,
 }
 
 static int ql_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     size_t nr_bytes, u64 start_time)
 {
 	struct path_info *pi = path->pscontext;
 
diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-time.c
index f006a9005593b..9cfda665e9ebd 100644
--- a/drivers/md/dm-service-time.c
+++ b/drivers/md/dm-service-time.c
@@ -309,7 +309,7 @@ static int st_start_io(struct path_selector *ps, struct dm_path *path,
 }
 
 static int st_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     size_t nr_bytes, u64 start_time)
 {
 	struct path_info *pi = path->pscontext;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9793b04e9ff3b..cefda95c9abb7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -676,6 +676,15 @@ static bool md_in_flight(struct mapped_device *md)
 		return md_in_flight_bios(md);
 }
 
+u64 dm_start_time_ns_from_clone(struct bio *bio)
+{
+	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	struct dm_io *io = tio->io;
+
+	return jiffies_to_nsecs(io->start_time);
+}
+EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index af48d9da39160..934037d938b9a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -332,6 +332,8 @@ void *dm_per_bio_data(struct bio *bio, size_t data_size);
 struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size);
 unsigned dm_bio_get_target_bio_nr(const struct bio *bio);
 
+u64 dm_start_time_ns_from_clone(struct bio *bio);
+
 int dm_register_target(struct target_type *t);
 void dm_unregister_target(struct target_type *t);
 
-- 
2.25.1



