Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905F660B2D3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiJXQvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiJXQuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:50:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BF64449A;
        Mon, 24 Oct 2022 08:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01797B811BC;
        Mon, 24 Oct 2022 12:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F0CC433D6;
        Mon, 24 Oct 2022 12:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613195;
        bh=V4IA2J+RiUYh6Wz5OBXXBXbyZirdIwQ3guXguybdpdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqb+dGyy1wuQ1OY3qZrJ+nN0gfNGffFgeh979bpNWJ3q3jZxVJlTpvDzYVNIEO4c1
         y0O7xBkoaSNErdqQlrRzS+UTS0mmc/eQrLSGUrb6AAt5vJJhu8iKpOFYW/rY4vhSSD
         LS4+xNOxMRL962QHaqYHyCL7AB/HU9GxP695uYUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jinke Han <hanjinke.666@bytedance.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 044/255] ext4: place buffer head allocation before handle start
Date:   Mon, 24 Oct 2022 13:29:14 +0200
Message-Id: <20221024113003.892320358@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinke Han <hanjinke.666@bytedance.com>

commit d1052d236eddf6aa851434db1897b942e8db9921 upstream.

In our product environment, we encounter some jbd hung waiting handles to
stop while several writters were doing memory reclaim for buffer head
allocation in delay alloc write path. Ext4 do buffer head allocation with
holding transaction handle which may be blocked too long if the reclaim
works not so smooth. According to our bcc trace, the reclaim time in
buffer head allocation can reach 258s and the jbd transaction commit also
take almost the same time meanwhile. Except for these extreme cases,
we often see several seconds delays for cgroup memory reclaim on our
servers. This is more likely to happen considering docker environment.

One thing to note, the allocation of buffer heads is as often as page
allocation or more often when blocksize less than page size. Just like
page cache allocation, we should also place the buffer head allocation
before startting the handle.

Cc: stable@kernel.org
Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
Link: https://lore.kernel.org/r/20220903012429.22555-1-hanjinke.666@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1317,6 +1317,13 @@ retry_grab:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
+	/*
+	 * The same as page allocation, we prealloc buffer heads before
+	 * starting the handle.
+	 */
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, inode->i_sb->s_blocksize, 0);
+
 	unlock_page(page);
 
 retry_journal:


