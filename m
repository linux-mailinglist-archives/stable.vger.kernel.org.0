Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D2666C8FE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbjAPQpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbjAPQo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:44:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025D62FCC2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C4A6104D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD86C433EF;
        Mon, 16 Jan 2023 16:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886741;
        bh=0NErp/aYFEwSUYmmBOpuqcHM6PBXRR+UU++iNt35tsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwfBexJdOczT9PsnLsK8mpJ5AP9ndp3zGDgminycDShbL4FJUUj8+BFnQIqrcb65u
         z1JDfbPd7pdI/+rLcwQ7FiuNPw6AFBPPrNOnho7lvPqCQDdvP1HsXTD7VZhw1DfSwM
         FSaPhLRCKL52ZqpV8n4bbXgOhWBbbiGS1zLb7qLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 543/658] dm thin: resume even if in FAIL mode
Date:   Mon, 16 Jan 2023 16:50:31 +0100
Message-Id: <20230116154934.374987861@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Luo Meng <luomeng12@huawei.com>

[ Upstream commit 19eb1650afeb1aa86151f61900e9e5f1de5d8d02 ]

If a thinpool set fail_io while suspending, resume will fail with:
 device-mapper: resume ioctl on vg-thinpool  failed: Invalid argument

The thin-pool also can't be removed if an in-flight bio is in the
deferred list.

This can be easily reproduced using:

  echo "offline" > /sys/block/sda/device/state
  dd if=/dev/zero of=/dev/mapper/thin bs=4K count=1
  dmsetup suspend /dev/mapper/pool
  mkfs.ext4 /dev/mapper/thin
  dmsetup resume /dev/mapper/pool

The root cause is maybe_resize_data_dev() will check fail_io and return
error before called dm_resume.

Fix this by adding FAIL mode check at the end of pool_preresume().

Cc: stable@vger.kernel.org
Fixes: da105ed5fd7e ("dm thin metadata: introduce dm_pool_abort_metadata")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-thin.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1af5873923e8..4f161725dda0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3593,23 +3593,31 @@ static int pool_preresume(struct dm_target *ti)
 	 */
 	r = bind_control_target(pool, ti);
 	if (r)
-		return r;
+		goto out;
 
 	dm_pool_register_pre_commit_callback(pool->pmd,
 					     metadata_pre_commit_callback, pt);
 
 	r = maybe_resize_data_dev(ti, &need_commit1);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_metadata_dev(ti, &need_commit2);
 	if (r)
-		return r;
+		goto out;
 
 	if (need_commit1 || need_commit2)
 		(void) commit(pool);
+out:
+	/*
+	 * When a thin-pool is PM_FAIL, it cannot be rebuilt if
+	 * bio is in deferred list. Therefore need to return 0
+	 * to allow pool_resume() to flush IO.
+	 */
+	if (r && get_pool_mode(pool) == PM_FAIL)
+		r = 0;
 
-	return 0;
+	return r;
 }
 
 static void pool_suspend_active_thins(struct pool *pool)
-- 
2.35.1



