Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C42409336
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245118AbhIMOTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244635AbhIMORN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C365D61B20;
        Mon, 13 Sep 2021 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540706;
        bh=ws5SJ3anQ+TeFQPoYg7MBVQZsaB4l3rY9Sgfs8htfBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxJuVO3MEv/F9UIofQ8ZZtxEYTGAcVkmbqoL/fOnCq6JjyD9z2Yb7/QolUck7fzro
         rAf3mDi7k5vgIlulicOlP67XffiKTSY7/qDXA/4F+QjWiVvBkK8jq1hAq7TPHZiA7J
         guwdVB5JVnEobdwXB6/w17r1Bhr59Qe+3EjIb+Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 270/300] io_uring: IORING_OP_WRITE needs hash_reg_file set
Date:   Mon, 13 Sep 2021 15:15:31 +0200
Message-Id: <20210913131118.461240893@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
@@ -990,6 +990,7 @@ static const struct io_op_def io_op_defs
 	},
 	[IORING_OP_WRITE] = {
 		.needs_file		= 1,
+		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.plug			= 1,


