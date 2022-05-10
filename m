Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8CE520DE7
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 08:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbiEJGgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 02:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237145AbiEJGgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 02:36:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D7D2300FE;
        Mon,  9 May 2022 23:32:40 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ky7SG0p7RzGpfb;
        Tue, 10 May 2022 14:29:50 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 10 May 2022 14:32:06 +0800
Received: from [127.0.0.1] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 10 May
 2022 14:32:06 +0800
Message-ID: <f52be1d0-dbfe-2177-8a4c-1d4e1470d908@huawei.com>
Date:   Tue, 10 May 2022 14:32:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 v3] locking/csd_lock: fix csdlock_debug cause arm64
 boot panic
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arch@vger.kernel.org>, <stable@vger.kernel.org>,
        <peterz@infradead.org>, <tglx@linutronix.de>, <namit@vmware.com>,
        <gor@linux.ibm.com>, <rdunlap@infradead.org>, <sashal@kernel.org>
References: <20220507084510.14761-1-chenzhongjin@huawei.com>
 <YnZAO+3Rhj0gwq38@kroah.com>
 <e8715911-f835-059d-27f8-cc5f5ad30a07@huawei.com>
 <YnjpljvWncezV0G0@kroah.com>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <YnjpljvWncezV0G0@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/5/9 18:14, Greg KH wrote:
> 
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
> 
> A: No.
> Q: Should I include quotations after my reply?
> 
> http://daringfireball.net/2007/07/on_top

Sorry for this. Thanks so much you point it out before I make more mistakes.

> 
> On Mon, May 09, 2022 at 11:14:12AM +0800, Chen Zhongjin wrote:
>> Hi Greg,
>>
>> Since the patch:
>> https://lore.kernel.org/all/20210420093559.23168-1-catalin.marinas@arm.com/
>> has forced CONFIG_SPARSEMEM_VMEMMAP=y from 5.12, it's not necessary to include
>> this patch on master.
>>
>> However this problem still exist on 5.10 stable, so either we can backport the
>> above patch to 5.10, or independently apply mine.
>>
>> I'm not sure if backporting one exist patch is better, but that patch only
>> changed configs without any fix for old builds.
>>
>> If you have any advice please tell me.
> 
> If you want to include a patch in the stable tree that is NOT in Linus's
> tree, then you need to document it very very well as to why this is not
> the case.
> 
> If backporting the above commit is better, I would much rather do that,
> please ask the maintainers and developers of it if they will do that.

I'll try to send this patch to master because I found it is broken on ppc64 for
this problem as well. Also I'll add CC to stable so after it is accepted by
master we can backport it to stable.

Thanks!

> thanks,
> 
> greg k-h
> .

