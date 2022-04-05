Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDA94F3A7C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381473AbiDELpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354828AbiDEKQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:16:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05476C93D;
        Tue,  5 Apr 2022 03:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B0B0B81BC0;
        Tue,  5 Apr 2022 10:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E368CC385A2;
        Tue,  5 Apr 2022 10:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152977;
        bh=5IqUjJTSOJ5iA71G3v7PMy802c6wfxcw7Yd0aVsWReA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJjKbHsoO3GUe++/kLFqcD2SzKBmBUqiFEDb8vXvjWpYciufNHxT/8uo7stwnI10o
         9mew8m/PYgT+gm6dmgC2uR6a+xON2tq5Xc2bnMtJikUtvh5kR70S/+iK4R961Ku7Lg
         7V9+I0K7LToev98L+SW8DIWLk05bxFuWYcxK+vH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 057/599] jffs2: fix memory leak in jffs2_do_mount_fs
Date:   Tue,  5 Apr 2022 09:25:51 +0200
Message-Id: <20220405070300.524656148@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

commit d051cef784de4d54835f6b6836d98a8f6935772c upstream.

If jffs2_build_filesystem() in jffs2_do_mount_fs() returns an error,
we can observe the following kmemleak report:

--------------------------------------------
unreferenced object 0xffff88811b25a640 (size 64):
  comm "mount", pid 691, jiffies 4294957728 (age 71.952s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffffa493be24>] kmem_cache_alloc_trace+0x584/0x880
    [<ffffffffa5423a06>] jffs2_sum_init+0x86/0x130
    [<ffffffffa5400e58>] jffs2_do_mount_fs+0x798/0xac0
    [<ffffffffa540acf3>] jffs2_do_fill_super+0x383/0xc30
    [<ffffffffa540c00a>] jffs2_fill_super+0x2ea/0x4c0
    [...]
unreferenced object 0xffff88812c760000 (size 65536):
  comm "mount", pid 691, jiffies 4294957728 (age 71.952s)
  hex dump (first 32 bytes):
    bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
    bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
  backtrace:
    [<ffffffffa493a449>] __kmalloc+0x6b9/0x910
    [<ffffffffa5423a57>] jffs2_sum_init+0xd7/0x130
    [<ffffffffa5400e58>] jffs2_do_mount_fs+0x798/0xac0
    [<ffffffffa540acf3>] jffs2_do_fill_super+0x383/0xc30
    [<ffffffffa540c00a>] jffs2_fill_super+0x2ea/0x4c0
    [...]
--------------------------------------------

This is because the resources allocated in jffs2_sum_init() are not
released. Call jffs2_sum_exit() to release these resources to solve
the problem.

Fixes: e631ddba5887 ("[JFFS2] Add erase block summary support (mount time improvement)")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/build.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/jffs2/build.c
+++ b/fs/jffs2/build.c
@@ -415,13 +415,15 @@ int jffs2_do_mount_fs(struct jffs2_sb_in
 		jffs2_free_ino_caches(c);
 		jffs2_free_raw_node_refs(c);
 		ret = -EIO;
-		goto out_free;
+		goto out_sum_exit;
 	}
 
 	jffs2_calc_trigger_levels(c);
 
 	return 0;
 
+ out_sum_exit:
+	jffs2_sum_exit(c);
  out_free:
 	kvfree(c->blocks);
 


