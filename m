Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60F154985C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354123AbiFMMQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353067AbiFMMM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:12:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3BE53B40;
        Mon, 13 Jun 2022 04:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5B6E61435;
        Mon, 13 Jun 2022 11:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7547C34114;
        Mon, 13 Jun 2022 11:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118066;
        bh=zm3NxJOg9RcQO3Fv9XrGLlwhng3EzEDb0bxk1SNKPhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8Twe6JOiqeOqOaCYRjbejzUFfpwOvz/9S9cKrieKrJkFRNRbAgKIJvL72ydU/6W3
         5RQqr/BydyA17ksa/jPciycS5Yd2iMcMIK7eLWdHnY/NbQNhQwztsC+arAeBO+1agy
         WV4E7ev03Vrzhukjljg8pehTgQnogljj38o4GmuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 219/287] jffs2: fix memory leak in jffs2_do_fill_super
Date:   Mon, 13 Jun 2022 12:10:43 +0200
Message-Id: <20220613094930.500912195@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit c14adb1cf70a984ed081c67e9d27bc3caad9537c ]

If jffs2_iget() or d_make_root() in jffs2_do_fill_super() returns
an error, we can observe the following kmemleak report:

--------------------------------------------
unreferenced object 0xffff888105a65340 (size 64):
  comm "mount", pid 710, jiffies 4302851558 (age 58.239s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff859c45e5>] kmem_cache_alloc_trace+0x475/0x8a0
    [<ffffffff86160146>] jffs2_sum_init+0x96/0x1a0
    [<ffffffff86140e25>] jffs2_do_mount_fs+0x745/0x2120
    [<ffffffff86149fec>] jffs2_do_fill_super+0x35c/0x810
    [<ffffffff8614aae9>] jffs2_fill_super+0x2b9/0x3b0
    [...]
unreferenced object 0xffff8881bd7f0000 (size 65536):
  comm "mount", pid 710, jiffies 4302851558 (age 58.239s)
  hex dump (first 32 bytes):
    bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
    bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
  backtrace:
    [<ffffffff858579ba>] kmalloc_order+0xda/0x110
    [<ffffffff85857a11>] kmalloc_order_trace+0x21/0x130
    [<ffffffff859c2ed1>] __kmalloc+0x711/0x8a0
    [<ffffffff86160189>] jffs2_sum_init+0xd9/0x1a0
    [<ffffffff86140e25>] jffs2_do_mount_fs+0x745/0x2120
    [<ffffffff86149fec>] jffs2_do_fill_super+0x35c/0x810
    [<ffffffff8614aae9>] jffs2_fill_super+0x2b9/0x3b0
    [...]
--------------------------------------------

This is because the resources allocated in jffs2_sum_init() are not
released. Call jffs2_sum_exit() to release these resources to solve
the problem.

Fixes: e631ddba5887 ("[JFFS2] Add erase block summary support (mount time improvement)")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 81f7a6efe168..6afaace72f2b 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -598,6 +598,7 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	jffs2_free_raw_node_refs(c);
 	kvfree(c->blocks);
 	jffs2_clear_xattr_subsystem(c);
+	jffs2_sum_exit(c);
  out_inohash:
 	kfree(c->inocache_list);
  out_wbuf:
-- 
2.35.1



