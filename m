Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D22499A7F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573146AbiAXVoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53848 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455023AbiAXVei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:34:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D396131F;
        Mon, 24 Jan 2022 21:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56670C340E4;
        Mon, 24 Jan 2022 21:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060076;
        bh=SmVEn4GoyNBFLoGjar7lW6qHLF92Ww9k0BA4JayBMZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkv81Vm24chKsgTqfEHX5mcodchLieY+C+w2iw/461Psz0bZsrlFbs4OQwwQikg2K
         28Xbym+QZzdGwNd8QX3HpzYEG6bMFp4wmUyJg/ln3ZN4PkgeIqMWAKENktmm57sVTq
         5FthXt6wO0AJMMRNEqMN9SloA6DcF1B6jsegkBYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0830/1039] kasan: fix quarantine conflicting with init_on_free
Date:   Mon, 24 Jan 2022 19:43:39 +0100
Message-Id: <20220124184153.183232888@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

[ Upstream commit 26dca996ea7b1ac7008b6b6063fc88b849e3ac3e ]

KASAN's quarantine might save its metadata inside freed objects.  As
this happens after the memory is zeroed by the slab allocator when
init_on_free is enabled, the memory coming out of quarantine is not
properly zeroed.

This causes lib/test_meminit.c tests to fail with Generic KASAN.

Zero the metadata when the object is removed from quarantine.

Link: https://lkml.kernel.org/r/2805da5df4b57138fdacd671f5d227d58950ba54.1640037083.git.andreyknvl@google.com
Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/quarantine.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index d8ccff4c1275e..47ed4fc33a29e 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -132,11 +132,22 @@ static void *qlink_to_object(struct qlist_node *qlink, struct kmem_cache *cache)
 static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
 {
 	void *object = qlink_to_object(qlink, cache);
+	struct kasan_free_meta *meta = kasan_get_free_meta(cache, object);
 	unsigned long flags;
 
 	if (IS_ENABLED(CONFIG_SLAB))
 		local_irq_save(flags);
 
+	/*
+	 * If init_on_free is enabled and KASAN's free metadata is stored in
+	 * the object, zero the metadata. Otherwise, the object's memory will
+	 * not be properly zeroed, as KASAN saves the metadata after the slab
+	 * allocator zeroes the object.
+	 */
+	if (slab_want_init_on_free(cache) &&
+	    cache->kasan_info.free_meta_offset == 0)
+		memzero_explicit(meta, sizeof(*meta));
+
 	/*
 	 * As the object now gets freed from the quarantine, assume that its
 	 * free track is no longer valid.
-- 
2.34.1



