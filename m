Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75819492AE
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFQVWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729168AbfFQVWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:22:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D0D52063F;
        Mon, 17 Jun 2019 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806559;
        bh=4HBY7V9Q6baNtwiAz2Ub7+lfEj5/tmjfFc8zZ7NgEpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q26+4LFouvXUlHKni50u1gI0RyO3NVp6WL/ywlmC+YWoqESUYC0AOAbC0AXhpJW0g
         xDyNZnXT67l2CjZZkcB6qKelzfNto24EYPlDkTXpqQShO+yLExrnAg2us2W2uZUJcZ
         FWnPCsHFpQ46W4p927qsZSyAQ9T2AAxGnqVLLVFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 049/115] bpf: sockmap, only stop/flush strp if it was enabled at some point
Date:   Mon, 17 Jun 2019 23:09:09 +0200
Message-Id: <20190617210802.979202296@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 014894360ec95abe868e94416b3dd6569f6e2c0c ]

If we try to call strp_done on a parser that has never been
initialized, because the sockmap user is only using TX side for
example we get the following error.

  [  883.422081] WARNING: CPU: 1 PID: 208 at kernel/workqueue.c:3030 __flush_work+0x1ca/0x1e0
  ...
  [  883.422095] Workqueue: events sk_psock_destroy_deferred
  [  883.422097] RIP: 0010:__flush_work+0x1ca/0x1e0

This had been wrapped in a 'if (psock->parser.enabled)' logic which
was broken because the strp_done() was never actually being called
because we do a strp_stop() earlier in the tear down logic will
set parser.enabled to false. This could result in a use after free
if work was still in the queue and was resolved by the patch here,
1d79895aef18f ("sk_msg: Always cancel strp work before freeing the
psock"). However, calling strp_stop(), done by the patch marked in
the fixes tag, only is useful if we never initialized a strp parser
program and never initialized the strp to start with. Because if
we had initialized a stream parser strp_stop() would have been called
by sk_psock_drop() earlier in the tear down process.  By forcing the
strp to stop we get past the WARNING in strp_done that checks
the stopped flag but calling cancel_work_sync on work that has never
been initialized is also wrong and generates the warning above.

To fix check if the parser program exists. If the program exists
then the strp work has been initialized and must be sync'd and
cancelled before free'ing any structures. If no program exists we
never initialized the stream parser in the first place so skip the
sync/cancel logic implemented by strp_done.

Finally, remove the strp_done its not needed and in the case where we
are using the stream parser has already been called.

Fixes: e8e3437762ad9 ("bpf: Stop the psock parser before canceling its work")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cc94d921476c..49d1efa329d7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -554,8 +554,10 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 	struct sk_psock *psock = container_of(gc, struct sk_psock, gc);
 
 	/* No sk_callback_lock since already detached. */
-	strp_stop(&psock->parser.strp);
-	strp_done(&psock->parser.strp);
+
+	/* Parser has been stopped */
+	if (psock->progs.skb_parser)
+		strp_done(&psock->parser.strp);
 
 	cancel_work_sync(&psock->work);
 
-- 
2.20.1



