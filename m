Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE6040900A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbhIMNtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243763AbhIMNqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8ACF61106;
        Mon, 13 Sep 2021 13:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539931;
        bh=yBc1wclPR/UdRH6JD6duKhVPAwdbfGo3C9tGUoOn6h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oo6qMn8+M2OqTp4yGctPsap0Tkqgbs83GuGjKeET+T0WrpcrasMemPsGdZu3jukIh
         CaVl693EC8gj+tTE4RBpgHnHAU9MT33zrn2mw+tBuSBUhZRUOQy8NUAlgX8L8W36DG
         h3CVb9XfFHDkk4sbqQpbr7IaAcyN7ipQ7Zc62X1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 219/236] io_uring: IORING_OP_WRITE needs hash_reg_file set
Date:   Mon, 13 Sep 2021 15:15:24 +0200
Message-Id: <20210913131107.813773529@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 7b3188e7ed54102a5dcc73d07727f41fb528f7c8 upstream.

During some testing, it became evident that using IORING_OP_WRITE doesn't
hash buffered writes like the other writes commands do. That's simply
an oversight, and can cause performance regressions when doing buffered
writes with this command.

Correct that and add the flag, so that buffered writes are correctly
hashed when using the non-iovec based write command.

Cc: stable@vger.kernel.org
Fixes: 3a6820f2bb8a ("io_uring: add non-vectored read/write commands")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -889,6 +889,7 @@ static const struct io_op_def io_op_defs
 	},
 	[IORING_OP_WRITE] = {
 		.needs_file		= 1,
+		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.async_size		= sizeof(struct io_async_rw),


