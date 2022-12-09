Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3D8647ECC
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 08:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLIHxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 02:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIHxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 02:53:31 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B079BDA3;
        Thu,  8 Dec 2022 23:53:27 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NT3CN4KdZzRppt;
        Fri,  9 Dec 2022 15:52:32 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Dec 2022 15:53:25 +0800
Message-ID: <93d137dc-e0d3-3741-7e01-dca1ba9c0903@huawei.com>
Date:   Fri, 9 Dec 2022 15:53:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Mimi Zohar <zohar@linux.ibm.com>, <dmitry.kasatkin@gmail.com>,
        Paul Moore <paul@paul-moore.com>, <sds@tycho.nsa.gov>,
        <eparis@parisplace.org>, <sashal@kernel.org>,
        <selinux@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
 <Y5Lf8SRgyrqDJwiH@kroah.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Y5Lf8SRgyrqDJwiH@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/12/9 15:12, Greg KH wrote:
> On Fri, Dec 09, 2022 at 03:00:35PM +0800, Guozihua (Scott) wrote:
>> Hi community.
>>
>> Previously our team reported a race condition in IMA relates to LSM based
>> rules which would case IMA to match files that should be filtered out under
>> normal condition. The issue was originally analyzed and fixed on mainstream.
>> The patch and the discussion could be found here:
>> https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/
>>
>> After that, we did a regression test on 4.19 LTS and the same issue arises.
>> Further analysis reveled that the issue is from a completely different
>> cause.
> 
> What commit in the tree fixed this in newer kernels?  Why can't we just
> backport that one to 4.19.y as well?
> 
> thanks,
> 
> greg k-h

Hi Greg,

The fix for mainline is now on linux-next, commit 	d57378d3aa4d ("ima: 
Simplify ima_lsm_copy_rule") and 	c7423dbdbc9ece ("ima: Handle -ESTALE 
returned by ima_filter_rule_match()"). However, these patches cannot be 
picked directly into 4.19.y due to code difference.

The commit which introduced the issue on mainline was believed to be 
b16942455193 ("ima: use the lsm policy update notifier"), which is not 
in 4.19.y. And the mainline patch is designed to handle the situation 
when IMA rules are accessed through RCU which has not been implemented 
on 4.19.y either.

-- 
Best
GUO Zihua

