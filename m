Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697E2598FA1
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 23:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241799AbiHRVfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 17:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241023AbiHRVfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 17:35:52 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0706BC113;
        Thu, 18 Aug 2022 14:35:51 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oOnAz-000B4r-Fv; Thu, 18 Aug 2022 23:35:41 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oOnAz-000LzD-2F; Thu, 18 Aug 2022 23:35:41 +0200
Subject: Re: [PATCH bpf] bpf: Fix kernel BUG in purge_effective_progs
To:     Greg KH <gregkh@linuxfoundation.org>, Pu Lehui <pulehui@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
References: <20220813134030.1972696-1-pulehui@huawei.com>
 <CAEf4BzaciJNVP1YsuJTiS9v7wBvTpShj+kMtwkzk8ijnpL_yzw@mail.gmail.com>
 <7cbb4aa6-c576-8671-ea5e-d845a8310394@huawei.com>
 <Yv3NhNspJ0hdf55G@kroah.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4116f88f-301a-a1ea-0e35-bd356109aa7f@iogearbox.net>
Date:   Thu, 18 Aug 2022 23:35:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <Yv3NhNspJ0hdf55G@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26631/Thu Aug 18 09:52:06 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/22 7:26 AM, Greg KH wrote:
> On Thu, Aug 18, 2022 at 10:46:33AM +0800, Pu Lehui wrote:
>> On 2022/8/17 4:39, Andrii Nakryiko wrote:
>>> On Sat, Aug 13, 2022 at 6:11 AM Pu Lehui <pulehui@huawei.com> wrote:
[...]
>>>> Failslab injection will cause kmalloc fail and fall back to
>>>> purge_effective_progs. The problem is that cg2 have attached another prog,
>>>> so when go through cg2 layer, iteration will add pos to 1, and subsequent
>>>> operations will be skipped by the following condition, and cg will meet
>>>> NULL in the end.
>>>>
>>>> `if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))`
>>>>
>>>> The NULL cg means no link or prog match, this is as expected, and it's not
>>>> a bug. So here just skip the no match situation.
>>>>
>>>> Fixes: 4c46091ee985 ("bpf: Fix KASAN use-after-free Read in compute_effective_progs")
>>>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>>>> ---
>>>>    kernel/bpf/cgroup.c | 4 +++-
>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
>>>> index 59b7eb60d5b4..4a400cd63731 100644
>>>> --- a/kernel/bpf/cgroup.c
>>>> +++ b/kernel/bpf/cgroup.c
>>>> @@ -921,8 +921,10 @@ static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
>>>>                                   pos++;
>>>>                           }
>>>>                   }
>>>> +
>>>> +               /* no link or prog match, skip the cgroup of this layer */
>>>> +               continue;
>>>>    found:
>>>> -               BUG_ON(!cg);
>>>
>>> I don't think it's necessary to remove this BUG_ON(), but it also
>>> feels unnecessary for purge_effective_progs, so I don't mind it.
>>>
>>> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>>
>> Will this patch be accepted? I think we should CC stable.

Stable will pick this up given Fixes tag. We were pinging also original patch author,
Tadeusz, for an ACK to include in commit msg, but looks he's unresponsive ... anyway,
applied, thanks!
