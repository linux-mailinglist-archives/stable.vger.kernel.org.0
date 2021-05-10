Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D92378919
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhEJLZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238020AbhEJLQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F956134F;
        Mon, 10 May 2021 11:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645125;
        bh=xJpKT9jbw9nlEjm3sZDy1uV1JBWCXPSZ6iR1738HbsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=081ywrFE/NvF7RsiM5MQZMdyyyFIFFk5wJjLQrRHI9Rf7w9cQoAInW25rukrmn+5+
         f7Ek4N0qGrPii7GuRIHK9U3yZq/QHchzv0cE9MojqNN6knAb0oket1lpUJa77rAxuD
         HRKVGcHUehNuHhrmlvnvbN/5JT3pt+v/j7I4Burs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com,
        Palash Oswal <hello@oswalpalash.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 362/384] io_uring: Check current->io_uring in io_uring_cancel_sqpoll
Date:   Mon, 10 May 2021 12:22:31 +0200
Message-Id: <20210510102026.695307574@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palash Oswal <hello@oswalpalash.com>

commit 6d042ffb598ed83e7d5623cc961d249def5b9829 upstream.

syzkaller identified KASAN: null-ptr-deref Write in
io_uring_cancel_sqpoll.

io_uring_cancel_sqpoll is called by io_sq_thread before calling
io_uring_alloc_task_context. This leads to current->io_uring being NULL.
io_uring_cancel_sqpoll should not have to deal with threads where
current->io_uring is NULL.

In order to cast a wider safety net, perform input sanitisation directly
in io_uring_cancel_sqpoll and return for NULL value of current->io_uring.
This is safe since if current->io_uring isn't set, then there's no way
for the task to have submitted any requests.

Reported-by: syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Palash Oswal <hello@oswalpalash.com>
Link: https://lore.kernel.org/r/20210427125148.21816-1-hello@oswalpalash.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9005,6 +9005,8 @@ static void io_uring_cancel_sqpoll(struc
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
+	if (!current->io_uring)
+		return;
 	WARN_ON_ONCE(!sqd || sqd->thread != current);
 
 	atomic_inc(&tctx->in_idle);


