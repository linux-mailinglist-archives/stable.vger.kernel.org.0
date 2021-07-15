Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B45B3CA726
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhGOSwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239587AbhGOSv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:51:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2D51613E9;
        Thu, 15 Jul 2021 18:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374943;
        bh=Ry1aG034I40ds9gCDxFiOmtRE8P3ZjPlXbEhpRWYn94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDJoYMBVGyqpzIcw/Yo8axz6v/9Fz0xrotygKMM70pif+6uFZZXXh/EsL8fjeju+I
         nXJvXA20hsvf/C9uYmHOSwIIBE/sMOxc7VNrUV34oMl2VM8y/4UiqdYY3d8koEbaiz
         fTTOnA1Q3/bQ6EGRggZNqRR0p6pW/KVHscrd+qMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/215] io_uring: fix false WARN_ONCE
Date:   Thu, 15 Jul 2021 20:37:43 +0200
Message-Id: <20210715182615.451998955@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit e6ab8991c5d0b0deae0961dc22c0edd1dee328f5 ]

WARNING: CPU: 1 PID: 11749 at fs/io-wq.c:244 io_wqe_wake_worker fs/io-wq.c:244 [inline]
WARNING: CPU: 1 PID: 11749 at fs/io-wq.c:244 io_wqe_enqueue+0x7f6/0x910 fs/io-wq.c:751

A WARN_ON_ONCE() in io_wqe_wake_worker() can be triggered by a valid
userspace setup. Replace it with pr_warn.

Reported-by: syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f7ede342c3342c4c26668f5168e2993e38bbd99c.1623949695.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f72d53848dcb..8bb17b6d4de3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -299,7 +299,8 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	 * Most likely an attempt to queue unbounded work on an io_wq that
 	 * wasn't setup with any unbounded workers.
 	 */
-	WARN_ON_ONCE(!acct->max_workers);
+	if (unlikely(!acct->max_workers))
+		pr_warn_once("io-wq is not configured for unbound workers");
 
 	rcu_read_lock();
 	ret = io_wqe_activate_free_worker(wqe);
@@ -1085,6 +1086,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(!bounded))
+		return ERR_PTR(-EINVAL);
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
-- 
2.30.2



