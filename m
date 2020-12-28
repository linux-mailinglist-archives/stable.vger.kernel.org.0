Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A022E3FC9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503169AbgL1OY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503164AbgL1OY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EC2D221F0;
        Mon, 28 Dec 2020 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165483;
        bh=0O7lhUQg3Vk3mTZyYdpKNC64PDrNQGDsmxZneg17+/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKlf+EuUOUdDdvHTt/iEzpmOPCMc/cQLtBtKV6FDJI6ywpN2qzXI+kfl47k6K6fnI
         Ad+Uhgzv2ZGJm8H9rT4KJyRxxMqzNssKibe9NEchQ+RUl1jxL3+rlzKlMips5pAGKU
         gxGDoCRFNPCkxS5XzyG+oh2z3PuWfdhcdONJeqiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 517/717] io_uring: fix 0-iov read buffer select
Date:   Mon, 28 Dec 2020 13:48:35 +0100
Message-Id: <20201228125045.724452992@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit dd20166236953c8cd14f4c668bf972af32f0c6be upstream.

Doing vectored buf-select read with 0 iovec passed is meaningless and
utterly broken, forbid it.

Cc: <stable@vger.kernel.org> # 5.7+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3048,9 +3048,7 @@ static ssize_t io_iov_buffer_select(stru
 		iov[0].iov_len = kbuf->len;
 		return 0;
 	}
-	if (!req->rw.len)
-		return 0;
-	else if (req->rw.len > 1)
+	if (req->rw.len != 1)
 		return -EINVAL;
 
 #ifdef CONFIG_COMPAT


