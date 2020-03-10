Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FAD17F88A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgCJMss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbgCJMsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:48:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C49FC2468E;
        Tue, 10 Mar 2020 12:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844526;
        bh=VhzaO8yRe3wCynyv0rVSufOA69/1pZfzMzeM23xUXA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=metSDhQuiF6sd1gBQNzMf+blnX4KsKYrE4ES8SnWTt4/dUVIISQkEHj3qF8b1N18y
         Dzo6M2Dptq7Eej0tzZuizQj5hYVmR15ShnfhVYegNRSRxfum0FDSuVXKPw9Fx+cmuk
         G7DMKu05800Cx7SdgFdEko1CWJg/hu0T3ivsFCRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Dung <patdung100@gmail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/168] block, bfq: do not insert oom queue into position tree
Date:   Tue, 10 Mar 2020 13:37:29 +0100
Message-Id: <20200310123635.620435587@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit 32c59e3a9a5a0b180dd015755d6d18ca31e55935 ]

BFQ maintains an ordered list, implemented with an RB tree, of
head-request positions of non-empty bfq_queues. This position tree,
inherited from CFQ, is used to find bfq_queues that contain I/O close
to each other. BFQ merges these bfq_queues into a single shared queue,
if this boosts throughput on the device at hand.

There is however a special-purpose bfq_queue that does not participate
in queue merging, the oom bfq_queue. Yet, also this bfq_queue could be
wrongly added to the position tree. So bfqq_find_close() could return
the oom bfq_queue, which is a source of further troubles in an
out-of-memory situation. This commit prevents the oom bfq_queue from
being inserted into the position tree.

Tested-by: Patrick Dung <patdung100@gmail.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 5498d05b873d3..955daa29303a8 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -614,6 +614,10 @@ bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 		bfqq->pos_root = NULL;
 	}
 
+	/* oom_bfqq does not participate in queue merging */
+	if (bfqq == &bfqd->oom_bfqq)
+		return;
+
 	/*
 	 * bfqq cannot be merged any longer (see comments in
 	 * bfq_setup_cooperator): no point in adding bfqq into the
-- 
2.20.1



