Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7D44C07EE
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbiBWC3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbiBWC3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:29:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D0E46B28;
        Tue, 22 Feb 2022 18:28:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA991B81E0C;
        Wed, 23 Feb 2022 02:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AAFC340F1;
        Wed, 23 Feb 2022 02:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583325;
        bh=goSQsIx1vr5XuNPvESDGISMoMw1wJOGeLiM+1mNyTJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyxcFzfeLK81Gh/Ytpz5tHXaWGQYHODutEWetlfxf1l39JgjqoAwp4qHAcj1kLTMK
         x+vhh5T18DYFt3eRsu1u1pnJ8LULWML5NsGcq7xL9NA2CGupOaT6vOlq9RNhgs2KsW
         pL0xEuSIWpYC2o4+S6nAKcqJoPejFH8m6qXyQnTk/YlRxq3iCSUKzdiqRgP9zAgqpI
         5DTFP/aJklvjZ3KbmDaWho4mYbaDpN8/nU6GO2zQhvtiSLex/gB75WG9a2Lg7bANoo
         QKD5d0Mb2VismOVwdKx+EpnCZx+mgS/cfVdVnneWsk9n/Lue+DMMIwYRgCuQejPyhY
         on+ZbsBVXkRqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Vivek Goyal <vgoyal@redhat.com>,
        Pei Zhang <pezhang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 12/30] block: loop:use kstatfs.f_bsize of backing file to set discard granularity
Date:   Tue, 22 Feb 2022 21:28:01 -0500
Message-Id: <20220223022820.240649-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022820.240649-1-sashal@kernel.org>
References: <20220223022820.240649-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 06582bc86d7f48d35cd044098ca1e246e8c7c52e ]

If backing file's filesystem has implemented ->fallocate(), we think the
loop device can support discard, then pass sb->s_blocksize as
discard_granularity. However, some underlying FS, such as overlayfs,
doesn't set sb->s_blocksize, and causes discard_granularity to be set as
zero, then the warning in __blkdev_issue_discard() is triggered.

Christoph suggested to pass kstatfs.f_bsize as discard granularity, and
this way is fine because kstatfs.f_bsize means 'Optimal transfer block
size', which still matches with definition of discard granularity.

So fix the issue by setting discard_granularity as kstatfs.f_bsize if it
is available, otherwise claims discard isn't supported.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Reported-by: Pei Zhang <pezhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220126035830.296465-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c3a36cfaa855a..fdb4798cb0065 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -79,6 +79,7 @@
 #include <linux/ioprio.h>
 #include <linux/blk-cgroup.h>
 #include <linux/sched/mm.h>
+#include <linux/statfs.h>
 
 #include "loop.h"
 
@@ -774,8 +775,13 @@ static void loop_config_discard(struct loop_device *lo)
 		granularity = 0;
 
 	} else {
+		struct kstatfs sbuf;
+
 		max_discard_sectors = UINT_MAX >> 9;
-		granularity = inode->i_sb->s_blocksize;
+		if (!vfs_statfs(&file->f_path, &sbuf))
+			granularity = sbuf.f_bsize;
+		else
+			max_discard_sectors = 0;
 	}
 
 	if (max_discard_sectors) {
-- 
2.34.1

