Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67468246F54
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389880AbgHQRpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388782AbgHQQOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:14:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2CB20658;
        Mon, 17 Aug 2020 16:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680850;
        bh=X2PAq8MhO/WAqxIb8JEj6J3/yTWHfDymhDYywj0ZnmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itJtwCjiEtvd2sl0mA8/IOazUa3rQqlhFBh8LUaocfZCGFgi5f+L0e1ZztX9nnjrV
         ahmGOP4wYaqkNkw9n6zQNDJPMMV10YY24EjuJh6RPYqtuGc4SBNDQ0I3zlCS5D9dGH
         JV6CDfjODgWKUfoGVFmSY2GFtM/wGAuXvTXJ+kT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/168] scsi: scsi_debug: Add check for sdebug_max_queue during module init
Date:   Mon, 17 Aug 2020 17:16:54 +0200
Message-Id: <20200817143737.872833564@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit c87bf24cfb60bce27b4d2c7e56ebfd86fb9d16bb ]

sdebug_max_queue should not exceed SDEBUG_CANQUEUE, otherwise crashes like
this can be triggered by passing an out-of-range value:

Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI RC0 - V1.16.01 03/15/2019
 pstate: 20400009 (nzCv daif +PAN -UAO BTYPE=--)
 pc : schedule_resp+0x2a4/0xa70 [scsi_debug]
 lr : schedule_resp+0x52c/0xa70 [scsi_debug]
 sp : ffff800022ab36f0
 x29: ffff800022ab36f0 x28: ffff0023a935a610
 x27: ffff800008e0a648 x26: 0000000000000003
 x25: ffff0023e84f3200 x24: 00000000003d0900
 x23: 0000000000000000 x22: 0000000000000000
 x21: ffff0023be60a320 x20: ffff0023be60b538
 x19: ffff800008e13000 x18: 0000000000000000
 x17: 0000000000000000 x16: 0000000000000000
 x15: 0000000000000000 x14: 0000000000000000
 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000000 x10: 0000000000000000
 x9 : 0000000000000001 x8 : 0000000000000000
 x7 : 0000000000000000 x6 : 00000000000000c1
 x5 : 0000020000200000 x4 : dead0000000000ff
 x3 : 0000000000000200 x2 : 0000000000000200
 x1 : ffff800008e13d88 x0 : 0000000000000000
 Call trace:
schedule_resp+0x2a4/0xa70 [scsi_debug]
scsi_debug_queuecommand+0x2c4/0x9e0 [scsi_debug]
scsi_queue_rq+0x698/0x840
__blk_mq_try_issue_directly+0x108/0x228
blk_mq_request_issue_directly+0x58/0x98
blk_mq_try_issue_list_directly+0x5c/0xf0
blk_mq_sched_insert_requests+0x18c/0x200
blk_mq_flush_plug_list+0x11c/0x190
blk_flush_plug_list+0xdc/0x110
blk_finish_plug+0x38/0x210
blkdev_direct_IO+0x450/0x4d8
generic_file_read_iter+0x84/0x180
blkdev_read_iter+0x3c/0x50
aio_read+0xc0/0x170
io_submit_one+0x5c8/0xc98
__arm64_sys_io_submit+0x1b0/0x258
el0_svc_common.constprop.3+0x68/0x170
do_el0_svc+0x24/0x90
el0_sync_handler+0x13c/0x1a8
el0_sync+0x158/0x180
 Code: 528847e0 72a001e0 6b00003f 540018cd (3941c340)

In addition, it should not be less than 1.

So add checks for these, and fail the module init for those cases.

[mkp: changed if condition to match error message]

Link: https://lore.kernel.org/r/1594297400-24756-2-git-send-email-john.garry@huawei.com
Fixes: c483739430f1 ("scsi_debug: add multiple queue support")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a1dbae806fdea..d2b045eb72742 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5384,6 +5384,12 @@ static int __init scsi_debug_init(void)
 		pr_err("submit_queues must be 1 or more\n");
 		return -EINVAL;
 	}
+
+	if ((sdebug_max_queue > SDEBUG_CANQUEUE) || (sdebug_max_queue < 1)) {
+		pr_err("max_queue must be in range [1, %d]\n", SDEBUG_CANQUEUE);
+		return -EINVAL;
+	}
+
 	sdebug_q_arr = kcalloc(submit_queues, sizeof(struct sdebug_queue),
 			       GFP_KERNEL);
 	if (sdebug_q_arr == NULL)
-- 
2.25.1



