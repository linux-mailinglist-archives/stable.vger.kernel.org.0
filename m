Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E933BCE92
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhGFL0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233027AbhGFLTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9C1A61CA2;
        Tue,  6 Jul 2021 11:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570219;
        bh=QUvN+qREW2qmUAiRphV02G9Yj2oxJVfc6d6/h1ouvag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlJgvmk6dOzBfsOf2Vvn2Vmneb6HWxe+jYDmDXScCOKTXRshLaEIUTmo3xfclrYhH
         fCi0wj1Fh4StH3IJf0YblgWpu+pRrBqfcoi2PSOO7NzrIMElMBSH1kdsimj83MwnM4
         nGFRkdKQ0Im9qCz/gSEu7fvx/isQo4/pSAYmOpwVq7PGxQk+eHrQChkd4UJQq/CVE/
         f4f7G6u96YVMeOG8zk43EgNje5ikxDX2L/9XLibhWHA7BwEnzecxTp1YPXM9abu67M
         yEvRdvSZJ9jqdIMDIEwUzbGODUf5W39WV548MQ4eTg40AWszcKMlzYuAooutxpCOyi
         19xcwxDPX0Qmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 127/189] io_uring: fix false WARN_ONCE
Date:   Tue,  6 Jul 2021 07:13:07 -0400
Message-Id: <20210706111409.2058071-127-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b3e8624a37d0..60f58efdb5f4 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -241,7 +241,8 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	 * Most likely an attempt to queue unbounded work on an io_wq that
 	 * wasn't setup with any unbounded workers.
 	 */
-	WARN_ON_ONCE(!acct->max_workers);
+	if (unlikely(!acct->max_workers))
+		pr_warn_once("io-wq is not configured for unbound workers");
 
 	rcu_read_lock();
 	ret = io_wqe_activate_free_worker(wqe);
@@ -906,6 +907,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(!bounded))
+		return ERR_PTR(-EINVAL);
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
-- 
2.30.2

