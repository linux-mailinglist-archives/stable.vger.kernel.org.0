Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7A2E8698
	for <lists+stable@lfdr.de>; Sat,  2 Jan 2021 08:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbhABHNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jan 2021 02:13:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:47604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbhABHNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C70E8AD4E;
        Sat,  2 Jan 2021 07:12:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] bcache: check unsupported feature sets for bcache register
Date:   Sat,  2 Jan 2021 15:12:21 +0800
Message-Id: <20210102071223.58303-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210102071223.58303-1-colyli@suse.de>
References: <20210102071223.58303-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch adds the check for features which is incompatible for
current supported feature sets.

Now if the bcache device created by bcache-tools has features that
current kernel doesn't support, read_super() will fail with error
messoage. E.g. if an unsupported incompatible feature detected,
bcache register will fail with dmesg "bcache: register_bcache() error :
Unsupported incompatible feature found".

Fixes: d721a43ff69c ("bcache: increase super block version for cache device and backing device")
Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.9+
---
 drivers/md/bcache/features.h | 15 +++++++++++++++
 drivers/md/bcache/super.c    | 14 ++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
index 32c5bbda2f0d..e73724c2b49b 100644
--- a/drivers/md/bcache/features.h
+++ b/drivers/md/bcache/features.h
@@ -79,6 +79,21 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 
 BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LARGE_BUCKET);
 
+static inline bool bch_has_unknown_compat_features(struct cache_sb *sb)
+{
+	return ((sb->feature_compat & ~BCH_FEATURE_COMPAT_SUPP) != 0);
+}
+
+static inline bool bch_has_unknown_ro_compat_features(struct cache_sb *sb)
+{
+	return ((sb->feature_ro_compat & ~BCH_FEATURE_RO_COMPAT_SUPP) != 0);
+}
+
+static inline bool bch_has_unknown_incompat_features(struct cache_sb *sb)
+{
+	return ((sb->feature_incompat & ~BCH_FEATURE_INCOMPAT_SUPP) != 0);
+}
+
 int bch_print_cache_set_feature_compat(struct cache_set *c, char *buf, int size);
 int bch_print_cache_set_feature_ro_compat(struct cache_set *c, char *buf, int size);
 int bch_print_cache_set_feature_incompat(struct cache_set *c, char *buf, int size);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a4752ac410dc..1804df5c866b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -228,6 +228,20 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 		sb->feature_compat = le64_to_cpu(s->feature_compat);
 		sb->feature_incompat = le64_to_cpu(s->feature_incompat);
 		sb->feature_ro_compat = le64_to_cpu(s->feature_ro_compat);
+
+		/* Check incompatible features */
+		err = "Unsupported compatible feature found";
+		if (bch_has_unknown_compat_features(sb))
+			goto err;
+
+		err = "Unsupported read-only compatible feature found";
+		if (bch_has_unknown_ro_compat_features(sb))
+			goto err;
+
+		err = "Unsupported incompatible feature found";
+		if (bch_has_unknown_incompat_features(sb))
+			goto err;
+
 		err = read_super_common(sb, bdev, s);
 		if (err)
 			goto err;
-- 
2.26.2

