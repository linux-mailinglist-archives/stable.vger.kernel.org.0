Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405A97FAFA
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393286AbfHBNUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393280AbfHBNUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 711662087C;
        Fri,  2 Aug 2019 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752006;
        bh=rL23VPL5LiMMzW9WGs9qMwcc3Mu20T2X1ST1LCulyRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07nHCnBRznje0SLb5zH9zB5lwXFnmx6LzHynYrYO6E75dO6Bs+VtXevx5jwjowNa4
         OZd9cLkoJKZrOctxVPdQ8VLWEgkE8OZVhMHTBnxztxeVT0w2ZiRhM4rTMLqlirXBJS
         ugUnSZsHqVUaihXCNJpf5uLzTjzgnxrNTLiUbiqU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 12/76] rq-qos: don't reset has_sleepers on spurious wakeups
Date:   Fri,  2 Aug 2019 09:18:46 -0400
Message-Id: <20190802131951.11600-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 64e7ea875ef63b2801be7954cf7257d1bfccc266 ]

If we raced with somebody else getting an inflight counter we could fail
to get an inflight counter with no sleepers on the list, and thus need
to go to sleep.  In this case has_sleepers should be true because we are
now relying on the waker to get our inflight counter for us.  And in the
case of spurious wakeups we'd still want this to be the case.  So set
has_sleepers to true if we went to sleep to make sure we're woken up the
proper way.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 659ccb8b693fa..e5d75280b431e 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -260,7 +260,7 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 			break;
 		}
 		io_schedule();
-		has_sleeper = false;
+		has_sleeper = true;
 	} while (1);
 	finish_wait(&rqw->wait, &data.wq);
 }
-- 
2.20.1

