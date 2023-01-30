Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB34D68101C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbjA3OAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbjA3OAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:00:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD6427987
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C9246102C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D585C433D2;
        Mon, 30 Jan 2023 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087163;
        bh=o6ry7P8M2/O7LPL0d2ClKf+rp4965tZojt9jE73a5Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4/V4yPbh10iczp8ALgAYP/GvWIRC10WQ++BE60VXRosDXfvFYh2Sm8rt8nOSaiCK
         51bzSAyEQN7+RTKntyRLR6NjE9v8HciKJuij+Yp03uq13LLJ51aTSLu0BZij3Ctz/6
         UkcoV0kmPFn2jOHv5NUyvgpbu7nlChGTau1mAovM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andi Shyti <andi.shyti@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/313] drm/i915/selftests: Unwind hugepages to drop wakeref on error
Date:   Mon, 30 Jan 2023 14:49:13 +0100
Message-Id: <20230130134342.158555142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@linux.intel.com>

[ Upstream commit 93eea624526fc7d070cdae463408665824075f54 ]

Make sure that upon error after we have acquired the wakeref we do
release it again.

v2: add another missing "goto out_wf"(Andi).

Fixes: 027c38b4121e ("drm/i915/selftests: Grab the runtime pm in shrink_thp")
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230117123234.26487-1-nirmoy.das@intel.com
(cherry picked from commit 14ec40a88210151296fff3e981c1a7196ad9bf55)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index c570cf780079..436598f19522 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1697,7 +1697,7 @@ static int igt_shrink_thp(void *arg)
 			I915_SHRINK_ACTIVE);
 	i915_vma_unpin(vma);
 	if (err)
-		goto out_put;
+		goto out_wf;
 
 	/*
 	 * Now that the pages are *unpinned* shrinking should invoke
@@ -1713,19 +1713,19 @@ static int igt_shrink_thp(void *arg)
 		pr_err("unexpected pages mismatch, should_swap=%s\n",
 		       str_yes_no(should_swap));
 		err = -EINVAL;
-		goto out_put;
+		goto out_wf;
 	}
 
 	if (should_swap == (obj->mm.page_sizes.sg || obj->mm.page_sizes.phys)) {
 		pr_err("unexpected residual page-size bits, should_swap=%s\n",
 		       str_yes_no(should_swap));
 		err = -EINVAL;
-		goto out_put;
+		goto out_wf;
 	}
 
 	err = i915_vma_pin(vma, 0, 0, flags);
 	if (err)
-		goto out_put;
+		goto out_wf;
 
 	while (n--) {
 		err = cpu_check(obj, n, 0xdeadbeaf);
-- 
2.39.0



