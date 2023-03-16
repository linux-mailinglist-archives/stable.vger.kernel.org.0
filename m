Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E7A6BD867
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 19:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCPS45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 14:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCPS4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 14:56:49 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2CFDC0B9;
        Thu, 16 Mar 2023 11:56:47 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.4])
        by mail.ispras.ru (Postfix) with ESMTPSA id 4D62B40737A3;
        Thu, 16 Mar 2023 18:56:42 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4D62B40737A3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678993002;
        bh=k6HQrhvOxsyxxBqUmbw2LGlZp59STN18eT9Ai2M4YeU=;
        h=From:To:Cc:Subject:Date:From;
        b=KRKSxfRd8jxb3PbTk6gqsj77ftVIB2yIgXh6FOJudeHcsxW/E21YNwPMGLlGl586D
         y1oJ/PRuEFXbYAgeoaAVX3N6djZ5/nuasjxpPGfM+g+K0lGJzQOBE9UbqQpn47ssqD
         l0xl7GLSS+oPYx8mjklaaVEl45XVIW5GeBpgxFWg=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10/5.15] io_uring: avoid null-ptr-deref in io_arm_poll_handler
Date:   Thu, 16 Mar 2023 21:56:16 +0300
Message-Id: <20230316185616.271024-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No upstream commit exists for this commit.

The issue was introduced with backporting upstream commit c16bda37594f
("io_uring/poll: allow some retries for poll triggering spuriously").

Memory allocation can possibly fail causing invalid pointer be
dereferenced just before comparing it to NULL value.

Move the pointer check in proper place (upstream has the similar location
of the check). In case the request has REQ_F_POLLED flag up, apoll can't
be NULL so no need to check there.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 445afda927f4..fd799567fc23 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5792,10 +5792,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		}
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (unlikely(!apoll))
+			return IO_APOLL_ABORTED;
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
-	if (unlikely(!apoll))
-		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
-- 
2.34.1

