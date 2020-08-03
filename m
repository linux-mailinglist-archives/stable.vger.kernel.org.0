Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A75C23A606
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgHCM25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgHCM2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:28:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25B74204EC;
        Mon,  3 Aug 2020 12:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457733;
        bh=lhv4IwAgqn2rxgBpcw8dPa2pumagXqXev8znU1R0jLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juaav0UmovZhGoVcbI94xhjk2sZUZstNR56UJKBYxYdEOiu0DnnSY7LTFDRyBHAim
         gim23RnauEkpk96CEW8o56MVMn2xoB8ntqv/9Ee52SVrr/FG7CdRRJQlpdt2uGOcFS
         PXBmNck3yswjd546xPfC+RNH136XmdRTvT77Uq5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Gong, Sishuai" <sishuai@purdue.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 54/90] rhashtable: Fix unprotected RCU dereference in __rht_ptr
Date:   Mon,  3 Aug 2020 14:19:16 +0200
Message-Id: <20200803121900.241283758@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1748f6a2cbc4694523f16da1c892b59861045b9d ]

The rcu_dereference call in rht_ptr_rcu is completely bogus because
we've already dereferenced the value in __rht_ptr and operated on it.
This causes potential double readings which could be fatal.  The RCU
dereference must occur prior to the comparison in __rht_ptr.

This patch changes the order of RCU dereference so that it is done
first and the result is then fed to __rht_ptr.  The RCU marking
changes have been minimised using casts which will be removed in
a follow-up patch.

Fixes: ba6306e3f648 ("rhashtable: Remove RCU marking from...")
Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rhashtable.h | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index beb9a9da16994..c5bf21261bb19 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -349,11 +349,11 @@ static inline void rht_unlock(struct bucket_table *tbl,
 	local_bh_enable();
 }
 
-static inline struct rhash_head __rcu *__rht_ptr(
-	struct rhash_lock_head *const *bkt)
+static inline struct rhash_head *__rht_ptr(
+	struct rhash_lock_head *p, struct rhash_lock_head __rcu *const *bkt)
 {
-	return (struct rhash_head __rcu *)
-		((unsigned long)*bkt & ~BIT(0) ?:
+	return (struct rhash_head *)
+		((unsigned long)p & ~BIT(0) ?:
 		 (unsigned long)RHT_NULLS_MARKER(bkt));
 }
 
@@ -365,25 +365,26 @@ static inline struct rhash_head __rcu *__rht_ptr(
  *            access is guaranteed, such as when destroying the table.
  */
 static inline struct rhash_head *rht_ptr_rcu(
-	struct rhash_lock_head *const *bkt)
+	struct rhash_lock_head *const *p)
 {
-	struct rhash_head __rcu *p = __rht_ptr(bkt);
-
-	return rcu_dereference(p);
+	struct rhash_lock_head __rcu *const *bkt = (void *)p;
+	return __rht_ptr(rcu_dereference(*bkt), bkt);
 }
 
 static inline struct rhash_head *rht_ptr(
-	struct rhash_lock_head *const *bkt,
+	struct rhash_lock_head *const *p,
 	struct bucket_table *tbl,
 	unsigned int hash)
 {
-	return rht_dereference_bucket(__rht_ptr(bkt), tbl, hash);
+	struct rhash_lock_head __rcu *const *bkt = (void *)p;
+	return __rht_ptr(rht_dereference_bucket(*bkt, tbl, hash), bkt);
 }
 
 static inline struct rhash_head *rht_ptr_exclusive(
-	struct rhash_lock_head *const *bkt)
+	struct rhash_lock_head *const *p)
 {
-	return rcu_dereference_protected(__rht_ptr(bkt), 1);
+	struct rhash_lock_head __rcu *const *bkt = (void *)p;
+	return __rht_ptr(rcu_dereference_protected(*bkt, 1), bkt);
 }
 
 static inline void rht_assign_locked(struct rhash_lock_head **bkt,
-- 
2.25.1



