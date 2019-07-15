Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A7A69721
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732574AbfGON5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732378AbfGON5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:57:11 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D5B420C01;
        Mon, 15 Jul 2019 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199030;
        bh=3jtqXFsdy9+nN0Tz9J17po0Nvk+gwLyZ0NOhRPT6fiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfR32nCtKz8xD9WS4lRGJ7KWIV4gmH8X34QtasGm+iXgRy41+Qz4x2AlTLP52Nv9I
         nrDyMmxGFIpBq9oSPZ4VsMgGRBKb3jmKxP6aW51bXeUhwXoB6ThCKQj/QGDT3Dzqok
         upMLmaGOsJnvxMjnUiKNWretx3DnJk1dRPhufpWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        "Srivatsa S . Bhat" <srivatsa@csail.mit.edu>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 169/249] block, bfq: fix rq_in_driver check in bfq_update_inject_limit
Date:   Mon, 15 Jul 2019 09:45:34 -0400
Message-Id: <20190715134655.4076-169-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit db599f9ed9bd31b018b6c48ad7c6b21d5b790ecf ]

One of the cases where the parameters for injection may be updated is
when there are no more in-flight I/O requests. The number of in-flight
requests is stored in the field bfqd->rq_in_driver of the descriptor
bfqd of the device. So, the controlled condition is
bfqd->rq_in_driver == 0.

Unfortunately, this is wrong because, the instruction that checks this
condition is in the code path that handles the completion of a
request, and, in particular, the instruction is executed before
bfqd->rq_in_driver is decremented in such a code path.

This commit fixes this issue by just replacing 0 with 1 in the
comparison.

Reported-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Tested-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index e5db3856b194..404e776aa36d 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5398,8 +5398,14 @@ static void bfq_update_inject_limit(struct bfq_data *bfqd,
 	 * total service time, and there seem to be the right
 	 * conditions to do it, or we can lower the last base value
 	 * computed.
+	 *
+	 * NOTE: (bfqd->rq_in_driver == 1) means that there is no I/O
+	 * request in flight, because this function is in the code
+	 * path that handles the completion of a request of bfqq, and,
+	 * in particular, this function is executed before
+	 * bfqd->rq_in_driver is decremented in such a code path.
 	 */
-	if ((bfqq->last_serv_time_ns == 0 && bfqd->rq_in_driver == 0) ||
+	if ((bfqq->last_serv_time_ns == 0 && bfqd->rq_in_driver == 1) ||
 	    tot_time_ns < bfqq->last_serv_time_ns) {
 		bfqq->last_serv_time_ns = tot_time_ns;
 		/*
-- 
2.20.1

