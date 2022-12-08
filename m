Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B9F647046
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 13:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLHM7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 07:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiLHM7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 07:59:32 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDC08C44A;
        Thu,  8 Dec 2022 04:59:30 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NSZ3v4tGlz4f3pFV;
        Thu,  8 Dec 2022 20:59:23 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgC329is35Fj97d8Bw--.45128S3;
        Thu, 08 Dec 2022 20:59:26 +0800 (CST)
Subject: Re: [PATCH 3/9] bfq: Split shared queues on move between cgroups
To:     Jan Kara <jack@suse.cz>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-block@vger.kernel.org,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20220330123438.32719-1-jack@suse.cz>
 <20220330124255.24581-3-jack@suse.cz>
 <89941655-baeb-9696-dc89-0a1f4bc9e8d6@huaweicloud.com>
 <20221208093733.izj7irhzspmvpxxc@quack3>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5a712ac6-e6c7-0008-bee7-2383cc684c73@huaweicloud.com>
Date:   Thu, 8 Dec 2022 20:59:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221208093733.izj7irhzspmvpxxc@quack3>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgC329is35Fj97d8Bw--.45128S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AFy3JF4xXFyUWF1DWw4DJwb_yoW8XFW5pF
        W3ta4Skr18G3yakw17ur4rJF10qa1fJF43JryFqr1kZrn5Ary8tFnxtFn5XrWFq34v93s2
        qw18trsrJFs7Za7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

在 2022/12/08 17:37, Jan Kara 写道:
> 
> So if this state happens, it would be indeed a problem. But I don't see how
> it could happen. bics are associated with the process. So t1 will always
> use bic1, t2 will always use bic2. In bfq_init_rq() we get bfqq either from
> bic (so it would return bfqq3 for bic1) or we allocate a new queue (that
> would be some bfqq4). So I see no way how bfqq2 could start pointing to
> bic1...


> 
> 								Honza
>

Following is possible scenarios that we derived:

1) Initial state, two process with io.

Process 1       Process 2
  (BIC1)          (BIC2)
   |  Λ           |  Λ
   |  |            |  |
   V  |            V  |
   bfqq1           bfqq2

2) bfqq1 is merged to bfqq2, now bfqq2 has two process ref, bfqq2->bic
    will not be set.

Process 1       Process 2
  (BIC1)          (BIC2)
   |               |
    \-------------\|
                   V
   bfqq1           bfqq2(coop)

3) Process 1 exit, then issue io(denoted IOA) from Process 2.

Process 2
  (BIC1)
   |  Λ
   |  |
   V  |
bfqq2(coop)

4) Before IOA completed, move Process 2 to another cgroup and issue
    io.

Process 2
  (BIC2)
    Λ
    |\--------------\
    |                V
bfqq2(coop)      bfqq3

Now that BIC2 point to bfqq3, while bfqq2 and bfqq3 both point to BIC2.

5) If all the io are completed and Process 2 exit, BIC2 will be freed,
    while bfqq2 still ponits to BIC2.

It's easy to construct such scenario, however, I'm not able to trigger
such UAF yet. It seems hard to let bfqq2 become in_service_queue again
and access bfqq2->bic in bfq_select_queue.

While I'm organizing the above procedures, I realized that my former
solution is wrong. Now I think that the right thing to do is to also
clear bfqq->bic while process ref is decreased to 0.

Thanks,
Kuai

