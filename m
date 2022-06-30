Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6908561635
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 11:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiF3JVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 05:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbiF3JVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 05:21:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10C340E56;
        Thu, 30 Jun 2022 02:21:27 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LYXpS3qvtzkWdj;
        Thu, 30 Jun 2022 17:19:28 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 17:21:21 +0800
Received: from [10.67.110.218] (10.67.110.218) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 17:21:21 +0800
Message-ID: <0a05d98f-96f6-ffee-87bf-ba9e0231bde4@huawei.com>
Date:   Thu, 30 Jun 2022 17:21:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH] tracing/histograms: Simplify create_hist_fields()
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <rostedt@goodmis.org>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <tom.zanussi@linux.intel.com>,
        <trix@redhat.com>, <stable@vger.kernel.org>,
        <zhangjinhao2@huawei.com>
References: <20220630013152.164871-1-zhengyejian1@huawei.com>
 <Yr1DtC4Gvg00SVfr@kroah.com>
From:   "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>
Reply-To: <Yr1DtC4Gvg00SVfr@kroah.com>
In-Reply-To: <Yr1DtC4Gvg00SVfr@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.218]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/6/30 14:33, Greg KH wrote:
> On Thu, Jun 30, 2022 at 09:31:52AM +0800, Zheng Yejian wrote:
>> When I look into implements of create_hist_fields(), I think there can be
>> following two simplifications:
>>    1. If something wrong happened in parse_var_defs(), free_var_defs() would
>>       have been called in it, so no need goto free again after calling it;
>>    2. After calling create_key_fields(), regardless of the value of 'ret', it
>>       then always runs into 'out: ', so the judge of 'ret' is redundant.
>>
>> No functional changes.
>>
>> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
>> ---
>>   kernel/trace/trace_events_hist.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
>> index 2784951e0fc8..832c4ccf41ab 100644
>> --- a/kernel/trace/trace_events_hist.c
>> +++ b/kernel/trace/trace_events_hist.c
>> @@ -4454,7 +4454,7 @@ static int create_hist_fields(struct hist_trigger_data *hist_data,
>>   
>>   	ret = parse_var_defs(hist_data);
>>   	if (ret)
>> -		goto out;
>> +		return ret;
>>   
>>   	ret = create_val_fields(hist_data, file);
>>   	if (ret)
>> @@ -4465,8 +4465,7 @@ static int create_hist_fields(struct hist_trigger_data *hist_data,
>>   		goto out;
>>   
>>   	ret = create_key_fields(hist_data, file);
>> -	if (ret)
>> -		goto out;
>> +
>>    out:
>>   	free_var_defs(hist_data);
>>   
>> -- 
>> 2.32.0
>>
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:

This patch is a cleanup, no need to include in stable kernel tree.
I accidentally copied the patch to stable mailbox, sorry for that :(

>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
