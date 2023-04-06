Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8526D9544
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbjDFLcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbjDFLca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:32:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6BC9EE2;
        Thu,  6 Apr 2023 04:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 678A964665;
        Thu,  6 Apr 2023 11:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D28AC433D2;
        Thu,  6 Apr 2023 11:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780723;
        bh=KvbfyJJsZJdfmByvweii2cgAnMVFdQui9o6fhzYeZtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iB95A4yrRuN5uuCo76iEcfyH7cKw0yKwTpUTb4rcJN8NP3aqKaIMaBYowDezxMHkq
         T2K7Hx28MW3il2bJRLMZLquJF2LXV6p+qSVMX+kFfzoSTV2x6aGfrce3jcTEsZk75S
         DFOsv3cHwONpIUSeVkV16wSd7PtC4GeTiyishBrmXOpQKy1kxLnRekVvAcDEBzeggb
         Jl7RO215pQZwKNB4hPSYMjo14Z1I2dhD0mUHhXt1+nxnUH78/cDdb0uzrACM0w5bNy
         +katIzOC3XFI1KuubWlHudpSNcaUyTyzy3oHAvFV+2kb8Gxci0/wN7qnTkBN56xnYS
         ZJt+CGHolsm3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Gow <davidgow@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
        Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>,
        Sasha Levin <sashal@kernel.org>, airlied@gmail.com,
        daniel@ffwll.ch, mairacanal@riseup.net, javierm@redhat.com,
        maxime@cerno.tech, arthurgrillo@riseup.net, Jason@zx2c4.com,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 12/17] drm: test: Fix 32-bit issue in drm_buddy_test
Date:   Thu,  6 Apr 2023 07:31:26 -0400
Message-Id: <20230406113131.648213-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113131.648213-1-sashal@kernel.org>
References: <20230406113131.648213-1-sashal@kernel.org>
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

