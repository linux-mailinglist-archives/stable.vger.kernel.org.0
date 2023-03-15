Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE3A6BB357
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbjCOMno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbjCOMnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:43:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AC5A336F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACBE5B81E12
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09052C433EF;
        Wed, 15 Mar 2023 12:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884123;
        bh=RYRK5pU0obzR6PafdUd1j1wq+w9QAsWtn+eSgmN5Ur4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mh5wcNV145hbMWbSC9VSTnS0mVCSLP8grQLt9WVdwMom2RcYWzzXDj5hE/2Trt6ae
         X/7poAL3O/KfcDs7SgC+vs+CpbZeDwjayKop3/IR4PW35f5pTAyNA+m9Ql6QJftUtC
         9/i+VjjdPiz6qy7NHZJiQOoc9jEQdSxtkB/q9s4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+2bcc0d79e548c4f62a59@syzkaller.appspotmail.com,
        Julian Ruess <julianr@linux.ibm.com>,
        Yu Kuai <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 098/141] block: fix wrong mode for blkdev_put() from disk_scan_partitions()
Date:   Wed, 15 Mar 2023 13:13:21 +0100
Message-Id: <20230315115742.988754010@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 428913bce1e67ccb4dae317fd0332545bf8c9233 ]

If disk_scan_partitions() is called with 'FMODE_EXCL',
blkdev_get_by_dev() will be called without 'FMODE_EXCL', however, follow
blkdev_put() is still called with 'FMODE_EXCL', which will cause
'bd_holders' counter to leak.

Fix the problem by using the right mode for blkdev_put().

Reported-by: syzbot+2bcc0d79e548c4f62a59@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/f9649d501bc8c3444769418f6c26263555d9d3be.camel@linux.ibm.com/T/
Tested-by: Julian Ruess <julianr@linux.ibm.com>
Fixes: e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6cdaeb7169004..9c4c9aa559ab8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -385,7 +385,7 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 	if (IS_ERR(bdev))
 		ret =  PTR_ERR(bdev);
 	else
-		blkdev_put(bdev, mode);
+		blkdev_put(bdev, mode & ~FMODE_EXCL);
 
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(disk->part0, disk_scan_partitions);
-- 
2.39.2



