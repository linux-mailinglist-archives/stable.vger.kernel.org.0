Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5725EA539
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238936AbiIZL7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238929AbiIZL6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:58:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C380D7B2A3;
        Mon, 26 Sep 2022 03:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AC4D60AF3;
        Mon, 26 Sep 2022 10:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4F1C433D7;
        Mon, 26 Sep 2022 10:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189439;
        bh=Ut33842hwx4a/yaziEGJ5m5FGmvxrtCCOxpdvH3Jrog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIBZC7YSGQRxeUG4D2QGCezfb8uXQH62YZsLoPyKEaUfI7dE2ffXYl45LYJxHOmFi
         h4pMwqzq3htNaHbmoApoZtYzCb8o00erHvv6qSWaHO8H88uSclrGCiIp/PSz+iP2wG
         Oi6CNJsyoIsWLqgok59Crcl0BAa3mzsf8YvUmkVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jinlin <lijinlin3@huawei.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 188/207] fsdax: Fix infinite loop in dax_iomap_rw()
Date:   Mon, 26 Sep 2022 12:12:57 +0200
Message-Id: <20220926100815.032294339@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jinlin <lijinlin3@huawei.com>

[ Upstream commit 17d9c15c9b9e7fb285f7ac5367dfb5f00ff575e3 ]

I got an infinite loop and a WARNING report when executing a tail command
in virtiofs.

  WARNING: CPU: 10 PID: 964 at fs/iomap/iter.c:34 iomap_iter+0x3a2/0x3d0
  Modules linked in:
  CPU: 10 PID: 964 Comm: tail Not tainted 5.19.0-rc7
  Call Trace:
  <TASK>
  dax_iomap_rw+0xea/0x620
  ? __this_cpu_preempt_check+0x13/0x20
  fuse_dax_read_iter+0x47/0x80
  fuse_file_read_iter+0xae/0xd0
  new_sync_read+0xfe/0x180
  ? 0xffffffff81000000
  vfs_read+0x14d/0x1a0
  ksys_read+0x6d/0xf0
  __x64_sys_read+0x1a/0x20
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

The tail command will call read() with a count of 0. In this case,
iomap_iter() will report this WARNING, and always return 1 which casuing
the infinite loop in dax_iomap_rw().

Fixing by checking count whether is 0 in dax_iomap_rw().

Fixes: ca289e0b95af ("fsdax: switch dax_iomap_rw to use iomap_iter")
Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20220725032050.3873372-1-lijinlin3@huawei.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 4155a6107fa1..7ab248ed21aa 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1241,6 +1241,9 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t done = 0;
 	int ret;
 
+	if (!iomi.len)
+		return 0;
+
 	if (iov_iter_rw(iter) == WRITE) {
 		lockdep_assert_held_write(&iomi.inode->i_rwsem);
 		iomi.flags |= IOMAP_WRITE;
-- 
2.35.1



