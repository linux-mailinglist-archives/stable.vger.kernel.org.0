Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FD1693355
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 20:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjBKTgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 14:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBKTgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 14:36:04 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDAA13D5A;
        Sat, 11 Feb 2023 11:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1676144159;
        bh=X8knHpoimUB5H2YCe5gnr8bZyGA1s3Wx5QnDzE7u3Ts=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=V3x7tz+D/AW5mdaYhub6zT12ESZZCVqnaHGKo/h27E+YI6IqJYFL6Ls9eUihRpBWR
         zn41teQaNYBUSAtCnblnj/6xinO8OyrL/eneu7RLOeKEh/z/AdWjzxtntQO+8anwOj
         pDFYXOZ5FO6FWOUVQjt8fqU0c6k5+OUfG/8NE74N/3iqK7XHjvju1wtEcGLvJTI5nb
         KOb8zcYjzJQmy+6HkIpN1h/KCshGld2pjf2RYU/t45ltwB1iLoYpnL7Z3BSahI2HTL
         4tqIRGDlvGLAYRICipeffwf+o97Rx/eBeTr+yKQHhcfyeSgOJi44/bE+K9AOsc56fX
         XPhnksxhBQYtw==
Received: from [10.1.0.205] (192-222-188-97.qc.cable.ebox.net [192.222.188.97])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4PDgnW3pgWzlVY;
        Sat, 11 Feb 2023 14:35:59 -0500 (EST)
Message-ID: <6116571c-986b-cdcf-1da8-3ba2ef145f6e@efficios.com>
Date:   Sat, 11 Feb 2023 14:35:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH -trace] trace: fix TASK_COMM_LEN in trace event format
 file
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, mhiramat@kernel.org,
        linux-trace-kernel@vger.kernel.org,
        John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        stable@vger.kernel.org
References: <20230210155921.4610-1-laoar.shao@gmail.com>
 <32e0332a-4ef4-bfe3-129e-50afa989a151@efficios.com>
 <20230211143445.51b49a50@gandalf.local.home>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20230211143445.51b49a50@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-02-11 14:34, Steven Rostedt wrote:
> On Fri, 10 Feb 2023 11:27:18 -0500
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>>> --- a/include/trace/stages/stage4_event_fields.h
>>> +++ b/include/trace/stages/stage4_event_fields.h
>>> @@ -26,7 +26,8 @@
>>>    #define __array(_type, _item, _len) {					\
>>>    	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
>>
>> Just out of curiosity, is the content of __stringify(_len) ever used
>> after this patch ? Perhaps we could remove it and just leave:
>>
>> .type = #_type"[]"
>>
>> considering that f_show appears to use the opening square bracket to
>> detect arrays. This would remove a few useless bytes of data.
> 
> I agree that we can optimize this. But lets make that a separate patch, and
> not worry about it for this. That's a clean up that can be handled later.
> 
> I'd like to not add any more side effects than it may already have.

Fully agreed, hence my "just out of curiosity". :)

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

