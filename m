Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B4B6B4230
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCJOAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjCJOAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:00:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A7B112A7B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:00:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E09B822BD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F2DC4339C;
        Fri, 10 Mar 2023 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456828;
        bh=hcByI9mFwHsH45SjqbYtjaeavj496MDu6pUdBBiR7N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z096UqGc0g9SDC2sVHnxGtpJRhxurDfe0FchGcWajSmta+RKgPVlT4qhnjo1oMI50
         NK6wlLvkKhM7Uf6Y0qhDWb5IN1895kjWVGH43a0wv6+oLA3ndWU8ju3DtC62eXzlED
         1TH3MokPu1vjnasVM9ZQyESM2D5rvzAT3uhIjYuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wojciech Lukowicz <wlukowicz01@gmail.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 111/211] io_uring: fix size calculation when registering buf ring
Date:   Fri, 10 Mar 2023 14:38:11 +0100
Message-Id: <20230310133722.127326326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wojciech Lukowicz <wlukowicz01@gmail.com>

[ Upstream commit 48ba08374e779421ca34bd14b4834aae19fc3e6a ]

Using struct_size() to calculate the size of io_uring_buf_ring will sum
the size of the struct and of the bufs array. However, the struct's fields
are overlaid with the array making the calculated size larger than it
should be.

When registering a ring with N * PAGE_SIZE / sizeof(struct io_uring_buf)
entries, i.e. with fully filled pages, the calculated size will span one
more page than it should and io_uring will try to pin the following page.
Depending on how the application allocated the ring, it might succeed
using an unrelated page or fail returning EFAULT.

The size of the ring should be the product of ring_entries and the size
of io_uring_buf, i.e. the size of the bufs array only.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20230218184141.70891-1-wlukowicz01@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 4a6401080c1f8..3002dc8271959 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -505,7 +505,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	pages = io_pin_pages(reg.ring_addr,
-			     struct_size(br, bufs, reg.ring_entries),
+			     flex_array_size(br, bufs, reg.ring_entries),
 			     &nr_pages);
 	if (IS_ERR(pages)) {
 		kfree(free_bl);
-- 
2.39.2



