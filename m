Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3790C68CEC
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731901AbfGONyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732553AbfGONyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:54:50 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0CDC212F5;
        Mon, 15 Jul 2019 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198889;
        bh=gj0zBDm52IIackDZtC7KVsYGiEuhEY9qeD30u0iD1ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xbf/oMhPRWW5zjmncl0vn6JnaOBfY86I2kZ3gcFcavEfYx5V/JCO1WA6w+sFS4PDR
         4dGFtuHaNlj+gSQlLZa/1qz+oH8uG2oFcZySelpq1/TiFd27ASqTUL8cELlLdhxEuS
         tgg2DR2Gfjhf6O438IXn0v4QYfGdr7jIL//d1dso=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 129/249] blk-iolatency: only account submitted bios
Date:   Mon, 15 Jul 2019 09:44:54 -0400
Message-Id: <20190715134655.4076-129-sashal@kernel.org>
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

From: Dennis Zhou <dennis@kernel.org>

[ Upstream commit a3fb01ba5af066521f3f3421839e501bb2c71805 ]

As is, iolatency recognizes done_bio and cleanup as ending paths. If a
request is marked REQ_NOWAIT and fails to get a request, the bio is
cleaned up via rq_qos_cleanup() and ended in bio_wouldblock_error().
This results in underflowing the inflight counter. Fix this by only
accounting bios that were actually submitted.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index d22e61bced86..c91b84bb9d0a 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -600,6 +600,10 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	if (!blkg || !bio_flagged(bio, BIO_TRACKED))
 		return;
 
+	/* We didn't actually submit this bio, don't account it. */
+	if (bio->bi_status == BLK_STS_AGAIN)
+		return;
+
 	iolat = blkg_to_lat(bio->bi_blkg);
 	if (!iolat)
 		return;
-- 
2.20.1

