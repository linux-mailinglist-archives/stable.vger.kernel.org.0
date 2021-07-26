Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364EC3D624E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhGZPf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237721AbhGZPeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A19FE60C41;
        Mon, 26 Jul 2021 16:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316113;
        bh=bWNOLjCng2Wt19fispDzlz5zSpxCsVz2gM94InI66xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0wITVofezQTMqjvN5s58w7d3302l0pd29vJ831zeOBk0W+2Apw2PbQrIVWK/bdQt
         hicwGE7UEL1T/z7dXObsXiTEExzIBdpYp3AMhOUrmfceAYtjLfN00jqAIniF1Du8/F
         crVOUDPGuWkt78N34duZ+A5b79Ebc+GTgJAbv/oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 194/223] io_uring: fix early fdput() of file
Date:   Mon, 26 Jul 2021 17:39:46 +0200
Message-Id: <20210726153852.535858295@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 0cc936f74bcacb039b7533aeac0a887dfc896bf6 upstream.

A previous commit shuffled some code around, and inadvertently used
struct file after fdput() had been called on it. As we can't touch
the file post fdput() dropping our reference, move the fdput() to
after that has been done.

Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/io-uring/YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk/
Fixes: f2a48dd09b8e ("io_uring: refactor io_sq_offload_create()")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7953,9 +7953,11 @@ static int io_sq_offload_create(struct i
 		f = fdget(p->wq_fd);
 		if (!f.file)
 			return -ENXIO;
-		fdput(f);
-		if (f.file->f_op != &io_uring_fops)
+		if (f.file->f_op != &io_uring_fops) {
+			fdput(f);
 			return -EINVAL;
+		}
+		fdput(f);
 	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct task_struct *tsk;


