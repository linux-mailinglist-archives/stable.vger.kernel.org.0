Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF27B60B98A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiJXUOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiJXUNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:13:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5FA42AF6;
        Mon, 24 Oct 2022 11:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF462CE1727;
        Mon, 24 Oct 2022 12:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD600C433D6;
        Mon, 24 Oct 2022 12:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616138;
        bh=6YnjYT1LkH7bSMNY9wnqskLL2QTliG2IbRnuxYGiFe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfLws0XkBB0CJUPq8pWQTF7BSVjfg6r0jL4IyV8h4n8z+hx4+FboNIil9Vx1yl7Ux
         FStavcwTbFBWAp55QndfY4mjhvreL6pl6dv/DMpifkWealdR3rIQg7E8mIfqBJ8xhP
         vCjlZrZycotQzKxbf4qiL8icI4EIRcZMlD6UN7T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Beld Zhang <beldzhang@gmail.com>
Subject: [PATCH 5.15 515/530] io_uring/rw: fix unexpected link breakage
Date:   Mon, 24 Oct 2022 13:34:19 +0200
Message-Id: <20221024113108.307171154@linuxfoundation.org>
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

[ upstream commit bf68b5b34311ee57ed40749a1257a30b46127556 ]

req->cqe.res is set in io_read() to the amount of bytes left to be done,
which is used to figure out whether to fail a read or not. However,
io_read() may do another without returning, and we stash the previous
value into ->bytes_done but forget to update cqe.res. Then we ask a read
to do strictly less than cqe.res but expect the return to be exactly
cqe.res.

Fix the bug by updating cqe.res for retries.

Cc: stable@vger.kernel.org
Reported-and-Tested-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3a1088440c7be98e5800267af922a67da0ef9f13.1664235732.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3606,6 +3606,7 @@ static int io_read(struct io_kiocb *req,
 			return -EAGAIN;
 		}
 
+		req->result = iov_iter_count(iter);
 		/*
 		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
 		 * we get -EIOCBQUEUED, then we'll get a notification when the


