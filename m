Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B872419CC2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbhI0RcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236088AbhI0RaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7475C61527;
        Mon, 27 Sep 2021 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763089;
        bh=U595uBJGQBwncERun0OReAfOMr+OX6JYE3VtFMuFF1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9MZB6TVCkGnutTXg/2XGWDwLGABJusSfzvxWBh6oheRjIs3zPJhiqnL7uOFkpFyF
         Z3o80xM2EQLbRz/JujdcXz8mdyurwXvz6EdzMLAgMTdTwt9/CaAGBhwNPqyfuAgV44
         JL+tVkNzIDeKUqb8zTxJcQ+tu8eK2blp1qi374QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Huang Rui <ray.huang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 131/162] drm/ttm: fix type mismatch error on sparc64
Date:   Mon, 27 Sep 2021 19:02:57 +0200
Message-Id: <20210927170237.959413851@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

[ Upstream commit 3ca706c189db861b2ca2019a0901b94050ca49d8 ]

On sparc64, __fls() returns an "int", but the drm TTM code expected it
to be "unsigned long" as on x86.  As a result, on sparc (and arc, and
m68k) you get build errors because 'min()' checks that the types match.

As suggested by Linus, it can use min_t instead of min to force the type
to be "unsigned int".

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.c
index cb38b1a17b09..82cbb29a05aa 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -383,7 +383,8 @@ int ttm_pool_alloc(struct ttm_pool *pool, struct ttm_tt *tt,
 	else
 		gfp_flags |= GFP_HIGHUSER;
 
-	for (order = min(MAX_ORDER - 1UL, __fls(num_pages)); num_pages;
+	for (order = min_t(unsigned int, MAX_ORDER - 1, __fls(num_pages));
+	     num_pages;
 	     order = min_t(unsigned int, order, __fls(num_pages))) {
 		bool apply_caching = false;
 		struct ttm_pool_type *pt;
-- 
2.33.0



