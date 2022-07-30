Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E3C585931
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 10:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiG3Ie6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 04:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiG3Ie5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 04:34:57 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D33613E21;
        Sat, 30 Jul 2022 01:34:54 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LvyMj5yx8zKCMB;
        Sat, 30 Jul 2022 16:33:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP3 (Coremail) with SMTP id _Ch0CgCH6mkn7eRi2T9yBQ--.5018S5;
        Sat, 30 Jul 2022 16:34:49 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     stable@vger.kernel.org, ming.lei@redhat.com
Cc:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com
Subject: [PATCH stable 4.19 1/1] scsi: core: Fix race between handling STS_RESOURCE and completion
Date:   Sat, 30 Jul 2022 16:46:51 +0800
Message-Id: <20220730084651.4093719-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220730084651.4093719-1-yukuai1@huaweicloud.com>
References: <20220730084651.4093719-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgCH6mkn7eRi2T9yBQ--.5018S5
X-Coremail-Antispam: 1UD129KBjvJXoW7tFyxXr4fXr1DWF1rCFy7trb_yoW8ur4fpF
        Z7ua4jkrWIgF4rC3yDWF1fury5u397Jry5WFW7W3s8ua43tryxXws3t3WDXF9YkF97GF1Y
        qryqqFZ2q3W5ArUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9m14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWUuVWrJwAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
        0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqAp5UUUUU=
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
index 0191708c9dd4..ace4a7230bcf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2157,8 +2157,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
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

