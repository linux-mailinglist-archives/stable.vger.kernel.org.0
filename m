Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028405519CC
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243464AbiFTNAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243958AbiFTM7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CDB1BE80;
        Mon, 20 Jun 2022 05:56:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D1B561524;
        Mon, 20 Jun 2022 12:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AE8C3411B;
        Mon, 20 Jun 2022 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729766;
        bh=AAKjTYTHTzBZLCi9DHNHmED5xxkxD9PHoX1a1KXhIbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7yxyw7I1PNC6nIuOphPtNgNOEfUva3xeux7QT/TCvc0LVe3Mn9ZD4MCRcmcgPdhf
         1/cU9LFqtRn6HaJsbBvMwA+Oc/bzp6no1pVK8w2sGfYHmEc0ASGV8ez1ANjHQucVP0
         Vu8VRZRsSvCuhN/NkNFe+bBacqaAAPSXC13N2CPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        van fantasy <g1042620637@gmail.com>
Subject: [PATCH 5.18 066/141] io_uring: fix races with file table unregister
Date:   Mon, 20 Jun 2022 14:50:04 +0200
Message-Id: <20220620124731.491373962@linuxfoundation.org>
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
index 3582db014aad..0a9f9000fc80 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8508,11 +8508,19 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
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



