Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF2D603C73
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiJSIrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiJSIpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:45:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B0E868B9;
        Wed, 19 Oct 2022 01:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3690617AC;
        Wed, 19 Oct 2022 08:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F63C433D6;
        Wed, 19 Oct 2022 08:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169055;
        bh=VtFKGsLaErRVzOB9Z09DPYXE6t91wddQ7M2ZiRFgHpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d36zqZGDmODF1s5zSqRCAvH+CPB9crylxW+0etX7rV1eDtIBejDmZg4mJvbSDLMJ8
         oDEAM+jvwMNGRX6Fo5BHr4LUR3z0RhFAgBQTWRgvvsqh03/94QZr7VwaVuc9SZdydv
         JSihO+j11E3Af5wWTIiGhm4vL5KSFCG5pIsKwFM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jinke Han <hanjinke.666@bytedance.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 142/862] ext4: place buffer head allocation before handle start
Date:   Wed, 19 Oct 2022 10:23:49 +0200
Message-Id: <20221019083256.258802162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1188,6 +1188,13 @@ retry_grab:
 	page = grab_cache_page_write_begin(mapping, index);
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


