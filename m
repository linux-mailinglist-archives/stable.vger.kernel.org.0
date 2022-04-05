Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728894F3518
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244462AbiDEKiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbiDEJev (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD92887B2;
        Tue,  5 Apr 2022 02:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3D96B81C69;
        Tue,  5 Apr 2022 09:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5233CC385A0;
        Tue,  5 Apr 2022 09:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150648;
        bh=sKywzZUH5FV82mHccsP45ibhee3xzG3cgiuNbnWvg4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+7GjQh+aPzoKpJGZ83JVPKNUXEYFOiikx1iZJVkPpoEW732oZhnJL5ItyeKj84OJ
         ltTY5vUBLtI3I4sm7SG+Q7RrrJLGe3gkSfCch2u7XuhaQ/3z8qXHCXTf/NkYyMjVoV
         t0oEgDw5rnf6M9aqGNs0XW3GapAAqkUDDp0spizA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 082/913] jffs2: fix memory leak in jffs2_scan_medium
Date:   Tue,  5 Apr 2022 09:19:04 +0200
Message-Id: <20220405070342.281702665@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Baokun Li <libaokun1@huawei.com>

commit 9cdd3128874f5fe759e2c4e1360ab7fb96a8d1df upstream.

If an error is returned in jffs2_scan_eraseblock() and some memory
has been added to the jffs2_summary *s, we can observe the following
kmemleak report:

--------------------------------------------
unreferenced object 0xffff88812b889c40 (size 64):
  comm "mount", pid 692, jiffies 4294838325 (age 34.288s)
  hex dump (first 32 bytes):
    40 48 b5 14 81 88 ff ff 01 e0 31 00 00 00 50 00  @H........1...P.
    00 00 01 00 00 00 01 00 00 00 02 00 00 00 09 08  ................
  backtrace:
    [<ffffffffae93a3a3>] __kmalloc+0x613/0x910
    [<ffffffffaf423b9c>] jffs2_sum_add_dirent_mem+0x5c/0xa0
    [<ffffffffb0f3afa8>] jffs2_scan_medium.cold+0x36e5/0x4794
    [<ffffffffb0f3dbe1>] jffs2_do_mount_fs.cold+0xa7/0x2267
    [<ffffffffaf40acf3>] jffs2_do_fill_super+0x383/0xc30
    [<ffffffffaf40c00a>] jffs2_fill_super+0x2ea/0x4c0
    [<ffffffffb0315d64>] mtd_get_sb+0x254/0x400
    [<ffffffffb0315f5f>] mtd_get_sb_by_nr+0x4f/0xd0
    [<ffffffffb0316478>] get_tree_mtd+0x498/0x840
    [<ffffffffaf40bd15>] jffs2_get_tree+0x25/0x30
    [<ffffffffae9f358d>] vfs_get_tree+0x8d/0x2e0
    [<ffffffffaea7a98f>] path_mount+0x50f/0x1e50
    [<ffffffffaea7c3d7>] do_mount+0x107/0x130
    [<ffffffffaea7c5c5>] __se_sys_mount+0x1c5/0x2f0
    [<ffffffffaea7c917>] __x64_sys_mount+0xc7/0x160
    [<ffffffffb10142f5>] do_syscall_64+0x45/0x70
unreferenced object 0xffff888114b54840 (size 32):
  comm "mount", pid 692, jiffies 4294838325 (age 34.288s)
  hex dump (first 32 bytes):
    c0 75 b5 14 81 88 ff ff 02 e0 02 00 00 00 02 00  .u..............
    00 00 84 00 00 00 44 00 00 00 6b 6b 6b 6b 6b a5  ......D...kkkkk.
  backtrace:
    [<ffffffffae93be24>] kmem_cache_alloc_trace+0x584/0x880
    [<ffffffffaf423b04>] jffs2_sum_add_inode_mem+0x54/0x90
    [<ffffffffb0f3bd44>] jffs2_scan_medium.cold+0x4481/0x4794
    [...]
unreferenced object 0xffff888114b57280 (size 32):
  comm "mount", pid 692, jiffies 4294838393 (age 34.357s)
  hex dump (first 32 bytes):
    10 d5 6c 11 81 88 ff ff 08 e0 05 00 00 00 01 00  ..l.............
    00 00 38 02 00 00 28 00 00 00 6b 6b 6b 6b 6b a5  ..8...(...kkkkk.
  backtrace:
    [<ffffffffae93be24>] kmem_cache_alloc_trace+0x584/0x880
    [<ffffffffaf423c34>] jffs2_sum_add_xattr_mem+0x54/0x90
    [<ffffffffb0f3a24f>] jffs2_scan_medium.cold+0x298c/0x4794
    [...]
unreferenced object 0xffff8881116cd510 (size 16):
  comm "mount", pid 692, jiffies 4294838395 (age 34.355s)
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 09 e0 60 02 00 00 6b a5  ..........`...k.
  backtrace:
    [<ffffffffae93be24>] kmem_cache_alloc_trace+0x584/0x880
    [<ffffffffaf423cc4>] jffs2_sum_add_xref_mem+0x54/0x90
    [<ffffffffb0f3b2e3>] jffs2_scan_medium.cold+0x3a20/0x4794
    [...]
--------------------------------------------

Therefore, we should call jffs2_sum_reset_collected(s) on exit to
release the memory added in s. In addition, a new tag "out_buf" is
added to prevent the NULL pointer reference caused by s being NULL.
(thanks to Zhang Yi for this analysis)

Fixes: e631ddba5887 ("[JFFS2] Add erase block summary support (mount time improvement)")
Cc: stable@vger.kernel.org
Co-developed-with: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/scan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -136,7 +136,7 @@ int jffs2_scan_medium(struct jffs2_sb_in
 		if (!s) {
 			JFFS2_WARNING("Can't allocate memory for summary\n");
 			ret = -ENOMEM;
-			goto out;
+			goto out_buf;
 		}
 	}
 
@@ -275,13 +275,15 @@ int jffs2_scan_medium(struct jffs2_sb_in
 	}
 	ret = 0;
  out:
+	jffs2_sum_reset_collected(s);
+	kfree(s);
+ out_buf:
 	if (buf_size)
 		kfree(flashbuf);
 #ifndef __ECOS
 	else
 		mtd_unpoint(c->mtd, 0, c->mtd->size);
 #endif
-	kfree(s);
 	return ret;
 }
 


