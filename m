Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742B459A4A5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350601AbiHSQvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354113AbiHSQtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:49:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1217E20F4B;
        Fri, 19 Aug 2022 09:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EFE561199;
        Fri, 19 Aug 2022 16:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB12C433D6;
        Fri, 19 Aug 2022 16:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925534;
        bh=2odhcsxlfATn5F60Mw01yiIgEalIkAXeZLNlpAr2qGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sz9S2V+WPORhjl2W9BxGj96NpFLsImAoZqEgzdaHm6aNxjzMRYoua9kM7F6GAo/1P
         +I+Pm3W5Z1CHX9wzC4Y5pKx/6r//ldr2RnEwr+bT5Kl7kQPppYnVPAS3oylDkQno3N
         H2DbrjJYCA+JVMOm/LAnQTOcXA+SEiSHtvD9CEmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 522/545] ext4: fix extent status tree race in writeback error recovery path
Date:   Fri, 19 Aug 2022 17:44:52 +0200
Message-Id: <20220819153852.907508416@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Whitney <enwlinux@gmail.com>

commit 7f0d8e1d607c1a4fa9a27362a108921d82230874 upstream.

A race can occur in the unlikely event ext4 is unable to allocate a
physical cluster for a delayed allocation in a bigalloc file system
during writeback.  Failure to allocate a cluster forces error recovery
that includes a call to mpage_release_unused_pages().  That function
removes any corresponding delayed allocated blocks from the extent
status tree.  If a new delayed write is in progress on the same cluster
simultaneously, resulting in the addition of an new extent containing
one or more blocks in that cluster to the extent status tree, delayed
block accounting can be thrown off if that delayed write then encounters
a similar cluster allocation failure during future writeback.

Write lock the i_data_sem in mpage_release_unused_pages() to fix this
problem.  Ext4's block/cluster accounting code for bigalloc relies on
i_data_sem for mutual exclusion, as is found in the delayed write path,
and the locking in mpage_release_unused_pages() is missing.

Cc: stable@kernel.org
Reported-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20220615160530.1928801-1-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1577,7 +1577,14 @@ static void mpage_release_unused_pages(s
 		ext4_lblk_t start, last;
 		start = index << (PAGE_SHIFT - inode->i_blkbits);
 		last = end << (PAGE_SHIFT - inode->i_blkbits);
+
+		/*
+		 * avoid racing with extent status tree scans made by
+		 * ext4_insert_delayed_block()
+		 */
+		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_es_remove_extent(inode, start, last - start + 1);
+		up_write(&EXT4_I(inode)->i_data_sem);
 	}
 
 	pagevec_init(&pvec);


