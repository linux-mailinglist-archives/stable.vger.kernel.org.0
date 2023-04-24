Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C37F6ECE4D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjDXNbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjDXNa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5B665B4
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE29A6232C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F33C4339C;
        Mon, 24 Apr 2023 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343022;
        bh=KvbfyJJsZJdfmByvweii2cgAnMVFdQui9o6fhzYeZtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sy2aOoagcTAyw5de9EkWbfux2I7Ws/e4Ja/Xwt5gLTi94ehR8DEC9aNCASPjEl+HP
         yUtgXP0WaIyKDshx5flCVW3q3SNiJdJhIhhQg2gdY7cR8iBzzRh2dGJxah1hJ02uBT
         CBjqkD5q6xBNuS65HhE2aCd5JGcBsq5nQYKtsy7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Gow <davidgow@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
        Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 048/110] drm: test: Fix 32-bit issue in drm_buddy_test
Date:   Mon, 24 Apr 2023 15:17:10 +0200
Message-Id: <20230424131138.044523914@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
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

[ Upstream commit 25bbe844ef5c4fb4d7d8dcaa0080f922b7cd3a16 ]

The drm_buddy_test KUnit tests verify that returned blocks have sizes
which are powers of two using is_power_of_2(). However, is_power_of_2()
operations on a 'long', but the block size is a u64. So on systems where
long is 32-bit, this can sometimes fail even on correctly sized blocks.

This only reproduces randomly, as the parameters passed to the buddy
allocator in this test are random. The seed 0xb2e06022 reproduced it
fine here.

For now, just hardcode an is_power_of_2() implementation using
x & (x - 1).

Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230329065532.2122295-2-davidgow@google.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_buddy_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tests/drm_buddy_test.c b/drivers/gpu/drm/tests/drm_buddy_test.c
index f8ee714df3967..09ee6f6af896b 100644
--- a/drivers/gpu/drm/tests/drm_buddy_test.c
+++ b/drivers/gpu/drm/tests/drm_buddy_test.c
@@ -89,7 +89,8 @@ static int check_block(struct kunit *test, struct drm_buddy *mm,
 		err = -EINVAL;
 	}
 
-	if (!is_power_of_2(block_size)) {
+	/* We can't use is_power_of_2() for a u64 on 32-bit systems. */
+	if (block_size & (block_size - 1)) {
 		kunit_err(test, "block size not power of two\n");
 		err = -EINVAL;
 	}
-- 
2.39.2



