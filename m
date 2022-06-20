Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF60A551CB1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343592AbiFTNP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345718AbiFTNOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:14:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69CF201A1;
        Mon, 20 Jun 2022 06:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8814C60A52;
        Mon, 20 Jun 2022 13:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E66BC3411B;
        Mon, 20 Jun 2022 13:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730452;
        bh=6fAGBMVAci6ChGWdt3zDZTuNGDC6oQZF0j1O+kb+FLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLnqae1mFvryRqLpxllRPkaCBYjUur++NqiE/YcYs+1XsgLDgS9DjLi1oscMZeTpo
         JjV7SPHcy6rmDhIDuv1Z13FkYP+0UuRZAKufy5kjrXH1riSsdxVycbqqO54Dn1gWH7
         9KbnUXbn1cdJFhB5uT3aAxwErgJXw5phc1RSZzk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        van fantasy <g1042620637@gmail.com>
Subject: [PATCH 5.15 057/106] io_uring: fix races with file table unregister
Date:   Mon, 20 Jun 2022 14:51:16 +0200
Message-Id: <20220620124726.091379885@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
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

[ Upstream commit b0380bf6dad4601d92025841e2b7a135d566c6e3 ]

Fixed file table quiesce might unlock ->uring_lock, potentially letting
new requests to be submitted, don't allow those requests to use the
table as they will race with unregistration.

Reported-and-tested-by: van fantasy <g1042620637@gmail.com>
Fixes: 05f3fb3c53975 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b8e6398d9430..5f111a660fff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7933,11 +7933,19 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
+	unsigned nr = ctx->nr_user_files;
 	int ret;
 
 	if (!ctx->file_data)
 		return -ENXIO;
+
+	/*
+	 * Quiesce may unlock ->uring_lock, and while it's not held
+	 * prevent new requests using the table.
+	 */
+	ctx->nr_user_files = 0;
 	ret = io_rsrc_ref_quiesce(ctx->file_data, ctx);
+	ctx->nr_user_files = nr;
 	if (!ret)
 		__io_sqe_files_unregister(ctx);
 	return ret;
-- 
2.35.1



