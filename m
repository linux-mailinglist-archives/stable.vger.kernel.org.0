Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581B755DE09
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbiF0Lua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238557AbiF0Lsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE1ACCC;
        Mon, 27 Jun 2022 04:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C2EF611AE;
        Mon, 27 Jun 2022 11:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D5FC3411D;
        Mon, 27 Jun 2022 11:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330135;
        bh=A4HDaICn0uCDyQrSgGRNZUuO67+2AgCvrl7vWIUKR1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsklPgKx8n5DzZvj3kYgo0/5KRxe8/J2c+Vo03jKihZdifO10j/kmbYzwEA6zuDZa
         muDwSXz4vBJwavqJQGS7UfkuM6e0sQZn5NVhzR4wGuQfWWZW7XsfobWauEtLl9KJwx
         QqCOEWHD2c0/HaspoDKGmFQBf6FRbaTXI1M/3LPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 089/181] io_uring: fail links when poll fails
Date:   Mon, 27 Jun 2022 13:21:02 +0200
Message-Id: <20220627111947.141035190@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit c487a5ad48831afa6784b368ec40d0ee50f2fe1b ]

Don't forget to cancel all linked requests of poll request when
__io_arm_poll_handler() failed.

Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a78aad962460f9fdfe4aa4c0b62425c88f9415bc.1655852245.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68aab48838e4..ca9ed3d899e6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6399,6 +6399,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	ipt.pt._qproc = io_poll_queue_proc;
 
 	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
+	if (!ret && ipt.error)
+		req_set_fail(req);
 	ret = ret ?: ipt.error;
 	if (ret)
 		__io_req_complete(req, issue_flags, ret, 0);
-- 
2.35.1



