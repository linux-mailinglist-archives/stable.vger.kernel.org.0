Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163E45798CA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiGSLxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiGSLxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D6F402F3;
        Tue, 19 Jul 2022 04:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3174560B27;
        Tue, 19 Jul 2022 11:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85681C341C6;
        Tue, 19 Jul 2022 11:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658231583;
        bh=kgxmXrF1EeEP15TY5TpVytt+GVBw5XRupIrwJ+y8TWE=;
        h=From:To:Cc:Subject:Date:From;
        b=CYO9alOSQTJsM1yzJIbAs2TB/okxwcylaGsM86F5AE6Hp6Bx0ASD9JrX3M/KOuMwf
         2+UizzfTgkkEC1QqcNLPPVqWubR3AGQpNeiWARogh5ZqGTj266AF7Zb4zs7EzcxEK5
         vBnraA7ZUMyyK0KS6GnmDUNUjvh/h2+ZF3cibztE+vVsJ5QcjuoGzHA4gQRbogVwbO
         IG080ilbOm2dCTC2X+8TJc2Dj8bLZaiYGzEQ7epoVrLogeCrDD+tnIqgXnkX8n0Nzo
         JTqLqmEfVO3inMZHi0zqyzd0z+TK0D9a+l1Be5Y7r1+jfv/hn+P5nfvTsGsV1w5WMU
         C4fRnudEiqzVg==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v5.10 1/1] io_uring: Use original task for req identity in io_identity_cow()
Date:   Tue, 19 Jul 2022 12:52:51 +0100
Message-Id: <20220719115251.441526-1-lee@kernel.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 023c3eb34dcca..a952288b2ab8e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1325,7 +1325,7 @@ static void io_req_clean_work(struct io_kiocb *req)
  */
 static bool io_identity_cow(struct io_kiocb *req)
 {
-	struct io_uring_task *tctx = current->io_uring;
+	struct io_uring_task *tctx = req->task->io_uring;
 	const struct cred *creds = NULL;
 	struct io_identity *id;
 
-- 
2.37.0.170.g444d1eabd0-goog

