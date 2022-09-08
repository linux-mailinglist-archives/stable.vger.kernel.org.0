Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFCB5B1AA1
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 12:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIHKxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 06:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIHKxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 06:53:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0024EF7748;
        Thu,  8 Sep 2022 03:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78A87B82081;
        Thu,  8 Sep 2022 10:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DBBC433D6;
        Thu,  8 Sep 2022 10:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662634425;
        bh=/uQGY/TLUWDSIoiHlfo1tz7P2bAvlkNOsxUtduE+0OI=;
        h=From:To:Cc:Subject:Date:From;
        b=gfdFSnqYnme8GldZpLsp33ZY5vG9mm5BTo5f8ffhE5V0sH82s4MhPlZNckpLxblOt
         kSVhHh9kL7h1u606MAINkiwGQLbhfny2LTXS520l8IlnZzHQlw9n8L2A9K7Ny2H1jg
         idaPPN34LdZyIOT4QUQJ37dy6Q+uCuJObFa4R6RIa7u4u0sBTU1BaGHOpa7HrSMB5p
         FnnuaxLV0qSLgDVeo57kEq3u2I0pWLe9c2uINtQO3cLZT3MwRTORn7qx3OsJ2LxrVg
         gvQ4nknJINvPjLajikJkl5aKfHO2Vle/WRMZ8cC4CBw8sZrpsPzOo5fgXs4uSPwTYW
         43IeEa6er2uBw==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org,
        syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com
Subject: [PATCH] f2fs: fix to detect obsolete inner inode during fill_super()
Date:   Thu,  8 Sep 2022 18:53:34 +0800
Message-Id: <20220908105334.98572-1-chao@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

Sometimes we can get a cached meta_inode which has no aops yet. Let's set it
all the time to fix the below panic.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000086000004
  EC = 0x21: IABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109ee4000
[0000000000000000] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 86000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 3045 Comm: syz-executor330 Not tainted 6.0.0-rc2-syzkaller-16455-ga41a877bc12d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : 0x0
lr : folio_mark_dirty+0xbc/0x208 mm/page-writeback.c:2748
sp : ffff800012783970
x29: ffff800012783970 x28: 0000000000000000 x27: ffff800012783b08
x26: 0000000000000001 x25: 0000000000000400 x24: 0000000000000001
x23: ffff0000c736e000 x22: 0000000000000045 x21: 05ffc00000000015
x20: ffff0000ca7403b8 x19: fffffc00032ec600 x18: 0000000000000181
x17: ffff80000c04d6bc x16: ffff80000dbb8658 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
x11: ff808000083e9814 x10: 0000000000000000 x9 : ffff8000083e9814
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffff0000cbb19000 x4 : ffff0000cb3d2000 x3 : ffff0000cbb18f80
x2 : fffffffffffffff0 x1 : fffffc00032ec600 x0 : ffff0000ca7403b8
Call trace:
 0x0
 set_page_dirty+0x38/0xbc mm/folio-compat.c:62
 f2fs_update_meta_page+0x80/0xa8 fs/f2fs/segment.c:2369
 do_checkpoint+0x794/0xea8 fs/f2fs/checkpoint.c:1522
 f2fs_write_checkpoint+0x3b8/0x568 fs/f2fs/checkpoint.c:1679

The root cause is, quoted from Jaegeuk:

It turned out there is a bug in reiserfs which doesn't free the root
inode (ino=2). That leads f2fs to find an ino=2 with the previous
superblock point used by reiserfs. That stale inode has no valid
mapping that f2fs can use, result in kernel panic.

This patch adds sanity check in f2fs_iget() to avoid finding stale
inode during inner inode initialization.

Cc: stable@vger.kernel.org
Reported-by: syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
---
 fs/f2fs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ccb29034af59..df1a82fbfaf2 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -493,6 +493,17 @@ struct inode *f2fs_iget_inner(struct super_block *sb, unsigned long ino)
 	struct inode *inode;
 	int ret = 0;
 
+	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi) ||
+					ino == F2FS_COMPRESS_INO(sbi)) {
+		inode = ilookup(sb, ino);
+		if (inode) {
+			iput(inode);
+			f2fs_err(sbi, "there is obsoleted inner inode %lu cached in hash table",
+					ino);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
+	}
+
 	inode = iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
-- 
2.25.1

