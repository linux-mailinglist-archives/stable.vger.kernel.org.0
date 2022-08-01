Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F80D586225
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 03:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbiHABK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 21:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbiHABK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 21:10:56 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD6826C8;
        Sun, 31 Jul 2022 18:10:55 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Lx0QV262JzKHXS;
        Mon,  1 Aug 2022 09:09:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP3 (Coremail) with SMTP id _Ch0CgAHhzAZKOdip_A3AA--.47349S4;
        Mon, 01 Aug 2022 09:10:51 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     ming.lei@redhat.com, stable@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com
Subject: [PATCH stable 5.4] scsi: core: Fix race between handling STS_RESOURCE and completion
Date:   Mon,  1 Aug 2022 09:22:51 +0800
Message-Id: <20220801012251.1959147-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgAHhzAZKOdip_A3AA--.47349S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tFyxXr4fXr1DWF1rCFy7trb_yoW8ur4fpF
        Z3uayjkrWIgF4rC3yDWF1fury5u397Ary5XFW7W3s8uFy3JryrXws3tF1DXF9YkFn7GF1Y
        qryqqFZ2q3W5ArUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
        7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 673235f915318ced5d7ec4b2bfd8cb909e6a4a55 upstream.

When queuing I/O request to LLD, STS_RESOURCE may be returned because:

 - Host is in recovery or blocked

 - Target queue throttling or target is blocked

 - LLD rejection

In these scenarios BLK_STS_DEV_RESOURCE is returned to the block layer to
avoid an unnecessary re-run of the queue. However, all of the requests
queued to this SCSI device may complete immediately after reading
'sdev->device_busy' and BLK_STS_DEV_RESOURCE is returned to block layer. In
that case the current I/O won't get a chance to get queued since it is
invisible at that time for both scsi_run_queue_async() and blk-mq's
RESTART.

Fix the issue by not returning BLK_STS_DEV_RESOURCE in this situation.

Link: https://lore.kernel.org/r/20201202100419.525144-1-ming.lei@redhat.com
Fixes: 86ff7c2a80cd ("blk-mq: introduce BLK_STS_DEV_RESOURCE")
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Ewan Milne <emilne@redhat.com>
Cc: Long Li <longli@microsoft.com>
Reported-by: John Garry <john.garry@huawei.com>
Tested-by: "chenxiang (M)" <chenxiang66@hisilicon.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8e6d7ba95df1..98e363d0025b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1719,8 +1719,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
-		    scsi_device_blocked(sdev))
+		if (scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	default:
-- 
2.31.1

