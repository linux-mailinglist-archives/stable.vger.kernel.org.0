Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3067430BFEF
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhBBNqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:46:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232556AbhBBNpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93B2C64F71;
        Tue,  2 Feb 2021 13:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273227;
        bh=1OYM2AkL4NtWNpKsGZ3DuhPlPT6lqX7K+qcrXB/kqfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oB1+KX5QVJnEJ4fjr7RwwGFlIra3nZ05wOOnLY3+1/n8mcvsZoZtSsPqic4CGlUC7
         ZMtPISUyoB0G4yokIBQTpAgSbqtXatT9ZyRPBEMWz9w5LzIxW05vsgXZxOjJsMe8Ov
         QDPQ33Pvl+oLYPajZZb4F84HjUfjtOrJhe9hC1/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Bockholdt Arne <a.bockholdt@precitec-optronik.de>
Subject: [PATCH 5.10 027/142] bcache: only check feature sets when sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES
Date:   Tue,  2 Feb 2021 14:36:30 +0100
Message-Id: <20210202132958.832511119@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 0df28cad06eb41cc36bfea69d9c882fb567fd0d6 upstream.

For super block version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES, it
doesn't make sense to check the feature sets. This patch checks
super block version in bch_has_feature_* routines, if the version
doesn't have feature sets yet, returns 0 (false) to the caller.

Fixes: 5342fd425502 ("bcache: set bcache device into read-only mode for BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET")
Fixes: ffa470327572 ("bcache: add bucket_size_hi into struct cache_sb_disk for large bucket")
Cc: stable@vger.kernel.org # 5.9+
Reported-and-tested-by: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/features.h |    6 ++++++
 1 file changed, 6 insertions(+)

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
@@ -50,6 +52,8 @@ static inline void bch_clear_feature_##n
 #define BCH_FEATURE_RO_COMPAT_FUNCS(name, flagname) \
 static inline int bch_has_feature_##name(struct cache_sb *sb) \
 { \
+	if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
+		return 0; \
 	return (((sb)->feature_ro_compat & \
 		BCH##_FEATURE_RO_COMPAT_##flagname) != 0); \
 } \
@@ -67,6 +71,8 @@ static inline void bch_clear_feature_##n
 #define BCH_FEATURE_INCOMPAT_FUNCS(name, flagname) \
 static inline int bch_has_feature_##name(struct cache_sb *sb) \
 { \
+	if (sb->version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES) \
+		return 0; \
 	return (((sb)->feature_incompat & \
 		BCH##_FEATURE_INCOMPAT_##flagname) != 0); \
 } \


