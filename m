Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2B24B746
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgHTKuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731248AbgHTKPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:15:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18B90206DA;
        Thu, 20 Aug 2020 10:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918521;
        bh=ZoPGPLTd1tfoBBhnHsu+QRKUDzo43J4+2465GGUq1aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tu6tVAoP18JO/+/dWy9aaEYtgUxiTQmNCfw0Fm3ee9ssVEXUQ4hmdKFRchrVhdE4/
         dFHjB7hqiaVRJF8yCpZDR/Nz6+dF5F12w4CbQlLKzJv7le+Moi3f7C/q2OLkrXEJDA
         n8ULCkVeXDwQdchPIsYeW53BVIPXfZgF8vd3OnIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 201/228] dm rq: dont call blk_mq_queue_stopped() in dm_stop_queue()
Date:   Thu, 20 Aug 2020 11:22:56 +0200
Message-Id: <20200820091617.596300473@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit e766668c6cd49d741cfb49eaeb38998ba34d27bc ]

dm_stop_queue() only uses blk_mq_quiesce_queue() so it doesn't
formally stop the blk-mq queue; therefore there is no point making the
blk_mq_queue_stopped() check -- it will never be stopped.

In addition, even though dm_stop_queue() actually tries to quiesce hw
queues via blk_mq_quiesce_queue(), checking with blk_queue_quiesced()
to avoid unnecessary queue quiesce isn't reliable because: the
QUEUE_FLAG_QUIESCED flag is set before synchronize_rcu() and
dm_stop_queue() may be called when synchronize_rcu() from another
blk_mq_quiesce_queue() is in-progress.

Fixes: 7b17c2f7292ba ("dm: Fix a race condition related to stopping and starting queues")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-rq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index eadfcfd106fff..cac8ec16e6031 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -95,9 +95,6 @@ static void dm_old_stop_queue(struct request_queue *q)
 
 static void dm_mq_stop_queue(struct request_queue *q)
 {
-	if (blk_mq_queue_stopped(q))
-		return;
-
 	blk_mq_quiesce_queue(q);
 }
 
-- 
2.25.1



