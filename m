Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EC7551A17
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbiFTNAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244080AbiFTM7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:59:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F147C183A7;
        Mon, 20 Jun 2022 05:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16F0AB811A6;
        Mon, 20 Jun 2022 12:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DC9C3411B;
        Mon, 20 Jun 2022 12:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729769;
        bh=wW0qIChg5DhZAZiynCS13PgfmFZjwtltvi+ebPMRs+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnvP7rEBk53BAVCI/P0Hd3Wr5y/sAeUUFV1ZMfW5DmFYS8oz2Lx9Qkk7LmTn7IAVu
         3QX+INAEORNgN1Jvfojbf3aXZEiTWveGecQtLsLmr5Eq82DM3eFg5izbzawGrWBy8T
         UBFMHKdaJvEmTW3KyPIHDNpv7qLOczKH9u4G0Nz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        van fantasy <g1042620637@gmail.com>
Subject: [PATCH 5.18 067/141] io_uring: fix races with buffer table unregister
Date:   Mon, 20 Jun 2022 14:50:05 +0200
Message-Id: <20220620124731.519623762@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

[ Upstream commit d11d31fc5d8a96f707facee0babdcffaafa38de2 ]

Fixed buffer table quiesce might unlock ->uring_lock, potentially
letting new requests to be submitted, don't allow those requests to
use the table as they will race with unregistration.

Reported-and-tested-by: van fantasy <g1042620637@gmail.com>
Fixes: bd54b6fe3316ec ("io_uring: implement fixed buffers registration similar to fixed files")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0a9f9000fc80..3d123ca028c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9495,12 +9495,19 @@ static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
+	unsigned nr = ctx->nr_user_bufs;
 	int ret;
 
 	if (!ctx->buf_data)
 		return -ENXIO;
 
+	/*
+	 * Quiesce may unlock ->uring_lock, and while it's not held
+	 * prevent new requests using the table.
+	 */
+	ctx->nr_user_bufs = 0;
 	ret = io_rsrc_ref_quiesce(ctx->buf_data, ctx);
+	ctx->nr_user_bufs = nr;
 	if (!ret)
 		__io_sqe_buffers_unregister(ctx);
 	return ret;
-- 
2.35.1



