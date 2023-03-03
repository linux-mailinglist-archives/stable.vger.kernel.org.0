Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32C66A90A2
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 06:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjCCFzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 00:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjCCFzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 00:55:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E94638EB0;
        Thu,  2 Mar 2023 21:55:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D985DCE1E6F;
        Fri,  3 Mar 2023 05:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E711FC4339B;
        Fri,  3 Mar 2023 05:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822903;
        bh=xlfeljUCOCTVUW30TZQVT+zQBB38ZP10UTxWkyvnQuU=;
        h=Date:To:From:Subject:From;
        b=H8ZTnh1F32VqFWeNVD0HIPYoZtoJN7eSE6ZlwJbmPCIUmyOqRPS7gNSAAjHhnsAKF
         kBcsJKjt4ShsiBbZ/p+nUd8p4JcjK+sUFWGB5Ljc4JT35S4s4rKdTDGlca7IxLoX1n
         9BSb4MvtQKFtnKf4Dml7nnEKQMn+JZQRbsgXi1LY=
Date:   Thu, 02 Mar 2023 21:55:02 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu, stable@vger.kernel.org,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        bvanassche@acm.org, axboe@kernel.dk, mudongliangabcd@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-hfsplus-fix-uaf-issue-in-hfsplus_put_super.patch removed from -mm tree
Message-Id: <20230303055502.E711FC4339B@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: fs: hfsplus: fix UAF issue in hfsplus_put_super
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-fix-uaf-issue-in-hfsplus_put_super.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dongliang Mu <mudongliangabcd@gmail.com>
Subject: fs: hfsplus: fix UAF issue in hfsplus_put_super
Date: Sun, 26 Feb 2023 20:49:47 +0800

The current hfsplus_put_super first calls hfs_btree_close on
sbi->ext_tree, then invokes iput on sbi->hidden_dir, resulting in an
use-after-free issue in hfsplus_release_folio.

As shown in hfsplus_fill_super, the error handling code also calls iput
before hfs_btree_close.

To fix this error, we move all iput calls before hfsplus_btree_close.

Note that this patch is tested on Syzbot.

Link: https://lkml.kernel.org/r/20230226124948.3175736-1-mudongliangabcd@gmail.com
Reported-by: syzbot+57e3e98f7e3b80f64d56@syzkaller.appspotmail.com
Tested-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hfsplus/super.c~fs-hfsplus-fix-uaf-issue-in-hfsplus_put_super
+++ a/fs/hfsplus/super.c
@@ -295,11 +295,11 @@ static void hfsplus_put_super(struct sup
 		hfsplus_sync_fs(sb, 1);
 	}
 
+	iput(sbi->alloc_file);
+	iput(sbi->hidden_dir);
 	hfs_btree_close(sbi->attr_tree);
 	hfs_btree_close(sbi->cat_tree);
 	hfs_btree_close(sbi->ext_tree);
-	iput(sbi->alloc_file);
-	iput(sbi->hidden_dir);
 	kfree(sbi->s_vhdr_buf);
 	kfree(sbi->s_backup_vhdr_buf);
 	unload_nls(sbi->nls);
_

Patches currently in -mm which might be from mudongliangabcd@gmail.com are


