Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D54F687EC0
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 14:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjBBNfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 08:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjBBNfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 08:35:03 -0500
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1771A962;
        Thu,  2 Feb 2023 05:35:01 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4P70C04Cbpz4f3mJQ;
        Thu,  2 Feb 2023 21:34:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP3 (Coremail) with SMTP id _Ch0CgBH9CH9u9tjvuV3Cg--.42880S4;
        Thu, 02 Feb 2023 21:34:54 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org, jack@suse.cz,
        paolo.valente@linaro.org, axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, yukuai3@huawei.com,
        yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: [PATCH 4.19] cfq: fix memory leak for cfqq
Date:   Thu,  2 Feb 2023 21:58:50 +0800
Message-Id: <20230202135850.2415165-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgBH9CH9u9tjvuV3Cg--.42880S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ArykurWrWrW8Aw4fGr48JFb_yoW8tr48pr
        1jka1DCr48Ww48Cw4Utr15XFn3WF4DuFW2qrWrJr17tr18XFsFyryUAa12grW7Ars2y3y7
        ZF1DKryvqryqy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
        xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
        MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
        0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AK
        xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
        fUouWlDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

If cfqq is merged with another cfqq(assume that no cfqq is merged to
this cfqq) and then user thread is moved to another cgroup, then
check_blkcg_changed() will set cic->cfqq[1] to NULL. However, this cfqq is
still merged and no one will referece this cfqq, which will cause
following kmemleak:

comm "cgexec", pid 2541110, jiffies 4317578508 (age 5728.064s)
hex dump (first 32 bytes):
03 00 00 00 90 03 00 00 80 8d 0f be 20 80 ff ff ............ ...
a0 16 c6 a1 21 80 ff ff 00 00 00 00 00 00 00 00 ....!...........
backtrace:
[<0000000071d2775e>] kmem_cache_alloc_node+0x13c/0x660
[<00000000e827e6fd>] cfq_get_queue+0x318/0x6f0
[<00000000945249ee>] cfq_set_request+0x724/0xe38
[<00000000af64d5a9>] elv_set_request+0x84/0xd0
[<0000000047344f0d>] __get_request+0x970/0xf90
[<00000000d016bd51>] get_request+0x278/0x970
[<0000000052512d36>] blk_queue_bio+0x278/0xcc0
[<0000000085282101>] generic_make_request+0x3c0/0x778
[<0000000089f69c24>] submit_bio+0xdc/0x408
[<00000000748509ae>] ext4_mpage_readpages+0xc84/0x13b8 [ext4]
[<0000000078bfc705>] ext4_readpages+0x80/0xc0 [ext4]
[<00000000317f2ed7>] read_pages+0xd0/0x610
[<00000000e7ab01d2>] __do_page_cache_readahead+0x36c/0x430
[<0000000071df2285>] ondemand_readahead+0x24c/0x6b0
[<00000000124a824a>] page_cache_sync_readahead+0x188/0x448
[<00000000bca561ae>] generic_file_buffered_read+0x648/0x2b58
unreferenced object 0xffffa028411d4720 (size 240):

Fix the problem by put cooperator in check_blkcg_changed(), so that old
cfqq can be freed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/cfq-iosched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 2eb87444b157..88bae553ece3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3778,6 +3778,7 @@ static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "changed cgroup");
 		cic_set_cfqq(cic, NULL, true);
+		cfq_put_cooperator(cfqq);
 		cfq_put_queue(cfqq);
 	}
 
-- 
2.31.1

