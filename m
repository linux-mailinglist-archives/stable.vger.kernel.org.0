Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A78371A5D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhECQjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231923AbhECQiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B52D613DF;
        Mon,  3 May 2021 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059809;
        bh=dpiciSMR6RISrdvVoW7CrBO0+Jrk4Cgg6GoFd/SA6nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRkioRQjFGZEbP7tjrZXX6pgd0XVll/vchTD8fruUGVQhiQxjaws99sddWkwL3O6F
         C/uf2oc64j4j4Wvpp5TyOkPq+brVl+eAJu+kWgf2NE7i87A0wGbwkAmam67gC/jn6i
         VW5G0xoyb+5tA7Qnephyuw/ZKTxbwTCtIBxcf0DJ1FJusAQJxgovN7utyyDavRqVlJ
         UOh/RZ8OoI8Bt7ShVRWl+qqcn2BQiW7R9igWYbQbhjLUKMm/OlcqfiL9zmpOmKPU1f
         bGHctDTbQYSe4Y3sPgeIIFq6RtUQitrpNufpnVeyYwISu8luOWO1zt6U0KthicG5Nl
         Zi0beIjNu4niQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>, Jan Kara <jack@suse.cz>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 061/134] block, bfq: fix weight-raising resume with !low_latency
Date:   Mon,  3 May 2021 12:34:00 -0400
Message-Id: <20210503163513.2851510-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit 8c544770092a3d7532d01903b75721e537d87001 ]

When the io_latency heuristic is off, bfq_queues must not start to be
weight-raised. Unfortunately, by mistake, this may happen when the
state of a previously weight-raised bfq_queue is resumed after a queue
split. This commit fixes this error.

Tested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Link: https://lore.kernel.org/r/20210304174627.161-5-paolo.valente@linaro.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 95586137194e..20ba5db0f61c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1012,7 +1012,7 @@ static void
 bfq_bfqq_resume_state(struct bfq_queue *bfqq, struct bfq_data *bfqd,
 		      struct bfq_io_cq *bic, bool bfq_already_existing)
 {
-	unsigned int old_wr_coeff = bfqq->wr_coeff;
+	unsigned int old_wr_coeff = 1;
 	bool busy = bfq_already_existing && bfq_bfqq_busy(bfqq);
 
 	if (bic->saved_has_short_ttime)
@@ -1033,7 +1033,13 @@ bfq_bfqq_resume_state(struct bfq_queue *bfqq, struct bfq_data *bfqd,
 	bfqq->ttime = bic->saved_ttime;
 	bfqq->io_start_time = bic->saved_io_start_time;
 	bfqq->tot_idle_time = bic->saved_tot_idle_time;
-	bfqq->wr_coeff = bic->saved_wr_coeff;
+	/*
+	 * Restore weight coefficient only if low_latency is on
+	 */
+	if (bfqd->low_latency) {
+		old_wr_coeff = bfqq->wr_coeff;
+		bfqq->wr_coeff = bic->saved_wr_coeff;
+	}
 	bfqq->service_from_wr = bic->saved_service_from_wr;
 	bfqq->wr_start_at_switch_to_srt = bic->saved_wr_start_at_switch_to_srt;
 	bfqq->last_wr_start_finish = bic->saved_last_wr_start_finish;
-- 
2.30.2

