Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95914582CB6
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240364AbiG0Qtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbiG0Qsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5162561131;
        Wed, 27 Jul 2022 09:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6710B821D0;
        Wed, 27 Jul 2022 16:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBECC433D6;
        Wed, 27 Jul 2022 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939550;
        bh=0u1Q4T/coKPKlkRYB8LRz3wU3+rbSCklXjpL4Hkyeds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ys3SfmOY2ZvQtjqUamZWdKV5Ai9f1+MyiFzgLiLCVQgg+1LSk9LoQIr8HkEqsmZaQ
         5mbzv3Wt/0Sf+pjZKxgmQxJ36doXCuTfRH9i2dI1UV1G4kt/MFlB86O9SCt7RRB35e
         awjfyazj1clVvp84IIPHLaRUD3Q6nRmF8fjQzODA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 5.10 005/105] io_uring: Use original task for req identity in io_identity_cow()
Date:   Wed, 27 Jul 2022 18:09:51 +0200
Message-Id: <20220727161012.279068616@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee@kernel.org>

This issue is conceptually identical to the one fixed in 29f077d07051
("io_uring: always use original task when preparing req identity"), so
rather than reinvent the wheel, I'm shamelessly quoting the commit
message from that patch - thanks Jens:

 "If the ring is setup with IORING_SETUP_IOPOLL and we have more than
  one task doing submissions on a ring, we can up in a situation where
  we assign the context from the current task rather than the request
  originator.

  Always use req->task rather than assume it's the same as current.

  No upstream patch exists for this issue, as only older kernels with
  the non-native workers have this problem."

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Fixes: 5c3462cfd123b ("io_uring: store io_identity in io_uring_task")
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1325,7 +1325,7 @@ static void io_req_clean_work(struct io_
  */
 static bool io_identity_cow(struct io_kiocb *req)
 {
-	struct io_uring_task *tctx = current->io_uring;
+	struct io_uring_task *tctx = req->task->io_uring;
 	const struct cred *creds = NULL;
 	struct io_identity *id;
 


