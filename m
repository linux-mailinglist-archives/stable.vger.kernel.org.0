Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937C3796DD
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403879AbfG2T4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404315AbfG2T4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:56:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27F321655;
        Mon, 29 Jul 2019 19:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430166;
        bh=O3KG9Nz1k06UKZGcnzV3zAkp4uWNexemALwHWlzerqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPK2Rn1JzBsf9EJUm8zKXmkEgqPOhRMCOaZeBhrW5V9Vz3p9OvZSuUm166A6n39vP
         VO1QMrOW0sni4ELjQFK29wUkX0Dheb99nLPvwDOvBYQ3ei7l1ptW54f32wADfTT5QO
         NKrIqX8UdlvNjsNzSyMrovBF5rxIke248Gn8abE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 201/215] io_uring: fix the sequence comparison in io_sequence_defer
Date:   Mon, 29 Jul 2019 21:23:17 +0200
Message-Id: <20190729190814.779830632@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

commit dbd0f6d6c2a11eb9c31ca9cd454f95bb5713e92e upstream.

sq->cached_sq_head and cq->cached_cq_tail are both unsigned int. If
cached_sq_head overflows before cached_cq_tail, then we may miss a
barrier req. As cached_cq_tail always follows cached_sq_head, the NQ
should be enough.

Cc: stable@vger.kernel.org
Fixes: de0617e46717 ("io_uring: add support for marking commands as draining")
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -425,7 +425,7 @@ static inline bool io_sequence_defer(str
 	if ((req->flags & (REQ_F_IO_DRAIN|REQ_F_IO_DRAINED)) != REQ_F_IO_DRAIN)
 		return false;
 
-	return req->sequence > ctx->cached_cq_tail + ctx->sq_ring->dropped;
+	return req->sequence != ctx->cached_cq_tail + ctx->sq_ring->dropped;
 }
 
 static struct io_kiocb *io_get_deferred_req(struct io_ring_ctx *ctx)


