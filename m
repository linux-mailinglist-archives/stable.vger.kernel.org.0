Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8A86B432A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjCJOLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbjCJOKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:10:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40992B9521
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D007561380
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C7DC433D2;
        Fri, 10 Mar 2023 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457424;
        bh=IXydKDOJqiD98Qbe5+iE9IlaED86BSTBSXGKIwltCXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGR5l9JDEwbZbiJ8r5dCu8rBoDx95UJKJO9IJRAeJaqd4gJyrvHsX4v3zA3MW2Ft1
         3jvL0eXPpRG796K5NmiaBJxoedqmr4FGTNDQuYQKLqlSbkHqM5uzYp25KbaynUBi64
         jLbGIwmeupCZiKCZ5fcR+OTUrrk+iGbywjc7YNhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wojciech Lukowicz <wlukowicz01@gmail.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/200] io_uring: fix size calculation when registering buf ring
Date:   Fri, 10 Mar 2023 14:38:29 +0100
Message-Id: <20230310133720.237012412@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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
index e2c46889d5fab..746b137b96e9b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -509,7 +509,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	pages = io_pin_pages(reg.ring_addr,
-			     struct_size(br, bufs, reg.ring_entries),
+			     flex_array_size(br, bufs, reg.ring_entries),
 			     &nr_pages);
 	if (IS_ERR(pages)) {
 		kfree(free_bl);
-- 
2.39.2



