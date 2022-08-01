Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2235C586218
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 02:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbiHAA70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 20:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiHAA7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 20:59:25 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E176710FDD;
        Sun, 31 Jul 2022 17:59:23 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Lx09B57WLzKHqx;
        Mon,  1 Aug 2022 08:58:06 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgDHRzFoJedisZg3AA--.46883S3;
        Mon, 01 Aug 2022 08:59:21 +0800 (CST)
Subject: Re: [PATCH stable 4.19 0/1] fix io hung for scsi
To:     Greg KH <gregkh@linuxfoundation.org>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     stable@vger.kernel.org, ming.lei@redhat.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20220730084651.4093719-1-yukuai1@huaweicloud.com>
 <YuZdjxjYIo5N2qMw@kroah.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a14d3a17-f9df-2075-9f23-267f018f3ccd@huaweicloud.com>
Date:   Mon, 1 Aug 2022 08:59:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YuZdjxjYIo5N2qMw@kroah.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgDHRzFoJedisZg3AA--.46883S3
X-Coremail-Antispam: 1UD129KBjvdXoWrJr15Ar4kuFy7WrWfuF43GFg_yoWxArc_Za
        4qvrWxuwnrAan2qa15tr98trZxGa98trWDJr9rGr47JF1rGr98XFsFv3sY9F18JFZYgF93
        G3ySqa97urn8KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
        3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
        VFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg

ÔÚ 2022/07/31 18:46, Greg KH Ð´µÀ:
> On Sat, Jul 30, 2022 at 04:46:50PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> One of our product reported a io hung problem, turns out the problem
>> can be fixed by the patch.
>>
>> I'm not sure why this patch is not backported yet, however, please
>> consider it in 4.19 lts.
> 
> It was not backported as it did not apply as-is.  Can you also provide a
> version for 5.4.y so that if someone were to upgrade to a newer kernel
> version, they would not have a regression?  Once we have that, then we
> can accept this 4.19.y version.
> 
Of courest, thanks for your notice.

Kuai
> thanks,
> 
> greg k-h
> .
> 

