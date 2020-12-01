Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA5F2C9C14
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389707AbgLAJOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390357AbgLAJOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:14:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 391C621D7A;
        Tue,  1 Dec 2020 09:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814048;
        bh=gCsx68+GJcjHhskWcZ+Xxw/NwWVAdsUz9SjIgzpQH8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAy16rM1Gv9nNDlzCHAnLIUPtFKzwOkW/OF0dqITxJK8F2ZODtzKwF8RYJa1IdFSn
         9nRl8WBoheySHuozstCwZFludoM3G6g6qCqZYvu0twdjc4ngjnerLWGNkZ2b6KotQa
         cpFCT4sKGUX6xnQ5TuDxypb/qZkx6+T2Nd2RmkcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Fuzz <abaci@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 108/152] io_uring: fix shift-out-of-bounds when round up cq size
Date:   Tue,  1 Dec 2020 09:53:43 +0100
Message-Id: <20201201084725.990694573@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit eb2667b343361863da7b79be26de641e22844ba0 ]

Abaci Fuzz reported a shift-out-of-bounds BUG in io_uring_create():

[ 59.598207] UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
[ 59.599665] shift exponent 64 is too large for 64-bit type 'long unsigned int'
[ 59.601230] CPU: 0 PID: 963 Comm: a.out Not tainted 5.10.0-rc4+ #3
[ 59.602502] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 59.603673] Call Trace:
[ 59.604286] dump_stack+0x107/0x163
[ 59.605237] ubsan_epilogue+0xb/0x5a
[ 59.606094] __ubsan_handle_shift_out_of_bounds.cold+0xb2/0x20e
[ 59.607335] ? lock_downgrade+0x6c0/0x6c0
[ 59.608182] ? rcu_read_lock_sched_held+0xaf/0xe0
[ 59.609166] io_uring_create.cold+0x99/0x149
[ 59.610114] io_uring_setup+0xd6/0x140
[ 59.610975] ? io_uring_create+0x2510/0x2510
[ 59.611945] ? lockdep_hardirqs_on_prepare+0x286/0x400
[ 59.613007] ? syscall_enter_from_user_mode+0x27/0x80
[ 59.614038] ? trace_hardirqs_on+0x5b/0x180
[ 59.615056] do_syscall_64+0x2d/0x40
[ 59.615940] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 59.617007] RIP: 0033:0x7f2bb8a0b239

This is caused by roundup_pow_of_two() if the input entries larger
enough, e.g. 2^32-1. For sq_entries, it will check first and we allow
at most IORING_MAX_ENTRIES, so it is okay. But for cq_entries, we do
round up first, that may overflow and truncate it to 0, which is not
the expected behavior. So check the cq size first and then do round up.

Fixes: 88ec3211e463 ("io_uring: round-up cq size before comparing with rounded sq size")
Reported-by: Abaci Fuzz <abaci@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5d9f8e40b93d3..6d729a278535e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8907,14 +8907,16 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		 * to a power-of-two, if it isn't already. We do NOT impose
 		 * any cq vs sq ring sizing.
 		 */
-		p->cq_entries = roundup_pow_of_two(p->cq_entries);
-		if (p->cq_entries < p->sq_entries)
+		if (!p->cq_entries)
 			return -EINVAL;
 		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
 			if (!(p->flags & IORING_SETUP_CLAMP))
 				return -EINVAL;
 			p->cq_entries = IORING_MAX_CQ_ENTRIES;
 		}
+		p->cq_entries = roundup_pow_of_two(p->cq_entries);
+		if (p->cq_entries < p->sq_entries)
+			return -EINVAL;
 	} else {
 		p->cq_entries = 2 * p->sq_entries;
 	}
-- 
2.27.0



