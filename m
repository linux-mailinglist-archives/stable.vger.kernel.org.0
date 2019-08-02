Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C557FAFC
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393293AbfHBNUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393282AbfHBNUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 902412189E;
        Fri,  2 Aug 2019 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752007;
        bh=6ZsXPMekXwgsbiMKJ+0VJ5o+h4+7cciKIcWqCQg6f0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKUKYSgIQrBqooG715VMyeb84gV4MDe7cjXtCpH4RXGl5nRIUUrPDYgXmK4sU1TdC
         K75bNGVsI78kZJkodl4jK3Llhy6dni+4iVMWWnoz+wNxXU3jzzW8AJTH0oPT9vR55Q
         /ZaT7RCtGBENJMNo3Q31pboROrrQLmkh8jFbOD10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 13/76] rq-qos: set ourself TASK_UNINTERRUPTIBLE after we schedule
Date:   Fri,  2 Aug 2019 09:18:47 -0400
Message-Id: <20190802131951.11600-13-sashal@kernel.org>
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

[ Upstream commit d14a9b389a86a5154b704bc88ce8dd37c701456a ]

In case we get a spurious wakeup we need to make sure to re-set
ourselves to TASK_UNINTERRUPTIBLE so we don't busy wait.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index e5d75280b431e..e3ab75e4df9ea 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -261,6 +261,7 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 		}
 		io_schedule();
 		has_sleeper = true;
+		set_current_state(TASK_UNINTERRUPTIBLE);
 	} while (1);
 	finish_wait(&rqw->wait, &data.wq);
 }
-- 
2.20.1

