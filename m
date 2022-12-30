Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06D865955A
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 07:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiL3GSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 01:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbiL3GSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 01:18:41 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F083AFAEB;
        Thu, 29 Dec 2022 22:18:37 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Njw5n1KKjz16LwK;
        Fri, 30 Dec 2022 14:17:17 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 30 Dec 2022 14:18:35 +0800
Message-ID: <80260e5c-51c9-ec97-c546-ddde0c302e62@huawei.com>
Date:   Fri, 30 Dec 2022 14:18:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH 2/2] ima: Handle -ESTALE returned by
 ima_filter_rule_match()
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <paul@paul-moore.com>,
        <linux-integrity@vger.kernel.org>, <luhuaxin1@huawei.com>
References: <20221227014729.4799-1-guozihua@huawei.com>
 <20221227014729.4799-3-guozihua@huawei.com> <Y6qgqO/LJ/wHUk5x@kroah.com>
 <d65e2d46bf41e3d58c0fa18bd274faf20dadb523.camel@linux.ibm.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <d65e2d46bf41e3d58c0fa18bd274faf20dadb523.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Mimi.

Fall sick for a couple days.

On 2022/12/27 19:56, Mimi Zohar wrote:
> On Tue, 2022-12-27 at 08:37 +0100, Greg KH wrote:
>> On Tue, Dec 27, 2022 at 09:47:29AM +0800, GUO Zihua wrote:
>>> [ Upstream commit c7423dbdbc9ecef7fff5239d144cad4b9887f4de ]
>>
>> For obvious reasons we can not only take this patch (from 6.2-rc1) into
>> 4.19.y as that would cause people who upgrade from 4.19.y to a newer
>> stable kernel to have a regression.
>>
>> Please submit backports for all stable kernels if you wish to see this
>> in older ones to prevent problems like this from happening.
> 
> Sasha has already queued the original commit and the dependencies for
> the 6.1, 6.0, and 5.15 stable kernels.  Those kernels all had the
> call_lsm_notifier() to call_blocking_lsm_notifier() change.  Prior to
> 5.3, the change to the blocking notifier would need to be backported as
> well.  This version of the backport still needs to be reviewed.
Indeed the current solution needs further testing and review. One of the
concern raised by Huaxin is a possible UAF caused by the call to free
rule in update_rule. Will it be possible to backport also the change
which turn call_lsm_notifier() into call_blocking_lsm_notifier()?
> 
> thanks,
> 
> Mimi
> 
>>
>> But also, why are you still on 4.19.y?  What is wrong with 5.4.y at this
>> point in time?  If we dropped support for 4.19.y in January, what would
>> that cause to happen for your systems?
Well it's all about backward compatibility. We still got some products
using the 4.19.y LTS kernel and we would still needs to provide support
for this version of the kernel. If 4.19.y got EOL or EOS in January next
year, our company surely would develop corresponding plans to handle
that change.
>>
>> thanks,
>>
>> greg k-h
>>
> 

-- 
Best
GUO Zihua

