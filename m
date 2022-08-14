Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501D7591F85
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 12:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiHNKVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 06:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiHNKV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 06:21:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191BB22BFA
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 03:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA46B61008
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 10:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AE5C433C1;
        Sun, 14 Aug 2022 10:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660472488;
        bh=L84ND0KH+temk1yfzYLPZqd2I1VGI6CmbUFwfBaz1Vk=;
        h=Subject:To:Cc:From:Date:From;
        b=0pIZz+vqfhYwYBP/xuIT4jq8qtVGLOYF1gYsKlrvwcXEXa9rLkYOxnDP2zhQf7AP0
         4viHHy/bHbT3h01xQ5QtsoEBs8FpqYa5Y0VHwGeg5LlCp6HPfksBmlBxf+FMzVXZ1Y
         MEDgzBasqZ+y5Q80u1GxS4ChCSpHYuR8KuN4nH1g=
Subject: FAILED: patch "[PATCH] io_uring: mem-account pbuf buckets" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Aug 2022 12:21:15 +0200
Message-ID: <1660472475179231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cc18cc5e82033d406f54144ad6f8092206004684 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 4 Aug 2022 15:13:46 +0100
Subject: [PATCH] io_uring: mem-account pbuf buckets

Potentially, someone may create as many pbuf bucket as there are indexes
in an xarray without any other restrictions bounding our memory usage,
put memory needed for the buckets under memory accounting.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d34c452e45793e978d26e2606211ec9070d329ea.1659622312.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index e538fa7cb727..a73f40a4cfe6 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -436,7 +436,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
-		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 		if (!bl) {
 			ret = -ENOMEM;
 			goto err;

