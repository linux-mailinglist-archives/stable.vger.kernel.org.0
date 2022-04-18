Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C705052AB
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiDRMuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbiDRMte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:49:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87C42B197;
        Mon, 18 Apr 2022 05:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FE8EB80EDC;
        Mon, 18 Apr 2022 12:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71023C385BA;
        Mon, 18 Apr 2022 12:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285220;
        bh=9KPFsXyNlSibgf458VjxpKttCCI7QLhJZMPkhmVqe00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZz6Fvko+o9a8I+03xylR0WlVNDrTry7JcQJlzv42Zy4S8P22OCR2hDMUXXhXO/gK
         Xn08JGtx4geIGAmX1msS6cqn69rWoWTQquds2LWGPbNWcAR1J0+JmX/c42sJ23j3Rx
         WT097jDuzrrpEwNoViBbaaNIz2SHZq3MyhEq16zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/189] io_uring: zero tag on rsrc removal
Date:   Mon, 18 Apr 2022 14:12:41 +0200
Message-Id: <20220418121205.527241427@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 8f0a24801bb44aa58496945aabb904c729176772 ]

Automatically default rsrc tag in io_queue_rsrc_removal(), it's safer
than leaving it there and relying on the rest of the code to behave and
not use it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1cf262a50df17478ea25b22494dcc19f3a80301f.1649336342.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cc0a07a9fe9c..ca207e9a87cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8413,13 +8413,15 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 				 struct io_rsrc_node *node, void *rsrc)
 {
+	u64 *tag_slot = io_get_tag_slot(data, idx);
 	struct io_rsrc_put *prsrc;
 
 	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
 	if (!prsrc)
 		return -ENOMEM;
 
-	prsrc->tag = *io_get_tag_slot(data, idx);
+	prsrc->tag = *tag_slot;
+	*tag_slot = 0;
 	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
-- 
2.35.1



