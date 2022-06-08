Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C1054309A
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 14:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbiFHMjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 08:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239345AbiFHMjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 08:39:05 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B777C2CDB2E;
        Wed,  8 Jun 2022 05:39:03 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nyuxS-0008jR-SU; Wed, 08 Jun 2022 14:38:46 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nyuxR-000O0f-W8; Wed, 08 Jun 2022 14:38:46 +0200
Subject: Re: [PATCH] tracing/kprobes: Check whether get_kretprobe() returns
 NULL in kretprobe_dispatcher()
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <165366693881.797669.16926184644089588731.stgit@devnote2>
 <0204f480-cdb0-e49f-9034-602eced02966@iogearbox.net>
 <7619DB57-C39B-4A49-808C-7ACF12D58592@goodmis.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d28e1548-98fb-a533-4fdc-ae4f4568fb75@iogearbox.net>
Date:   Wed, 8 Jun 2022 14:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <7619DB57-C39B-4A49-808C-7ACF12D58592@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26566/Wed Jun  8 10:05:45 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/31/22 12:00 AM, Steven Rostedt wrote:
> On May 30, 2022 9:33:23 PM GMT+02:00, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 5/27/22 5:55 PM, Masami Hiramatsu (Google) wrote:
>>> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
>>>
>>> There is a small chance that get_kretprobe(ri) returns NULL in
>>> kretprobe_dispatcher() when another CPU unregisters the kretprobe
>>> right after __kretprobe_trampoline_handler().
>>>
>>> To avoid this issue, kretprobe_dispatcher() checks the get_kretprobe()
>>> return value again. And if it is NULL, it returns soon because that
>>> kretprobe is under unregistering process.
>>>
>>> This issue has been introduced when the kretprobe is decoupled
>>> from the struct kretprobe_instance by commit d741bf41d7c7
>>> ("kprobes: Remove kretprobe hash"). Before that commit, the
>>> struct kretprob_instance::rp directly points the kretprobe
>>> and it is never be NULL.
>>>
>>> Reported-by: Yonghong Song <yhs@fb.com>
>>> Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
>>
>> Steven, I presume you'll pick this fix up?
> 
> I'm currently at Embedded/Kernel Recipes, but yeah, I'll take a look at it. (Just need to finish my slides first ;-)

Ok, thanks. If I don't hear back I presume you'll pick it up then.
