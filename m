Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16ADB2F4862
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 11:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbhAMKKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 05:10:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:44664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbhAMKKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 05:10:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F189CB771;
        Wed, 13 Jan 2021 10:09:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B53F81E0804; Wed, 13 Jan 2021 11:09:37 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 1/3] bfq: Avoid false bfq queue merging
Date:   Wed, 13 Jan 2021 11:09:25 +0100
Message-Id: <20210113100937.8278-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605140837.5394-1-jack@suse.cz>
References: <20200605140837.5394-1-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bfq_setup_cooperator() uses bfqd->in_serv_last_pos so detect whether it
makes sense to merge current bfq queue with the in-service queue.
However if the in-service queue is freshly scheduled and didn't dispatch
any requests yet, bfqd->in_serv_last_pos is stale and contains value
from the previously scheduled bfq queue which can thus result in a bogus
decision that the two queues should be merged. This bug can be observed
for example with the following fio jobfile:

[global]
direct=0
ioengine=sync
invalidate=1
size=1g
rw=read

[reader]
numjobs=4
directory=/mnt

where the 4 processes will end up in the one shared bfq queue although
they do IO to physically very distant files (for some reason I was able to
observe this only with slice_idle=1ms setting).

Fix the problem by invalidating bfqd->in_serv_last_pos when switching
in-service queue.

Fixes: 058fdecc6de7 ("block, bfq: fix in-service-queue check for queue merging")
CC: stable@vger.kernel.org
Acked-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 9e4eb0fc1c16..dc5f12d0d482 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2937,6 +2937,7 @@ static void __bfq_set_in_service_queue(struct bfq_data *bfqd,
 	}
 
 	bfqd->in_service_queue = bfqq;
+	bfqd->in_serv_last_pos = -1;
 }
 
 /*
-- 
2.26.2

