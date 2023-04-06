Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475E16D9571
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbjDFLdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237373AbjDFLdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:33:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D6693EB;
        Thu,  6 Apr 2023 04:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E04AD6446A;
        Thu,  6 Apr 2023 11:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E1AC433D2;
        Thu,  6 Apr 2023 11:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780754;
        bh=VWeaSIihX1UD1HpAC36qM6ZP2rDBKHTw1ESYWCVeS1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2Q23ggOGmLSunqlW9N5zb9/xfrkhhT6tgdL686YtskoeXtsxwRyrSK/h6BLXSnPn
         Jovz3CUQjwXJa12AYgRzcNyfAkv5/uJNkXGMwth1X0UIWk7Kab2PiiIgx9Ir5WQBGF
         E5IfWth/QfBqYc8g2SaXtU32J47XE6OKmRT9/9c1xTMtONrMYFlNDwW1v6gRqsf68I
         lrTrAr4Unt+N7CjyltAEQPtUnt5dSxQT+39MC6sIropfWt+cYiOCj/BhzGsKP0dejd
         TMhjBokR/q2VZPVMeen5Dfm8SxqBwSPVPaLpRfqn5YWR5q4CnBHzUMaiKJGG2K8alP
         DIZPncAKq8mfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Gow <davidgow@google.com>,
        =?UTF-8?q?Lu=C3=ADs=20Mendes?= <luis.p.mendes@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 11/17] drm: buddy_allocator: Fix buddy allocator init on 32-bit systems
Date:   Thu,  6 Apr 2023 07:32:05 -0400
Message-Id: <20230406113211.648424-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113211.648424-1-sashal@kernel.org>
References: <20230406113211.648424-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 4453545b5b4c3eff941f69a5530f916d899db025 ]

The drm buddy allocator tests were broken on 32-bit systems, as
rounddown_pow_of_two() takes a long, and the buddy allocator handles
64-bit sizes even on 32-bit systems.

This can be reproduced with the drm_buddy_allocator KUnit tests on i386:
	./tools/testing/kunit/kunit.py run --arch i386 \
	--kunitconfig ./drivers/gpu/drm/tests drm_buddy

(It results in kernel BUG_ON() when too many blocks are created, due to
the block size being too small.)

This was independently uncovered (and fixed) by Luís Mendes, whose patch
added a new u64 variant of rounddown_pow_of_two(). This version instead
recalculates the size based on the order.

Reported-by: Luís Mendes <luis.p.mendes@gmail.com>
Link: https://lore.kernel.org/lkml/CAEzXK1oghXAB_KpKpm=-CviDQbNaH0qfgYTSSjZgvvyj4U78AA@mail.gmail.com/T/
Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230329065532.2122295-1-davidgow@google.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_buddy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_buddy.c b/drivers/gpu/drm/drm_buddy.c
index 3d1f50f481cfd..7098f125b54a9 100644
--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -146,8 +146,8 @@ int drm_buddy_init(struct drm_buddy *mm, u64 size, u64 chunk_size)
 		unsigned int order;
 		u64 root_size;
 
-		root_size = rounddown_pow_of_two(size);
-		order = ilog2(root_size) - ilog2(chunk_size);
+		order = ilog2(size) - ilog2(chunk_size);
+		root_size = chunk_size << order;
 
 		root = drm_block_alloc(mm, NULL, order, offset);
 		if (!root)
-- 
2.39.2

