Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0568D22673F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732900AbgGTQKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387607AbgGTQKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 162AD2064B;
        Mon, 20 Jul 2020 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261400;
        bh=xl9nwhS+TDJzVbY2Eaky79FtTQ1uMPn+x8ZkN+mNhXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJRi4CvBtonEK/49ce5E3EPfLP31W0vfV3n2klJamgVgrcIwUDNfRWeLlGydbpQ7n
         uxV7I+KIVRj4dfmfgMsH0n/KQEZX1yKFW7z/HO3eXONKjKKGIQCx408D3yj0trBJOU
         Fi5x3U0jn3LNSbaanANgN5uaYYEt2lENfqN24qLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 075/244] io_uring: fix recvmsg memory leak with buffer selection
Date:   Mon, 20 Jul 2020 17:35:46 +0200
Message-Id: <20200720152829.407965865@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 681fda8d27a66f7e65ff7f2d200d7635e64a8d05 upstream.

io_recvmsg() doesn't free memory allocated for struct io_buffer. This can
causes a leak when used with automatic buffer selection.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3884,10 +3884,16 @@ static int io_recvmsg(struct io_kiocb *r
 
 		ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.msg,
 						kmsg->uaddr, flags);
-		if (force_nonblock && ret == -EAGAIN)
-			return io_setup_async_msg(req, kmsg);
+		if (force_nonblock && ret == -EAGAIN) {
+			ret = io_setup_async_msg(req, kmsg);
+			if (ret != -EAGAIN)
+				kfree(kbuf);
+			return ret;
+		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (kbuf)
+			kfree(kbuf);
 	}
 
 	if (kmsg && kmsg->iov != kmsg->fast_iov)


