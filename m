Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8535E4FCA0D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243792AbiDLAut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243802AbiDLAuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:50:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D092FFEA;
        Mon, 11 Apr 2022 17:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAEACB8186F;
        Tue, 12 Apr 2022 00:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF65CC385AA;
        Tue, 12 Apr 2022 00:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724404;
        bh=21ORkHa4XkYsDGywZhe+134XzrVwi/UAbC8QYcURzzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7kY2+de17exRX5qmw+g3GPz1BYLHn3tj8J0k2E4Dyr7mIFzLjMJ/WmI7DvtM6f4h
         XQksBak3eXqBLVQaqkhiFA+T5v589D1xQYug9asImCL2py2dN9p6usxnEuroT2YKof
         +SL2OvgPlpsK0pt4nwk6vH+Z7d6ZVAFJAxEMUP9lAJEkddyGDwLAlrXYpVFm53sKtA
         /j5zIRs903/qX/nNra3zuRTAw7ZoQ+UpfsTIn0RacHrWPGtgSrBnF10F0xt5dO+USz
         pEwb77XwJuFv9sEVO+CmfSK2B/OhuqBUC3XpNx/M/lVoqHelobPndHRRxi01+C1FxT
         5spnHZGc4AqtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 46/49] io_uring: zero tag on rsrc removal
Date:   Mon, 11 Apr 2022 20:44:04 -0400
Message-Id: <20220412004411.349427-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5e6788ab188f..d203bbb7b965 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8529,13 +8529,15 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
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

