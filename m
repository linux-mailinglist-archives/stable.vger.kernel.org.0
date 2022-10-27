Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ADA60F62E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 13:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbiJ0L2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 07:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiJ0L2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 07:28:32 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2EAD994E;
        Thu, 27 Oct 2022 04:28:31 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4MyjzW6QWqz6R6CL;
        Thu, 27 Oct 2022 19:25:59 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCX8+Vaa1pjWpkbAQ--.34104S3;
        Thu, 27 Oct 2022 19:28:27 +0800 (CST)
Subject: Re: [PATCH 5.10 2/3] blk-wbt: call rq_qos_add() after wb_normal is
 initialized
To:     Greg KH <gregkh@linuxfoundation.org>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     axboe@kernel.dk, stable@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@hawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20221018014326.467842-1-yukuai1@huaweicloud.com>
 <20221018014326.467842-3-yukuai1@huaweicloud.com>
 <Y1lkvFXjEMA80AFO@kroah.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fa4a2aed-4a9e-abfa-6fcf-d402ec9a1647@huaweicloud.com>
Date:   Thu, 27 Oct 2022 19:28:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Y1lkvFXjEMA80AFO@kroah.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCX8+Vaa1pjWpkbAQ--.34104S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JFW3tr4fJw1xJF1xJw18Zrb_yoWxKrcE9F
        4qkrykGwn7Ga12vFsrAw1UXFWDKrWrJrZ8Ja4xJr13XF4rWayUXrs8tr93ZFW7tr9a9FZ0
        qrsaq3sxt3s0gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

ÔÚ 2022/10/27 0:47, Greg KH Ð´µÀ:
> On Tue, Oct 18, 2022 at 09:43:25AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> commit 8c5035dfbb9475b67c82b3fdb7351236525bf52b upstream.
> 
> I need a 5.15 version of this, and the 3/3 patch in order to be able to
> apply the 5.10.y version.
> 
> Can you please send that, and then resend the remaining patches here for
> 5.10.y?

Yes, I can do that. By the way, just to confirm:

I already saw that patch 2,3 is queued:

[PATCH 5.15 122/530] blk-wbt: call rq_qos_add() after wb_normal is 
initialized
[PATCH 5.15 519/530] blk-wbt: fix that rwb->wc is always set to 1 in 
wbt_init()

Do I still need to send a 5.15 version?

Thanks,
Kuai
> 
> thanks,
> 
> greg k-h
> .
> 

