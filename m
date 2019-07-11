Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536D264F7E
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 02:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfGKASd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 20:18:33 -0400
Received: from smtpbguseast2.qq.com ([54.204.34.130]:56522 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbfGKASd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 20:18:33 -0400
X-QQ-mid: bizesmtp27t1562804305tqyz455g
Received: from Macbook.pro (unknown [218.76.23.26])
        by esmtp10.qq.com (ESMTP) with 
        id ; Thu, 11 Jul 2019 08:18:24 +0800 (CST)
X-QQ-SSF: 01400000002000Q0WO70B00A0000000
X-QQ-FEAT: mJep2VbaKxYF6ut1wqSe7IMsi/9FJ5jKY3oKzyZjnUwk3Hh08eoSM6zs3S2ir
        A8y6nEQRMTOzGD4uVVbpZsiNU3vibQvXl8biRTJfzDZ+yugK9Jw2jfXoPtznICVP6kvj/vV
        p3XGK4wI1xaUIgM8Fg7xCw6w8K2irUktSDavFkZg6fOa5bCfNQdYsVfoKM7md9XYESp50Gi
        dNmdl8nhH03Kp6t542ugEb2ZSSjwe/mJZ4r5Cvvj1ljQMtJPPN+flMdlcyMTXvykEa0djoa
        rZhH7Mb8sPqOGEW7noFVZY7z/aFyfO8U6s1ZBeKEF1+qZ0e8L6KvmnUdI=
X-QQ-GoodBg: 2
From:   Jackie Liu <liuyun01@kylinos.cn>
To:     axboe@kernel.dk
Cc:     Jackie Liu <liuyun01@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH v3] io_uring: fix stuck problem caused by potential memory alloc failure
Date:   Thu, 11 Jul 2019 08:17:05 +0800
Message-Id: <20190711001705.1159-1-liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When io_req_defer alloc memory fails, it will be -EAGAIN. But
io_submit_sqe cannot return immediately because the reference count for
req is still held. Ensure that we free it.

[axboe@kernel.dk: reword commit message]
Fixes: de0617e46717 ("io_uring: add support for marking commands as draining")
Cc: <stable@vger.kernel.org> # 5.2
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4ef62a45045d..1c388533cdc8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1843,8 +1843,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct sqe_submit *s,
 	ret = io_req_defer(ctx, req, s->sqe);
 	if (ret) {
 		if (ret == -EIOCBQUEUED)
-			ret = 0;
-		return ret;
+			return 0;
+		goto out;
 	}
 
 	ret = __io_submit_sqe(ctx, req, s, true);
-- 
2.22.0



