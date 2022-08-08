Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D00258C219
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 05:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbiHHDcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 23:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbiHHDcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 23:32:07 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DA47679;
        Sun,  7 Aug 2022 20:31:37 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4M1MCT2l0RzKCgC;
        Mon,  8 Aug 2022 11:30:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgCnkb2Vg_BiCdhFAA--.42849S3;
        Mon, 08 Aug 2022 11:31:34 +0800 (CST)
Subject: Re: [PATCH stable 5.10 1/3] block: look up holders by bdev
To:     Greg KH <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, stable@vger.kernel.org,
        axboe@kernel.dk, snitzer@redhat.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, yi.zhang@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com> <20220801180458.GA17425@lst.de>
 <Yuix/CcmdKsSD+za@kroah.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b06f4667-d70e-54ee-6c6f-b68865ca61a4@huaweicloud.com>
Date:   Mon, 8 Aug 2022 11:31:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Yuix/CcmdKsSD+za@kroah.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgCnkb2Vg_BiCdhFAA--.42849S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ur1fZFy7XrW5ZrWDXF47Jwb_yoW8CrWfpa
        12qa9Ykws5GF48ta4xZ3WIkFn3twsayry3G3s5JrZ5uws0krySqrWxKFWUZryDWFs8Gr1I
        9F4jk395uFn5tw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
        nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Christoph

ÔÚ 2022/08/02 13:11, Greg KH Ð´µÀ:
> On Mon, Aug 01, 2022 at 08:04:58PM +0200, Christoph Hellwig wrote:
>> On Mon, Aug 01, 2022 at 01:19:09PM +0200, Greg KH wrote:
>>> This is very different from the upstream version, and forces the change
>>> onto everyone, not just those who had CONFIG_BLOCK_HOLDER_DEPRECATED
>>> enabled like was done in the main kernel tree.
>>>
>>> Why force this on all and not just use the same option?
>>
>> I'm really worried about backports that are significantly different
>> from the original commit.  To the point where if they are so different
>> and we don't have a grave security or data integrity bug I'm really not
>> very much in favor of backporting them at all.
>>

I do understand that backporting these patches is not good, thanks for
taking time on this patchset.

I decided to push following patch in our version:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 588e8b43efab..c047d5fcb325 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2149,12 +2149,16 @@ int dm_setup_md_queue(struct mapped_device *md, 
struct dm_table *t)

         switch (type) {
         case DM_TYPE_REQUEST_BASED:
-               md->disk->fops = &dm_rq_blk_dops;
                 r = dm_mq_init_request_queue(md, t);
                 if (r) {
                         DMERR("Cannot initialize queue for 
request-based dm mapped device");
                         return r;
                 }
+               /*
+                * Change the fops after queue is initialized, so that 
bio won't
+                * issued by rq-based path until that.
+                */
+               md->disk->fops = &dm_rq_blk_dops;
                 break;
         case DM_TYPE_BIO_BASED:
         case DM_TYPE_DAX_BIO_BASED:


This way only modify dm, and the problem can be fixed. If you guys think
this is OK, I can send a patch for LTS. Otherwise, if you guys still
think the null-ptr-def problem is uncommon and doesn't worth to fix,
please ignore this mail.

Thanks,
Kuai
> 
> I agree, I'll drop this from my review queue now, thanks.
> 
> greg k-h
> .
> 

