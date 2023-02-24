Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66AE26A1693
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 07:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjBXGX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 01:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBXGXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 01:23:55 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED04C25E0C;
        Thu, 23 Feb 2023 22:23:52 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PNKbR0w0qz4f3l92;
        Fri, 24 Feb 2023 14:23:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
        by APP4 (Coremail) with SMTP id gCh0CgBXwLPzV_hjqVfcEA--.64482S4;
        Fri, 24 Feb 2023 14:23:49 +0800 (CST)
From:   Hou Tao <houtao@huaweicloud.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-raid@vger.kernel.org,
        David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, houtao1@huawei.com
Subject: [PATCH 5.10] md: Flush workqueue md_rdev_misc_wq in md_alloc()
Date:   Fri, 24 Feb 2023 14:52:09 +0800
Message-Id: <20230224065209.3170104-1-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBXwLPzV_hjqVfcEA--.64482S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar15Aw1UZr1rXF1kWr1rJFb_yoW8Xr18pr
        WS9ay5tr18JFW8Ka1UXF1xu3s8uw1qk397uF1fur43Zr1DArn5Jw1xK3WrXFyDCr95ZryY
        vF4UuF95Z3W8A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJV
        Cq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBI
        daVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sloan <david.sloan@eideticom.com>

commit 5e8daf906f890560df430d30617c692a794acb73 upstream.

A race condition still exists when removing and re-creating md devices
in test cases. However, it is only seen on some setups.

The race condition was tracked down to a reference still being held
to the kobject by the rdev in the md_rdev_misc_wq which will be released
in rdev_delayed_delete().

md_alloc() waits for previous deletions by waiting on the md_misc_wq,
but the md_rdev_misc_wq may still be holding a reference to a recently
removed device.

To fix this, also flush the md_rdev_misc_wq in md_alloc().

Signed-off-by: David Sloan <david.sloan@eideticom.com>
[logang@deltatee.com: rewrote commit message]
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
Hi Greg,

We found the problem also exists on v5.10, so could you please pick it up
for v5.10 ?

Thanks.

 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3038e7ecb7e1..c0b34637bd66 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5683,6 +5683,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * completely removed (mddev_delayed_delete).
 	 */
 	flush_workqueue(md_misc_wq);
+	flush_workqueue(md_rdev_misc_wq);
 
 	mutex_lock(&disks_mutex);
 	error = -EEXIST;
-- 
2.29.2

