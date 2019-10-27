Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16251E6779
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbfJ0VVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731895AbfJ0VVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:16 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6314121848;
        Sun, 27 Oct 2019 21:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211275;
        bh=xHR9OMdzYSwoecyvK/JKv1Hak2Yx3n4gMedLK0dao54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qW6gfRntlQ7BDX+xaroiPjATgW7Vartf5WwK8llpihySJS0xE4ELZtXLs3TXfyCZl
         g/pI2A5sJVYwu+kCDWoiOwJ54oEK9rRj4zBGN7CA9XxD3ekZSHvgX4UGOR/2jvAhzt
         FGcKL+QCMEzpOphXvrFEElkLUCCBMZ06e9fBsdrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 095/197] io_uring: Fix corrupted user_data
Date:   Sun, 27 Oct 2019 22:00:13 +0100
Message-Id: <20191027203356.899292969@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 84d55dc5b9e57b513a702fbc358e1b5489651590 upstream.

There is a bug, where failed linked requests are returned not with
specified @user_data, but with garbage from a kernel stack.

The reason is that io_fail_links() uses req->user_data, which is
uninitialised when called from io_queue_sqe() on fail path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2157,6 +2157,8 @@ err:
 		return;
 	}
 
+	req->user_data = s->sqe->user_data;
+
 	/*
 	 * If we already have a head request, queue this one for async
 	 * submittal once the head completes. If we don't have a head but


