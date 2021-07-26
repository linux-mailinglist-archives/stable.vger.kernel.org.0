Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A5F3D624C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbhGZPf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237637AbhGZPen (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B78B6056B;
        Mon, 26 Jul 2021 16:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316110;
        bh=BV2JIX1TXBIW4Hu6V4wKq8hgavAFgPAtQQq/kq6tOiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSxncV7gFxlOHcFAb9XnZLNHjV2YeaRLNjNAe5VyO4v6BZKAKJHYnC9lL3R/+zj0w
         Ab7e9koJ5qYblrLAu1NEHbxzjw+/xjnoJR8GwoZsbvGf6gI49kTjDXnEev1ZkSGzUX
         saZEtsxIoaIlP983r+FglidD5Ej8iL46b9M+8Ei8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        syzbot+ac957324022b7132accf@syzkaller.appspotmail.com
Subject: [PATCH 5.13 193/223] io_uring: remove double poll entry on arm failure
Date:   Mon, 26 Jul 2021 17:39:45 +0200
Message-Id: <20210726153852.507980438@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 46fee9ab02cb24979bbe07631fc3ae95ae08aa3e upstream.

__io_queue_proc() can enqueue both poll entries and still fail
afterwards, so the callers trying to cancel it should also try to remove
the second poll entry (if any).

For example, it may leave the request alive referencing a io_uring
context but not accessible for cancellation:

[  282.599913][ T1620] task:iou-sqp-23145   state:D stack:28720 pid:23155 ppid:  8844 flags:0x00004004
[  282.609927][ T1620] Call Trace:
[  282.613711][ T1620]  __schedule+0x93a/0x26f0
[  282.634647][ T1620]  schedule+0xd3/0x270
[  282.638874][ T1620]  io_uring_cancel_generic+0x54d/0x890
[  282.660346][ T1620]  io_sq_thread+0xaac/0x1250
[  282.696394][ T1620]  ret_from_fork+0x1f/0x30

Cc: stable@vger.kernel.org
Fixes: 18bceab101add ("io_uring: allow POLL_ADD with double poll_wait() users")
Reported-and-tested-by: syzbot+ac957324022b7132accf@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0ec1228fc5eda4cb524eeda857da8efdc43c331c.1626774457.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5121,6 +5121,8 @@ static __poll_t __io_arm_poll_handler(st
 		ipt->error = -EINVAL;
 
 	spin_lock_irq(&ctx->completion_lock);
+	if (ipt->error)
+		io_poll_remove_double(req);
 	if (likely(poll->head)) {
 		spin_lock(&poll->head->lock);
 		if (unlikely(list_empty(&poll->wait.entry))) {


