Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E3E65D47C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbjADNjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239440AbjADNjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:39:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7312AFDE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:38:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E45661738
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F6FC433D2;
        Wed,  4 Jan 2023 13:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672839538;
        bh=dz73C5fvb+CVBGJ/dY40tddpCY0Atqr8f+LMHZJEvkU=;
        h=Subject:To:Cc:From:Date:From;
        b=TGYWs/nUA/EAN22DcJIUOU4ikNutBivvtzCM9X3O+UQK5eU0m+Sc2P30+LK7Jvj0A
         1GBRXbLh8SHIjf17/H6Kdvg5IHsFb1LgkiyTJNx4v4z6GnReIZTLdbPpRGyK5OCjAu
         B3DcZdrFRGZwn5cfwfFbQOlTrZOaqGQQ2shk7Zxk=
Subject: FAILED: patch "[PATCH] dm thin: resume even if in FAIL mode" failed to apply to 5.4-stable tree
To:     luomeng12@huawei.com, snitzer@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:38:55 +0100
Message-ID: <167283953549104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

19eb1650afeb ("dm thin: resume even if in FAIL mode")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 19eb1650afeb1aa86151f61900e9e5f1de5d8d02 Mon Sep 17 00:00:00 2001
From: Luo Meng <luomeng12@huawei.com>
Date: Wed, 30 Nov 2022 10:09:45 +0800
Subject: [PATCH] dm thin: resume even if in FAIL mode

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

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index dc271c107fb5..196f82559ad6 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3542,20 +3542,28 @@ static int pool_preresume(struct dm_target *ti)
 	 */
 	r = bind_control_target(pool, ti);
 	if (r)
-		return r;
+		goto out;
 
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

