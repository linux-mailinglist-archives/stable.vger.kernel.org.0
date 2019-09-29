Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14151C1842
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfI2RcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbfI2RcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:32:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7BBD2196E;
        Sun, 29 Sep 2019 17:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778324;
        bh=1gC8dF8dzfLCl1x3XsU1+O9RnKWeN/KhwwtSk3TzVcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZndgS7LGHCSTDfbGS3wn6hSE2Da4e9AM9WUn36W1B2dqVreCDN/qWG+5eBNVGf8d6
         AiaTNwnzRZSPUly4GSozkTXbmdtwBH4bCgXofX3qrcstGp82oV40Plg5B+WiPkZfrH
         7wHWxZoEouid+7JCBcvEY/d53YMrL80gidYFUk6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 36/49] block, bfq: push up injection only after setting service time
Date:   Sun, 29 Sep 2019 13:30:36 -0400
Message-Id: <20190929173053.8400-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit 58494c980f40274c465ebfdece02d401def088bf ]

If equal to 0, the injection limit for a bfq_queue is pushed to 1
after a first sample of the total service time of the I/O requests of
the queue is computed (to allow injection to start). Yet, because of a
mistake in the branch that performs this action, the push may happen
also in some other case. This commit fixes this issue.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index b33be928d164f..70bcbd02edcb1 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5809,12 +5809,14 @@ static void bfq_update_inject_limit(struct bfq_data *bfqd,
 	 */
 	if ((bfqq->last_serv_time_ns == 0 && bfqd->rq_in_driver == 1) ||
 	    tot_time_ns < bfqq->last_serv_time_ns) {
+		if (bfqq->last_serv_time_ns == 0) {
+			/*
+			 * Now we certainly have a base value: make sure we
+			 * start trying injection.
+			 */
+			bfqq->inject_limit = max_t(unsigned int, 1, old_limit);
+		}
 		bfqq->last_serv_time_ns = tot_time_ns;
-		/*
-		 * Now we certainly have a base value: make sure we
-		 * start trying injection.
-		 */
-		bfqq->inject_limit = max_t(unsigned int, 1, old_limit);
 	} else if (!bfqd->rqs_injected && bfqd->rq_in_driver == 1)
 		/*
 		 * No I/O injected and no request still in service in
-- 
2.20.1

