Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E5F3014C2
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 11:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbhAWKwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 05:52:02 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:43889 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbhAWKul (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 05:50:41 -0500
Received: by mail-lf1-f50.google.com with SMTP id q8so11094034lfm.10;
        Sat, 23 Jan 2021 02:50:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zVtzOXy111hZzS7DNzuLSWnU2lMa2r2x+PxOQ/YVca4=;
        b=toBczwKmvAWsCyMH/Wqi9eFuqf8aih+4vl9SeX9GEbESN438nF/43uMBXvA0paWD2R
         bAYtn8RZxmdk2VN0lWoU8bOmczakc2dBAkBcX8cK/LBUQmdXzOuHR+U+Rx8FeYrM8Ed/
         iOSxzCPquWXIE89x2SetMg4bZ1K8C+2+xzxtgtcZV1q0FPh4RuF4uJCI1C7pb0Pa1fys
         7nZ+2SxiLRHHd1jW0p/KPZvTvqh7SGzVSRQ9tnwGJUZkCOjZWcCyes5o4UxCdg4eZSOj
         TvwCVQNLIwZ2iYRHaXYD+Jrjjq32mqN6Hwfl8TmFXsBuhuUUQN9a65vzt/z30dFw2wmg
         BEUg==
X-Gm-Message-State: AOAM530ZwaJgAQcOwv+c3qgcIpDlzx8J4/619lqByf3Kk/ssamhsN5Sk
        SX8jwyPz4CiP1TaQsQRHPzI9jeS+VP2pCQ==
X-Google-Smtp-Source: ABdhPJyXEOeG9lIeGkea26EE+UeWSQqKD72haCcpKdT05oKuTqAeMd9qirinCSiyHuv/X3vaHGkbyw==
X-Received: by 2002:a05:6512:70d:: with SMTP id b13mr240174lfs.639.1611398999440;
        Sat, 23 Jan 2021 02:49:59 -0800 (PST)
Received: from [10.68.32.192] (broadband-188-32-236-56.ip.moscow.rt.ru. [188.32.236.56])
        by smtp.gmail.com with ESMTPSA id j15sm1162793lfb.13.2021.01.23.02.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 02:49:58 -0800 (PST)
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
To:     Steven Rostedt <rostedt@goodmis.org>,
        Gaurav Kohli <gkohli@codeaurora.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Julia Lawall <julia.lawall@inria.fr>
References: <1601976833-24377-1-git-send-email-gkohli@codeaurora.org>
 <f06efd7b-c7b5-85c9-1a0e-6bb865111ede@linux.com>
 <20210121140951.2a554a5e@gandalf.local.home>
 <021b1b38-47ce-bc8b-3867-99160cc85523@linux.com>
 <20210121153732.43d7b96b@gandalf.local.home> <YAqwD/ivTgVJ7aap@kroah.com>
 <8e17ad41-b62b-5d39-82ef-3ee6ea9f4278@codeaurora.org>
 <20210122093758.320bb4f9@gandalf.local.home>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <5959315a-507a-00df-031a-e60d45c1f7ab@linux.com>
Date:   Sat, 23 Jan 2021 13:49:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210122093758.320bb4f9@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/22/21 5:37 PM, Steven Rostedt wrote:
> On Fri, 22 Jan 2021 16:55:29 +0530
> Gaurav Kohli <gkohli@codeaurora.org> wrote:
> 
>>>> That could possibly work.  
>>
>> Yes, this will work, As i have tested similar patch for internal testing 
>> for kernel branches like 5.4/4.19.
> 
> Can you or Denis send a proper patch for Greg to backport? I'll review it,
> test it and give my ack to it, so Greg can take it without issue.
> 

I can prepare the patch, but it will be compile-tested only from my side. Honestly,
I think it's better when the patch and its backports have the same author and
commit message. And I can't test the fix by myself as I don't know how to reproduce
conditions for the bug. I think it's better if Gaurav will prepare this backport,
unless he have reasons for me to do it or maybe just don't have enough time nowadays.
Gaurav, if you want to somehow mention me you add my Reported-by:

Thanks,
Denis

