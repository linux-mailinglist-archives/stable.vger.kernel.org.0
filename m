Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57324FD9D6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbiDLH73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358647AbiDLHmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91C453A4A;
        Tue, 12 Apr 2022 00:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 257CE61708;
        Tue, 12 Apr 2022 07:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D71C385A5;
        Tue, 12 Apr 2022 07:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747918;
        bh=6xwYJlK+nsxFLkpLA0QodmOLGRUu6popvkIzHN2JRYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aIN1pNbKGN63D3YZ/+DJyklV2B+eLjFJACRnT3NYJbmXMCbDTtxHBxmQz6GJUyWT
         i0ELdvX61/MjJirGZeaNhQ8evs31ojRpvor/ZEHks7D3+3oWl3uGfFmXiVewrv4bjE
         uQEM1aYXynr2fb/J44XSFtwPHhbDnpEZjh0xZVDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 254/343] io_uring: dont touch scm_fp_list after queueing skb
Date:   Tue, 12 Apr 2022 08:31:12 +0200
Message-Id: <20220412062958.660802076@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit a07211e3001435fe8591b992464cd8d5e3c98c5a ]

It's safer to not touch scm_fp_list after we queued an skb to which it
was assigned, there might be races lurking if we screw subtle sync
guarantees on the io_uring side.

Fixes: 6b06314c47e14 ("io_uring: add file set registration")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a3e82aececd9..0ee1d8903ffe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8237,8 +8237,12 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 		skb_queue_head(&sk->sk_receive_queue, skb);
 
-		for (i = 0; i < nr_files; i++)
-			fput(fpl->fp[i]);
+		for (i = 0; i < nr; i++) {
+			struct file *file = io_file_from_index(ctx, i + offset);
+
+			if (file)
+				fput(file);
+		}
 	} else {
 		kfree_skb(skb);
 		free_uid(fpl->user);
-- 
2.35.1



