Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB0676F1E
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjAVPSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjAVPR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:17:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1373B6194
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:17:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A743060BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4EEC433EF;
        Sun, 22 Jan 2023 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400671;
        bh=FOFP9nrlG86RrL5GkBjkrl0jdbHYhWrjUxaYw/cbLHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+YW+v+LmZGu1Em2BvSakqfjgIZMLz57zHCu1MWy49arxpicv7F6o2xQ3Bqv/L/kZ
         h+sKbzp6wJpGnZ+PpW1W6dKvn67Fw4rE7oxKNl6dYWcg7YYs2e0laTOTHrv4moK4e0
         ZgWGrJZIRXkHGyg5HpzX1GGfPSy+mpmagFjGzPeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/117] io_uring: allow re-poll if we made progress
Date:   Sun, 22 Jan 2023 16:03:45 +0100
Message-Id: <20230122150234.187195033@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 10c873334febaeea9aa0c25c10b5ac0951b77a5f upstream.

We currently check REQ_F_POLLED before arming async poll for a
notification to retry. If it's set, then we don't allow poll and will
punt to io-wq instead. This is done to prevent a situation where a buggy
driver will repeatedly return that there's space/data available yet we
get -EAGAIN.

However, if we already transferred data, then it should be safe to rely
on poll again. Gate the check on whether or not REQ_F_PARTIAL_IO is
also set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3fb76863fed4..997a7264e1d4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5853,7 +5853,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if (req->flags & REQ_F_POLLED)
+	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
@@ -5869,7 +5869,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		mask |= POLLOUT | POLLWRNORM;
 	}
 
-	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+	if (req->flags & REQ_F_POLLED)
+		apoll = req->apoll;
+	else
+		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
-- 
2.39.0



