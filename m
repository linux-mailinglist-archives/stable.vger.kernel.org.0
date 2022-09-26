Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A525EADE3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiIZRQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiIZRQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:16:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976879DB6F;
        Mon, 26 Sep 2022 09:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A641B80B2E;
        Mon, 26 Sep 2022 16:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E134C433D7;
        Mon, 26 Sep 2022 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664209799;
        bh=A0ybDQ51k9oJ4ReXs2ASvQDuahhVl27PCcQijNdbvAM=;
        h=From:To:Cc:Subject:Date:From;
        b=hjN/hB0zGhz3na2PG5iAkJqXXc5bQQNxUkkawQYUsXZjhFSP4t/FIrcSP9LMHgz4V
         l5wlnfDuyqH2UsyztWNPqxQbBOrgFkbdoikNzpjwWyn/pfKRM+jcKvKXkJ4AE/Ejhs
         ozNgEVsNmalsJJ90/1GVRB1e+LZIbwi6mGJrmPGW7aN3gNSVOGsx6zD6LkQIwMz1jI
         68gSrZG9ecu46Kw+JnAu/9ePvJ0bVRKrNpC06UCcE0LkMAPHmCr0zof9lUtyNS1ctP
         sw8SWj81H96sMcksfDcRI6ffD4jm60N0BZjyyGNsU7Jq0Nw/dMJYWp8ACtcZ7Lt3TG
         +xMK5o0cmsMGw==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     ppbuk5246@gmail.com, damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        SeongJae Park <sj@kernel.org>
Subject: [PATCH v5] damon/sysfs: fix possible memleak on damon_sysfs_add_target
Date:   Mon, 26 Sep 2022 16:29:51 +0000
Message-Id: <20220926162951.49496-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Levi Yun <ppbuk5246@gmail.com>

When damon_sysfs_add_target couldn't find proper task, newly allocated
damon_target structure isn't registered yet.  So, it's impossible to
free the newly allocated one by damon_sysfs_destroy_targets.

By calling damon_add_target as soon as allocating new target, fix this
possible memory leak.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.17.x
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---

Changes from v4
(https://lore.kernel.org/damon/20220926160611.48536-1-sj@kernel.org/_
- Fix some typos

Changes from v3
(https://lore.kernel.org/damon/20220925234327.26345-1-ppbuk5246@gmail.com/)
- Fix Fixes: tag
- Add patch changelog

Changes from v2
(https://lore.kernel.org/damon/20220925234053.26090-1-ppbuk5246@gmail.com/)
- Add Fixes: and Cc: stable

Changes from v1
(https://lore.kernel.org/damon/20220925140257.23431-1-ppbuk5246@gmail.com/)
- Do damon_add_target() earlier instead of explicitly freeing the object

 mm/damon/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 455215a5c059..9f1219a67e3f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2172,12 +2172,12 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 
 	if (!t)
 		return -ENOMEM;
+	damon_add_target(ctx, t);
 	if (damon_target_has_pid(ctx)) {
 		t->pid = find_get_pid(sys_target->pid);
 		if (!t->pid)
 			goto destroy_targets_out;
 	}
-	damon_add_target(ctx, t);
 	err = damon_sysfs_set_regions(t, sys_target->regions);
 	if (err)
 		goto destroy_targets_out;
-- 
2.25.1

