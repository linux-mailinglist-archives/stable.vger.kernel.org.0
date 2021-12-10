Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDFB46F9D1
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 05:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbhLJE0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 23:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbhLJE0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 23:26:21 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F36C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 20:22:47 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id n26so7391374pff.3
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 20:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0meB0MsUkfhEIH+KOJ8L5CfpM2M3gRigF5cVBJSr6L4=;
        b=mksO91VIB/o4aMEhf4ftNABEBJ9yo+5r3SMfgKFlID9PTOpZgS9rCpbjS9kkG9amkP
         LNVgeifEwFMCyqvdza5P/8NP5fBo462q9c5JeTVv2XBn8RvVqzwNJlZ/TwtJPimCDR92
         2O3a6G+Mkrynlc6M0RuzpIjUd9cih1Ck4f4qkdCYHzN+reADLCEK5XOatJwQBd0IgTPm
         g9R+ZMG7OVe43301FfJshbJvc0nX1BSnxOcdzC8DFiTOwTdOqDA4rDTL8+ywhH3hG8XO
         9PmDZyJtDKs8u14yu/RZcndIVziTQ3gCaMj4618e/Rm5hz2HVeO8EThp0X6STWhs4KpM
         PjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0meB0MsUkfhEIH+KOJ8L5CfpM2M3gRigF5cVBJSr6L4=;
        b=ZGe5m1h3Jgm0xMskg0v/TkCW4op4l95eoyQkNPvUSet/H4X1uWPBymu9fGfnQAFdz7
         aOXNElyh0X6lngRzD7/kg1rV3Io8TWlFirfyHGjy4lr+S+N0ci9O6eAdjwrIA16iQ6Rd
         qKEqluXF9JlgBgeu6PY6IxB72UH9OjZ8BChHVgk0us6LT9JGfNQwBZwoTzzOZ0mr88el
         d/NdqVnGqOzZXK9QMy97CeQKTBinKNlwhb0yZK4adSZ1hX6sezqIVHspFLQtl1rsZLEM
         dxWy/JYbzhkp+D0xubNKnCDNJ0uZJV+vITI6GaBjhvjfUeji+y//z6JxElcEJnhpyx3g
         2+yQ==
X-Gm-Message-State: AOAM530PvwGruXIDCId+LoW86zDigSqr8+FIEOUt9sietFmemS9fAIR+
        3e4ggndMYMmN+wFEg+ulaR2TG9dzs4KqFQ==
X-Google-Smtp-Source: ABdhPJwO14qcseghFWFAcnBpsPL1q4lLyLQsx+/lyRraZyetsmgRE5ZM6qtEJ2FVw55exSu+VbMS8g==
X-Received: by 2002:aa7:8386:0:b0:4b0:29bf:b0d4 with SMTP id u6-20020aa78386000000b004b029bfb0d4mr6495483pfm.26.1639110166137;
        Thu, 09 Dec 2021 20:22:46 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id lt5sm1086963pjb.43.2021.12.09.20.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 20:22:45 -0800 (PST)
Subject: Re: [PATCH v2 2/2] io_uring: ensure task_work gets run as part of
 cancelations
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20211209155956.383317-1-axboe@kernel.dk>
 <20211209155956.383317-3-axboe@kernel.dk>
 <89990fca-63d3-cbac-85cc-bce2818dd30e@kernel.dk>
 <227847a6-a76c-3942-a563-7d492b0d2ced@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bfd55851-62d8-c9ea-bc49-c94efd40b38a@kernel.dk>
Date:   Thu, 9 Dec 2021 21:22:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <227847a6-a76c-3942-a563-7d492b0d2ced@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/9/21 8:29 PM, Hao Xu wrote:
> 
> 在 2021/12/10 上午12:16, Jens Axboe 写道:
>> If we successfully cancel a work item but that work item needs to be
>> processed through task_work, then we can be sleeping uninterruptibly
>> in io_uring_cancel_generic() and never process it. Hence we don't
>> make forward progress and we end up with an uninterruptible sleep
>> warning.
>>
>> Add the waitqueue earlier to ensure that any wakeups from cancelations
>> are seen, and switch to using uninterruptible sleep so that postponed
> ^ typo

Not really a typo, but should be killed from v2 for sure. I'll do that.

-- 
Jens Axboe

