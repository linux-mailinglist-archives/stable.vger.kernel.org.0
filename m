Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF922307430
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 11:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhA1Kwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 05:52:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:41294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhA1Kwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 05:52:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 82F2AAF82;
        Thu, 28 Jan 2021 10:51:57 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org,
        Bockholdt Arne <a.bockholdt@precitec-optronik.de>
Subject: [PATCH] bcache: only check feature sets when sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES
Date:   Thu, 28 Jan 2021 18:48:47 +0800
Message-Id: <20210128104847.22773-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For super block version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES, it
doesn't make sense to check the feature sets. This patch checks
super block version in bch_has_feature_* routines, if the version
doesn't have feature sets yet, returns 0 (false) to the caller.

Fixes: 5342fd425502 ("bcache: set bcache device into read-only mode for BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET") 
Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
Cc: stable@vger.kernel.org # 5.9+
Reported-and-tested-by: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/features.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
index 84fc2c0f0101..d1c8fd3977fc 100644
--- a/drivers/md/bcache/features.h
+++ b/drivers/md/bcache/features.h
@@ -33,6 +33,8 @@
 #define BCH_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline int bch_has_feature_##name(struct cache_sb *sb) \
 { \
+	if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
+		return 0; \
 	return (((sb)->feature_compat & \
 		BCH##_FEATURE_COMPAT_##flagname) != 0); \
 } \
@@ -50,6 +52,8 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 #define BCH_FEATURE_RO_COMPAT_FUNCS(name, flagname) \
 static inline int bch_has_feature_##name(struct cache_sb *sb) \
 { \
+	if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
+		return 0; \
 	return (((sb)->feature_ro_compat & \
 		BCH##_FEATURE_RO_COMPAT_##flagname) != 0); \
 } \
@@ -67,6 +71,8 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 #define BCH_FEATURE_INCOMPAT_FUNCS(name, flagname) \
 static inline int bch_has_feature_##name(struct cache_sb *sb) \
 { \
+	if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
+		return 0; \
 	return (((sb)->feature_incompat & \
 		BCH##_FEATURE_INCOMPAT_##flagname) != 0); \
 } \
-- 
2.26.2

