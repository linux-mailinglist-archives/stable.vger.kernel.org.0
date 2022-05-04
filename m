Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD86B51A824
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355604AbiEDRIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353159AbiEDRFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7235133B;
        Wed,  4 May 2022 09:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C386561896;
        Wed,  4 May 2022 16:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B196C385AF;
        Wed,  4 May 2022 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683254;
        bh=V/5M8e8MGND+F+zgU4fwcSKS4RgrHl+diawDinNCLTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tC4sruaKsbzsrPUaG4cCRAauocgxewfJiCae+3R6tuaO7FIXbSjOFk3Wuoh5HMFFs
         tHzd3M6Xq84WUJcbhlPX6NzIpSElt10BUEJ7E9Rl7xbd3lxaWRX89vp47+QPKySu4B
         tJOnlsDQVpQHK/pB33dI6zULiY6H5lRH3n/RLL/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/177] io_uring: check reserved fields for send/sendmsg
Date:   Wed,  4 May 2022 18:45:04 +0200
Message-Id: <20220504153103.153328353@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 588faa1ea5eecb351100ee5d187b9be99210f70d ]

We should check unused fields for non-zero and -EINVAL if they are set,
making it consistent with other opcodes.

Fixes: 0fa03c624d8f ("io_uring: add support for sendmsg()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1bf1ea2cd8b0..48c9a550e48c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4786,6 +4786,8 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-- 
2.35.1



