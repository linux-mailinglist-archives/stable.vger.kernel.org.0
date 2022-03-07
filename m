Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41994CF73B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbiCGJpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbiCGJjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BFF6D84E;
        Mon,  7 Mar 2022 01:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA445B810CF;
        Mon,  7 Mar 2022 09:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364B3C340E9;
        Mon,  7 Mar 2022 09:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645702;
        bh=rW27RDIxb4zRm6FShjRgjJye5PiLNdSUc2enKTspRag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zyr9OPbpyEPPoTTdBZjQEm6LgcZYRC2day2ou8r5B4CmWT8jZxpVo9eGlekpjcEV1
         PhL63/uHSS3+okyM6nGtrWJi7WTK659iXAA0bV8tXx2iQNle4WOW/Ia6VbuHJ98XJF
         34u5AnfLlDZ5rS8H3S6QX8bl+OdNcEzDVUzTWCRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Vivek Goyal <vgoyal@redhat.com>,
        Pei Zhang <pezhang@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/262] block: loop:use kstatfs.f_bsize of backing file to set discard granularity
Date:   Mon,  7 Mar 2022 10:15:54 +0100
Message-Id: <20220307091702.668709970@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c00ae30fde89e..92f9d32bfae5e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -79,6 +79,7 @@
 #include <linux/ioprio.h>
 #include <linux/blk-cgroup.h>
 #include <linux/sched/mm.h>
+#include <linux/statfs.h>
 
 #include "loop.h"
 
@@ -939,8 +940,13 @@ static void loop_config_discard(struct loop_device *lo)
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



