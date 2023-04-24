Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B226A6ECDB3
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjDXNZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbjDXNZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2F45FD7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FFE4622B7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60775C433EF;
        Mon, 24 Apr 2023 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342748;
        bh=VWeaSIihX1UD1HpAC36qM6ZP2rDBKHTw1ESYWCVeS1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OstM//GyiFDzgOhvr2yomqwvx4v69RY2x6rXzaLIj2GRF4NIgVDH/vYyznvx4x0N0
         YDwsfyc1MnWDYuC3qHRGVzyJ0R/iXyb9pYTnQXpFfA3Yh6P3Ld7NJGul8iLr0R3B20
         eKR7pxosS7RmqAQ/col5ao5wYGvXfVtCnlV1F238=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Lu=C3=ADs=20Mendes?= <luis.p.mendes@gmail.com>,
        David Gow <davidgow@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 42/98] drm: buddy_allocator: Fix buddy allocator init on 32-bit systems
Date:   Mon, 24 Apr 2023 15:17:05 +0200
Message-Id: <20230424131135.512064209@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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



