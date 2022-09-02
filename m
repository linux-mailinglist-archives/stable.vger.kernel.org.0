Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746E45AAFC7
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237263AbiIBMoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiIBMnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9124BEA30B;
        Fri,  2 Sep 2022 05:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CF8DB82ACC;
        Fri,  2 Sep 2022 12:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A77CC433D7;
        Fri,  2 Sep 2022 12:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121895;
        bh=Efn+RC4A9xr3g6ZZemO1GHFr28YmcxvuRXOBY+Vj6dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpo0tKUH0yFw1PwpICYAPcPCxQsbCs3xCsYGFF4+JiaHtYTK5jQL2ElAX7oKoxmkM
         ANojuOBZjQaDWn0hwlflKmGlkjSWQ6dcOrYAiuJgIZ4l04ubZZIjAkZYBjSv1M6c+T
         n13Ql8bCX0Cia3gAyWPzSPDnuowsXxD7u7dq8F8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 21/73] io_uring: fail links when poll fails
Date:   Fri,  2 Sep 2022 14:18:45 +0200
Message-Id: <20220902121405.153057380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ upstream commmit c487a5ad48831afa6784b368ec40d0ee50f2fe1b ]

Don't forget to cancel all linked requests of poll request when
__io_arm_poll_handler() failed.

Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a78aad962460f9fdfe4aa4c0b62425c88f9415bc.1655852245.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5844,6 +5844,8 @@ static int io_poll_add(struct io_kiocb *
 	ipt.pt._qproc = io_poll_queue_proc;
 
 	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
+	if (!ret && ipt.error)
+		req_set_fail(req);
 	ret = ret ?: ipt.error;
 	if (ret)
 		__io_req_complete(req, issue_flags, ret, 0);


