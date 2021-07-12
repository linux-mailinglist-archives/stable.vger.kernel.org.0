Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9413A3C5265
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346059AbhGLHpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245742AbhGLHne (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7FB461154;
        Mon, 12 Jul 2021 07:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075622;
        bh=YezxmHkVKlaq8LJoW49npvt6RvVWcow9De0XHBKCEk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnDXJ7iV11ygdLy+vsCUKJn8wK+2XA9vfEhOIwgJ5wgEqep1qeCuJas/oW1nqmsxP
         Zfdc8fNk6SHoanK0m+SHPkbZbF17l/ZCTzyxBjbbEz1RoEsesRLpRqB0QU7VXwjAri
         wmJjVGV3YexS19P7RdWhdWRREJJUJn5oIjEatsPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Mariotti <mariottiluca1@hotmail.it>,
        Paolo Valente <paolo.valente@unimore.it>,
        Pietro Pedroni <pedroni.pietro.96@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 251/800] block, bfq: fix delayed stable merge check
Date:   Mon, 12 Jul 2021 08:04:34 +0200
Message-Id: <20210712060949.189283381@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Mariotti <mariottiluca1@hotmail.it>

[ Upstream commit e03f2ab78a4a673e4af23c3b855591c48b9de4d7 ]

When attempting to schedule a merge of a given bfq_queue with the currently
in-service bfq_queue or with a cooperating bfq_queue among the scheduled
bfq_queues, delayed stable merge is checked for rotational or non-queueing
devs. For this stable merge to be performed, some conditions must be met.
If the current bfq_queue underwent some split from some merged bfq_queue,
one of these conditions is that two hundred milliseconds must elapse from
split, otherwise this condition is always met.

Unfortunately, by mistake, time_is_after_jiffies() was written instead of
time_is_before_jiffies() for this check, verifying that less than two
hundred milliseconds have elapsed instead of verifying that at least two
hundred milliseconds have elapsed.

Fix this issue by replacing time_is_after_jiffies() with
time_is_before_jiffies().

Signed-off-by: Luca Mariotti <mariottiluca1@hotmail.it>
Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: Pietro Pedroni <pedroni.pietro.96@gmail.com>
Link: https://lore.kernel.org/r/20210619140948.98712-3-paolo.valente@linaro.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index acd1f881273e..2adb1e69c9d2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2697,7 +2697,7 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (unlikely(!bfqd->nonrot_with_queueing)) {
 		if (bic->stable_merge_bfqq &&
 		    !bfq_bfqq_just_created(bfqq) &&
-		    time_is_after_jiffies(bfqq->split_time +
+		    time_is_before_jiffies(bfqq->split_time +
 					  msecs_to_jiffies(200))) {
 			struct bfq_queue *stable_merge_bfqq =
 				bic->stable_merge_bfqq;
-- 
2.30.2



