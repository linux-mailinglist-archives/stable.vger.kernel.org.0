Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4790061A54F
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 00:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiKDXDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 19:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiKDXDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 19:03:37 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D49CF3;
        Fri,  4 Nov 2022 16:03:33 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1or5ij-000LG1-6w; Sat, 05 Nov 2022 00:03:29 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1or5ii-000LUC-RY; Sat, 05 Nov 2022 00:03:28 +0100
Subject: Re: [PATCH] bpf: mark get_entry_ip as __maybe_unused
To:     Jonas Rabenstein <rabenstein@cs.fau.de>, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>, Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
References: <20221103150303.974028-1-rabenstein@cs.fau.de>
 <20221103153247.zal3czlsxvanfnc3@kashyyyk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ec1ac9cb-f92c-9a2f-3a6c-bfc4bc88ab11@iogearbox.net>
Date:   Sat, 5 Nov 2022 00:03:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20221103153247.zal3czlsxvanfnc3@kashyyyk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26710/Fri Nov  4 08:53:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/3/22 4:32 PM, Jonas Rabenstein wrote:
> Hi again,
> after sending this out, I noticed this is only a problem in the stable
> versions (starting from v6.0.3), as c09eb2e578eb1668bbc has been applied (as
> 03f148c159a250dd454) but not 0e253f7e558a3e250902 ("bpf: Return value in kprobe
> get_func_ip only for entry address") which makes always use of get_entry_ip.
> I therefore think, 0e253f7e558a3e250902 needs to be added to the stable v6.0
> series as well as otherwise it can't be compiled with -Werror if
> CONFIG_X6_KERNEL_IBT is set but CONFIG_FPROBE isn't.

Thanks for the info, Jonas. Added Greg wrt stable cherry-pick.

> On Thu, Nov 03, 2022 at 04:03:03PM +0100, Jonas Rabenstein wrote:
>> Commit c09eb2e578eb1668bbc ("bpf: Adjust kprobe_multi entry_ip
>> for CONFIG_X86_KERNEL_IBT") introduced the get_entry_ip() function.
>> Depending on CONFIG_X86_KERNEL_IBT it is a static function or only
>> a macro definition. The only user of this symbol so far is in
>> kprobe_multi_link_handler() if CONFIG_FPROBE is enabled.
>> If CONFIG_FROBE is not set, the symbol is not used and - depending
>> on CONFIG_X86_KERNEL_IBT - a warning for get_entry_ip() is emitted.
>> To solve this, the function should be marked as __maybe_unused.
>>
>> Signed-off-by: Jonas Rabenstein <rabenstein@cs.fau.de>
>> ---
>>   kernel/trace/bpf_trace.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index f2d8d070d024..19131aae0bc3 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -1032,7 +1032,7 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
>>   };
>>   
>>   #ifdef CONFIG_X86_KERNEL_IBT
>> -static unsigned long get_entry_ip(unsigned long fentry_ip)
>> +static unsigned long __maybe_unused get_entry_ip(unsigned long fentry_ip)
>>   {
>>   	u32 instr;
>>   
>> -- 
>> 2.37.4
>>

