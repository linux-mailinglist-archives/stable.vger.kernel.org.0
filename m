Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9C260AA56
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiJXNcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbiJXNay (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:30:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F75AD9A7;
        Mon, 24 Oct 2022 05:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED0B612DA;
        Mon, 24 Oct 2022 12:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9E4C433D6;
        Mon, 24 Oct 2022 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614806;
        bh=7U0mQ0pDfxaJ2+wyh7qsALzju49NDwjTNZHMSl8ISxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LuJtJTfXdnGJ3ug6wKHUfFVnqzoIQSAAN+49iZGStOlpimpgQQLCOYn1MQs/trbl6
         t59nJxQjaaELoDZznJKPLVIULrTtJDv7YeSVaNoF9049Zw4sOqeFY+h7Of/PlNcPOG
         Fp6+lPif/5yiDIKjE6XwKTgOkRaZFbYC8D4gjvOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 011/530] io_uring/net: dont update msg_name if not provided
Date:   Mon, 24 Oct 2022 13:25:55 +0200
Message-Id: <20221024113045.517604613@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 6f10ae8a155446248055c7ddd480ef40139af788 upstream.

io_sendmsg_copy_hdr() may clear msg->msg_name if the userspace didn't
provide it, we should retain NULL in this case.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/97d49f61b5ec76d0900df658cfde3aa59ff22121.1664486545.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4762,7 +4762,8 @@ static int io_setup_async_msg(struct io_
 	async_msg = req->async_data;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
-	async_msg->msg.msg_name = &async_msg->addr;
+	if (async_msg->msg.msg_name)
+		async_msg->msg.msg_name = &async_msg->addr;
 	/* if were using fast_iov, set it to the new one */
 	if (!async_msg->free_iov)
 		async_msg->msg.msg_iter.iov = async_msg->fast_iov;


