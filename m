Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1A1603BBA
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJSIjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJSIig (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2D781104;
        Wed, 19 Oct 2022 01:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67A9B617DF;
        Wed, 19 Oct 2022 08:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC1CC4314F;
        Wed, 19 Oct 2022 08:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168669;
        bh=TCUsX9pBBpaSnQMGS5JBDj3c0U2M6hs+3F/Ihdd1P4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Md3SfXS2nGKduRpJFAZGWOo+oGOOPoDOi+4MQDBJF7E0sBw/R/M5PwsNCG49kIa4V
         QOKqp39kzPuFk2o6qx+2cbCCKjH9cWQTE4bF2KB8DiQz6payDjU2ofpLx/NLm6Z7mG
         2vFx8XNp+HUR7vtuhUVDDP4Ygj1BRLP1zcTErtTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 016/862] io_uring/net: dont update msg_name if not provided
Date:   Wed, 19 Oct 2022 10:21:43 +0200
Message-Id: <20221019083250.727057238@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 io_uring/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -163,7 +163,8 @@ static int io_setup_async_msg(struct io_
 	}
 	req->flags |= REQ_F_NEED_CLEANUP;
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
-	async_msg->msg.msg_name = &async_msg->addr;
+	if (async_msg->msg.msg_name)
+		async_msg->msg.msg_name = &async_msg->addr;
 	/* if were using fast_iov, set it to the new one */
 	if (!kmsg->free_iov) {
 		size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;


