Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5994D53A8B9
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355129AbiFAOLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354650AbiFAOJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:09:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC4FD11B;
        Wed,  1 Jun 2022 07:01:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C33A4B8175B;
        Wed,  1 Jun 2022 14:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7368AC385A5;
        Wed,  1 Jun 2022 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092063;
        bh=LZSVzGm+eApsXK45dI2BFu9jzJnYL96WdCNobNzk1qI=;
        h=From:To:Cc:Subject:Date:From;
        b=DmVt2KgdLDzTBOBEltgu0qcN9lXQCBXIzW581N9PB2DiS8ngZOpIncmwvaSFJCBeg
         FbWwVhkFCKsNLQGOjWemQWNAInWbzcC8YW+yXAzlcTbCJQDE+4A/2ZQeMhUQMxNWax
         Q8/nXHyE5Od7CZgjw7Zbt8KL1FJG0KTiF6pFrJesyVaX6Sh1I1ICpTu58L3q6kUOtE
         PO8ToD4iaZvQHW69j5rTHtdRpLiKYS/ArjqpRhJOK7uncvTVTAv2uZBSJgDaAJnUH4
         RE2/gdkz5MjIs31Odm8nXJ+ZzyLpwZS09liWQSaVKMe5Z4nyqwOxiadmZ+Lg/gv+qd
         LosWNNQZf/Yhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zixuan Fu <r33s3n6@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>, shaggy@kernel.org,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 01/11] fs: jfs: fix possible NULL pointer dereference in dbFree()
Date:   Wed,  1 Jun 2022 10:00:50 -0400
Message-Id: <20220601140100.2005469-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zixuan Fu <r33s3n6@gmail.com>

[ Upstream commit 0d4837fdb796f99369cf7691d33de1b856bcaf1f ]

In our fault-injection testing, the variable "nblocks" in dbFree() can be
zero when kmalloc_array() fails in dtSearch(). In this case, the variable
 "mp" in dbFree() would be NULL and then it is dereferenced in
"write_metapage(mp)".

The failure log is listed as follows:

[   13.824137] BUG: kernel NULL pointer dereference, address: 0000000000000020
...
[   13.827416] RIP: 0010:dbFree+0x5f7/0x910 [jfs]
[   13.834341] Call Trace:
[   13.834540]  <TASK>
[   13.834713]  txFreeMap+0x7b4/0xb10 [jfs]
[   13.835038]  txUpdateMap+0x311/0x650 [jfs]
[   13.835375]  jfs_lazycommit+0x5f2/0xc70 [jfs]
[   13.835726]  ? sched_dynamic_update+0x1b0/0x1b0
[   13.836092]  kthread+0x3c2/0x4a0
[   13.836355]  ? txLockFree+0x160/0x160 [jfs]
[   13.836763]  ? kthread_unuse_mm+0x160/0x160
[   13.837106]  ret_from_fork+0x1f/0x30
[   13.837402]  </TASK>
...

This patch adds a NULL check of "mp" before "write_metapage(mp)" is called.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 6dac48e29d28..a07fbb60ac3c 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -398,7 +398,8 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 	}
 
 	/* write the last buffer. */
-	write_metapage(mp);
+	if (mp)
+		write_metapage(mp);
 
 	IREAD_UNLOCK(ipbmap);
 
-- 
2.35.1

