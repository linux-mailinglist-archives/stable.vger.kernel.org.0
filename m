Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A6926191E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbgIHSHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731501AbgIHQLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9C6F246EE;
        Tue,  8 Sep 2020 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579623;
        bh=yak2AVQpBF3q7cNjcP4nggu5l/OGn/Gfsq3p4CB6I/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqUQSK1j+BXDhe6teQ0z5rbp60gQjUzVfP7BR644LuSyyjUV/xh7UxqaiesWWxM+P
         ZVHoEpxvode53Z2r9+eKg9e6mUSuvnp5gGVSZvNnBKt2kelGeQgCc/Rl7wTSLnl56v
         SljReQIcvWvbQ89St1qWT/I00A8CmqVUkt+ao4TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 155/186] io_uring: fix removing the wrong file in __io_sqe_files_update()
Date:   Tue,  8 Sep 2020 17:24:57 +0200
Message-Id: <20200908152249.175031831@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>

commit 98dfd5024a2e9e170b85c07078e2d89f20a5dfbd upstream.

Index here is already the position of the file in fixed_file_table, we
should not use io_file_from_index() again to get it. Otherwise, the
wrong file which still in use may be released unexpectedly.

Cc: stable@vger.kernel.org # v5.6
Fixes: 05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6928,7 +6928,7 @@ static int __io_sqe_files_update(struct
 		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
 		if (table->files[index]) {
-			file = io_file_from_index(ctx, index);
+			file = table->files[index];
 			err = io_queue_file_removal(data, file);
 			if (err)
 				break;


