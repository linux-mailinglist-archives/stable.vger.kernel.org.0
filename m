Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2DE6B4B38
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbjCJPfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbjCJPfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:35:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D08C150EDE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:22:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1078A6187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B62BC433D2;
        Fri, 10 Mar 2023 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461088;
        bh=nN/Ae12/P5RC5D78WcJNyCNwWknEFYjTHvwiaFEOH6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFiKMYxd20m0Lezgg1dSQYf196dd+qQjRVFdl1MCtzF4rrQk1TGQ2EXdJV6h7ZIJM
         Dsr0UWms6RzluZSReiI6QmpLIGykjGeM5vj8WiIVeqiC6wNlUaNxXbMkTCa+SvfBBP
         Ky1XdiRPk+xBiTOB/ocDLDoxZiJ3qXiVf8dXVLUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/136] ubifs: Fix memory leak in alloc_wbufs()
Date:   Fri, 10 Mar 2023 14:42:23 +0100
Message-Id: <20230310133707.604336239@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 4a1ff3c5d04b9079b4f768d9a71b51c4af578dd2 ]

kmemleak reported a sequence of memory leaks, and show them as following:

  unreferenced object 0xffff8881575f8400 (size 1024):
    comm "mount", pid 19625, jiffies 4297119604 (age 20.383s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff8176cecd>] __kmalloc+0x4d/0x150
      [<ffffffffa0406b2b>] ubifs_mount+0x307b/0x7170 [ubifs]
      [<ffffffff819fa8fd>] legacy_get_tree+0xed/0x1d0
      [<ffffffff81936f2d>] vfs_get_tree+0x7d/0x230
      [<ffffffff819b2bd4>] path_mount+0xdd4/0x17b0
      [<ffffffff819b37aa>] __x64_sys_mount+0x1fa/0x270
      [<ffffffff83c14295>] do_syscall_64+0x35/0x80
      [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

  unreferenced object 0xffff8881798a6e00 (size 512):
    comm "mount", pid 19677, jiffies 4297121912 (age 37.816s)
    hex dump (first 32 bytes):
      6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
      6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    backtrace:
      [<ffffffff8176cecd>] __kmalloc+0x4d/0x150
      [<ffffffffa0418342>] ubifs_wbuf_init+0x52/0x480 [ubifs]
      [<ffffffffa0406ca5>] ubifs_mount+0x31f5/0x7170 [ubifs]
      [<ffffffff819fa8fd>] legacy_get_tree+0xed/0x1d0
      [<ffffffff81936f2d>] vfs_get_tree+0x7d/0x230
      [<ffffffff819b2bd4>] path_mount+0xdd4/0x17b0
      [<ffffffff819b37aa>] __x64_sys_mount+0x1fa/0x270
      [<ffffffff83c14295>] do_syscall_64+0x35/0x80
      [<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

The problem is that the ubifs_wbuf_init() returns an error in the
loop which in the alloc_wbufs(), then the wbuf->buf and wbuf->inodes
that were successfully alloced before are not freed.

Fix it by adding error hanging path in alloc_wbufs() which frees
the memory alloced before when ubifs_wbuf_init() returns an error.

Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/super.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index eb05038b71911..32c1f428054b7 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -833,7 +833,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 		INIT_LIST_HEAD(&c->jheads[i].buds_list);
 		err = ubifs_wbuf_init(c, &c->jheads[i].wbuf);
 		if (err)
-			return err;
+			goto out_wbuf;
 
 		c->jheads[i].wbuf.sync_callback = &bud_wbuf_callback;
 		c->jheads[i].wbuf.jhead = i;
@@ -841,7 +841,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 		c->jheads[i].log_hash = ubifs_hash_get_desc(c);
 		if (IS_ERR(c->jheads[i].log_hash)) {
 			err = PTR_ERR(c->jheads[i].log_hash);
-			goto out;
+			goto out_log_hash;
 		}
 	}
 
@@ -854,9 +854,18 @@ static int alloc_wbufs(struct ubifs_info *c)
 
 	return 0;
 
-out:
-	while (i--)
+out_log_hash:
+	kfree(c->jheads[i].wbuf.buf);
+	kfree(c->jheads[i].wbuf.inodes);
+
+out_wbuf:
+	while (i--) {
+		kfree(c->jheads[i].wbuf.buf);
+		kfree(c->jheads[i].wbuf.inodes);
 		kfree(c->jheads[i].log_hash);
+	}
+	kfree(c->jheads);
+	c->jheads = NULL;
 
 	return err;
 }
-- 
2.39.2



