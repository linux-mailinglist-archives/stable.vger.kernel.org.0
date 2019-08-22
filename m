Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B08A99AD8
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389294AbfHVRQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390387AbfHVRIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:34 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6233623428;
        Thu, 22 Aug 2019 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493713;
        bh=LYS3PhcNvoh+tL1N6o+HYoRwuN6L08WbmA+xaB04Dyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrqCH28MvSBoLmnYKYV+vdbpaxbs+W9BeFOH1fD9IfQTjc60ZXCFmzldHlLqx2ZzM
         yl1kJFxJl5mNTc8scdVUNIV+2zVDaHYfXADrOkUrcxPtX2QbzvA6oCUOSAPJG+WkDK
         IbtyNo88bxSzB4BfYfQigcg/DxJfroneS48hHLlE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aleix Roca Nonell <aleix.rocanonell@bsc.es>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 036/135] io_uring: fix manual setup of iov_iter for fixed buffers
Date:   Thu, 22 Aug 2019 13:06:32 -0400
Message-Id: <20190822170811.13303-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleix Roca Nonell <aleix.rocanonell@bsc.es>

commit 99c79f6692ccdc42e04deea8a36e22bb48168a62 upstream.

Commit bd11b3a391e3 ("io_uring: don't use iov_iter_advance() for fixed
buffers") introduced an optimization to avoid using the slow
iov_iter_advance by manually populating the iov_iter iterator in some
cases.

However, the computation of the iterator count field was erroneous: The
first bvec was always accounted for an extent of page size even if the
bvec length was smaller.

In consequence, some I/O operations on fixed buffers were unable to
operate on the full extent of the buffer, consistently skipping some
bytes at the end of it.

Fixes: bd11b3a391e3 ("io_uring: don't use iov_iter_advance() for fixed buffers")
Cc: stable@vger.kernel.org
Signed-off-by: Aleix Roca Nonell <aleix.rocanonell@bsc.es>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e887a09533b3..61018559e8fe6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1032,10 +1032,8 @@ static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
 
 			iter->bvec = bvec + seg_skip;
 			iter->nr_segs -= seg_skip;
-			iter->count -= (seg_skip << PAGE_SHIFT);
+			iter->count -= bvec->bv_len + offset;
 			iter->iov_offset = offset & ~PAGE_MASK;
-			if (iter->iov_offset)
-				iter->count -= iter->iov_offset;
 		}
 	}
 
-- 
2.20.1

