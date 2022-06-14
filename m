Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0988A54A5B9
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353060AbiFNCPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354688AbiFNCO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:14:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB4B3C484;
        Mon, 13 Jun 2022 19:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D49161019;
        Tue, 14 Jun 2022 02:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85007C341C0;
        Tue, 14 Jun 2022 02:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172536;
        bh=kPhGt68UYbMxmvBml7tLO2pug4dgiKx+pxPUPlsO/Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyz1ihuDnGrJY47+RAttUFwGmpoUVlhBx+VFMMrE8Tb+p8/vRrdQlRLWspnqM/PSo
         RgbmEh4K49aGiT2xeIDCIO3dUAn54fHZUeRcHTd5BTJQ7RT9++vBRrVytzkSugtcA4
         G2ey+nl2mLCETLByPehy/bNJpaYjt84Tm3AU3NpjyXIPOdmkp7PorHjto6/rQyuuAe
         SQkKpik58z4lLwC57IcrrNW3EeIWwIRZ0P+QarhFvQpiYRVmrg15wT08o4j+z05Yhx
         OkjTmXawwwr9UPMiDmatQ4G7vcgo4m25ji9rRAAwbO65Eo3y5MG1BKnDddwp2heWfx
         LU3X6NueDWAPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, zyan@redhat.com,
        sage@redhat.com, idryomov@gmail.com, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/29] netfs: gcc-12: temporarily disable '-Wattribute-warning' for now
Date:   Mon, 13 Jun 2022 22:08:13 -0400
Message-Id: <20220614020815.1099999-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020815.1099999-1-sashal@kernel.org>
References: <20220614020815.1099999-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 507160f46c55913955d272ebf559d63809a8e560 ]

This is a pure band-aid so that I can continue merging stuff from people
while some of the gcc-12 fallout gets sorted out.

In particular, gcc-12 is very unhappy about the kinds of pointer
arithmetic tricks that netfs does, and that makes the fortify checks
trigger in afs and ceph:

  In function ‘fortify_memset_chk’,
      inlined from ‘netfs_i_context_init’ at include/linux/netfs.h:327:2,
      inlined from ‘afs_set_netfs_context’ at fs/afs/inode.c:61:2,
      inlined from ‘afs_root_iget’ at fs/afs/inode.c:543:2:
  include/linux/fortify-string.h:258:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
    258 |                         __write_overflow_field(p_size_field, size);
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

and the reason is that netfs_i_context_init() is passed a 'struct inode'
pointer, and then it does

        struct netfs_i_context *ctx = netfs_i_context(inode);

        memset(ctx, 0, sizeof(*ctx));

where that netfs_i_context() function just does pointer arithmetic on
the inode pointer, knowing that the netfs_i_context is laid out
immediately after it in memory.

This is all truly disgusting, since the whole "netfs_i_context is laid
out immediately after it in memory" is not actually remotely true in
general, but is just made to be that way for afs and ceph.

See for example fs/cifs/cifsglob.h:

  struct cifsInodeInfo {
        struct {
                /* These must be contiguous */
                struct inode    vfs_inode;      /* the VFS's inode record */
                struct netfs_i_context netfs_ctx; /* Netfslib context */
        };
	[...]

and realize that this is all entirely wrong, and the pointer arithmetic
that netfs_i_context() is doing is also very very wrong and wouldn't
give the right answer if netfs_ctx had different alignment rules from a
'struct inode', for example).

Anyway, that's just a long-winded way to say "the gcc-12 warning is
actually quite reasonable, and our code happens to work but is pretty
disgusting".

This is getting fixed properly, but for now I made the mistake of
thinking "the week right after the merge window tends to be calm for me
as people take a breather" and I did a sustem upgrade.  And I got gcc-12
as a result, so to continue merging fixes from people and not have the
end result drown in warnings, I am fixing all these gcc-12 issues I hit.

Including with these kinds of temporary fixes.

Cc: Kees Cook <keescook@chromium.org>
Cc: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/all/AEEBCF5D-8402-441D-940B-105AA718C71F@chromium.org/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c  | 3 +++
 fs/ceph/inode.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 7e7a9454bcb9..942badb9b24b 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -25,6 +25,9 @@
 #include "internal.h"
 #include "afs_fs.h"
 
+// Temporary: netfs does disgusting things with inode pointers
+#pragma GCC diagnostic ignored "-Wattribute-warning"
+
 static const struct inode_operations afs_symlink_inode_operations = {
 	.get_link	= page_get_link,
 };
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 76be50f6f041..394501d347f4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -20,6 +20,9 @@
 #include "cache.h"
 #include <linux/ceph/decode.h>
 
+// Temporary: netfs does disgusting things with inode pointers
+#pragma GCC diagnostic ignored "-Wattribute-warning"
+
 /*
  * Ceph inode operations
  *
-- 
2.35.1

