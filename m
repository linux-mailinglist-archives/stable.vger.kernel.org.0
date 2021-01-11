Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E292F142C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbhAKNVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:21:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733266AbhAKNTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:19:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 704D32226A;
        Mon, 11 Jan 2021 13:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371121;
        bh=XxYTAWiSOhmim1TRGZB7fqvB+gIlJNPPy/egxTorMsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdeRCOgNsptaMnOnxFoRyr2m873sa/BkZTctqtLTfs6XALxbr4znCfZxvklxCEeU8
         pGOn16PhQ8jyvMFo40DztJwryFczOQ/I6/PgxK9MPDAStc/eAHn5yBb3HUM6fImhRd
         4r6erdDRdeOSo2QqhfoMZH3er7ld8ADwQB2bWHHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 133/145] bcache: check unsupported feature sets for bcache register
Date:   Mon, 11 Jan 2021 14:02:37 +0100
Message-Id: <20210111130054.907338461@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 1dfc0686c29a9bbd3a446a29f9ccde3dec3bc75a upstream.

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/features.h |   15 +++++++++++++++
 drivers/md/bcache/super.c    |   14 ++++++++++++++
 2 files changed, 29 insertions(+)

--- a/drivers/md/bcache/features.h
+++ b/drivers/md/bcache/features.h
@@ -79,6 +79,21 @@ static inline void bch_clear_feature_##n
 
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
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -228,6 +228,20 @@ static const char *read_super(struct cac
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


