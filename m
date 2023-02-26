Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620CE6A33F1
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 21:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBZU1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 15:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjBZU1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 15:27:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A11C652;
        Sun, 26 Feb 2023 12:27:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B214B80955;
        Sun, 26 Feb 2023 20:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23DFC433D2;
        Sun, 26 Feb 2023 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677443250;
        bh=mDpvwUjTBC41wj3URxPDiSPiuuTB7fx5rM316JgomIo=;
        h=Date:To:From:Subject:From;
        b=AuGHJP4dPZTXVQXYek14ZrxMrv+hlF+EFguZB46Z3T0yYvuEx5QCGkm9NMDb0DjM7
         a4u3mYf4z4KgAjrVi2tScRsYGAiKOghvnMbRGwWacXaFPK1ydai7a1GT9z/E+TRn8R
         oDquISokJOFbTNqs/1s8rTv4gMRAYlLO4WW+KZlM=
Date:   Sun, 26 Feb 2023 12:27:30 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu, stable@vger.kernel.org,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        bvanassche@acm.org, axboe@kernel.dk, mudongliangabcd@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-hfsplus-fix-uaf-issue-in-hfsplus_put_super.patch added to mm-hotfixes-unstable branch
Message-Id: <20230226202730.D23DFC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs: hfsplus: fix UAF issue in hfsplus_put_super
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-hfsplus-fix-uaf-issue-in-hfsplus_put_super.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-hfsplus-fix-uaf-issue-in-hfsplus_put_super.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
+++ b/fs/hfsplus/super.c
@@ -295,11 +295,11 @@ static void hfsplus_put_super(struct super_block *sb)
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

fs-hfsplus-fix-uaf-issue-in-hfsplus_put_super.patch

