Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586F76B4143
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjCJNvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjCJNvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:51:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4566109740
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:51:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68B9A60D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CB1C433D2;
        Fri, 10 Mar 2023 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456260;
        bh=h0gkbHx/Utiz4VT1kjLd4LZ5lPuLdZIz/T9F3Rdtv2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clutRItrGNzLc6GcUt1geifRHzhWSgw4e1wJ0dd3pIp5f9j95WYtKJdbczi+J937x
         pXUcIM+qJsUxCKZWPsngZeEiAEID38LxzV1KxUpoXbpDoBhqVhml+sY5twkVhwsVBG
         8czqx4IgZxJKpcfQrJ/AMu/HIRj8kqNqth01Adgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+57e3e98f7e3b80f64d56@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>,
        Muchun Song <songmuchun@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        "Theodore Tso" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 103/193] fs: hfsplus: fix UAF issue in hfsplus_put_super
Date:   Fri, 10 Mar 2023 14:38:05 +0100
Message-Id: <20230310133714.697522207@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit 07db5e247ab5858439b14dd7cc1fe538b9efcf32 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfsplus/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -294,11 +294,11 @@ static void hfsplus_put_super(struct sup
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


