Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E05EAD7F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiIZREO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiIZRDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:03:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3876D97B36;
        Mon, 26 Sep 2022 09:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24F0C60F79;
        Mon, 26 Sep 2022 16:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04571C433D6;
        Mon, 26 Sep 2022 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664208383;
        bh=Gd8nmWWpHS7qrcrAlAsgmMmvuXxIQOEs22IHlMZZio0=;
        h=From:To:Cc:Subject:Date:From;
        b=s/IlLIcBHSG0s6pt6JTYAGSMUnpI7AP5PfNCVMo0WEdxGZ4u35p00DaHZODGbg+bn
         IXZllruYUf8YTOOriAdfbGEMs7hWDUB+uV7XZskgpEHw9Q48qy/yaCEGt8+D3g4dxo
         vthD80bb/I74L2pCC+yIUFxw9eWYi9CSwiJs1hf+28mAg6vjX40GwPf936XBrLOY6D
         QDrkWqGKDokWzWZ0E/k94jM9rHWP0fpb951+UMjm4F7yRZH+mw7ZAJ55RMDWypSM3A
         m2vDCgy2YCtVat3QouKxo4rq4eEzAROnzJXyZqA+aetpgDZy5Md2g4YvsQOpFIH8EE
         5OXs0bc48M5ug==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     ppbuk5246@gmail.com, damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        SeongJae Park <sj@kernel.org>
Subject: [PATCH v4] damon/sysfs: Fix possible memleak on damon_sysfs_add_target.
Date:   Mon, 26 Sep 2022 16:06:11 +0000
Message-Id: <20220926160611.48536-1-sj@kernel.org>
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

When damon_sysfs_add_target couldn't find proper task,
New allocated damon_target structure isn't registered yet,
So, it's impossible to free new allocated one by
damon_sysfs_destroy_targets.

By calling daemon_add_target as soon as allocating new target, Fix this
possible memory leak.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.17.x
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---

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

