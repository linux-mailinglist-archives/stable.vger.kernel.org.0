Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C307F37FD66
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 20:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhEMStM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 14:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbhEMStI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 14:49:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B31DC061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 11:47:58 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g24so14000517pji.4
        for <stable@vger.kernel.org>; Thu, 13 May 2021 11:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PyqVZjhU3w3jlGH8tofKMsn18YbEqFAInYWIcup7lgc=;
        b=KaDbEFpbTmQwJ78uwOgMpBb8HgWbHi9GXs7DXWgNGcTC4yyVgDasPWvb6ZCh59GMIT
         aqgkFIOS0/4a1vdRWkDi1IkrSLFcSVAYytJOhIQaLMtHLACzrA38/GLCLH8ryNJZyGWH
         lRrWp5sDXTM1AFRsz3lVcGlOTXq8rOWMIEg3ZNUaEaE5r0utPu9yzYeI1zLpPUCXsHAc
         76IVycFznz/D8UvT/UbqfwHZ/FsuxO5rci4Dt2gfRqa20L6V5GgL41CG8yHoKTNumk6V
         /1qc9RpdqS5bgIWPeKtS6HRSNUhlLYnXF/yVVdjA4FRdWLmqivr1eadmIrFGfOL7ljKq
         GZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PyqVZjhU3w3jlGH8tofKMsn18YbEqFAInYWIcup7lgc=;
        b=duNQxlCQVOgmAFupBwSLZAmBUnV4ZF8wel9wqB3oBldLvGwKkB8LWwXRjbht6X8S4B
         YAoG6qncdrAS1hGGN7NqqkHsNQScSP0V1dFsVgiMg+MkRZNVHynbnupJ+gWpjGd6plHt
         HKRfj1eQVzGQvRVlJRIXgl55UNbTlIV8ZWiyTwM1ch27B++q7nJmlxw5/N6ncvRSQbHb
         UcgLu3lw5sYkV6dnozj+mtoWe28ym1iN/B0uWWwKyfk02dkaHNe4hlSFxpYBJSuJ4uK9
         MBzYr2tVI7A2C59VNTTk9RqQsh3BzoaqbgDSZaxzA9PeVT6OD07FrV8qbF2OXnGdserr
         I38A==
X-Gm-Message-State: AOAM531vB9x0y3hW7bWqIawp2Vhp1EyzI0CWLNbGrccTI3QtRLZ4dFNQ
        rJY7Y8nqq/dMyMi9m8ssqUfULXpCir4=
X-Google-Smtp-Source: ABdhPJyhqv97qDa+bdraDFsRL1P4vK8MiJCW7EIiexhPvc25HFsYbWT8v8+Kqx8KLHbgFub/CtkPnw==
X-Received: by 2002:a17:90a:5d8e:: with SMTP id t14mr47422429pji.85.1620931677449;
        Thu, 13 May 2021 11:47:57 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h21sm3189947pjz.4.2021.05.13.11.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 11:47:57 -0700 (PDT)
Subject: Re: [PATCH] nvme-fc: clear q_live at beginning of association
 teardown
To:     Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org
References: <20210511045635.12494-1-jsmart2021@gmail.com>
 <601fa5a1-e52b-edf1-f32e-b1c454e23758@grimberg.me>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <f26aad29-aef7-6fd9-979b-a0bfc4f46a06@gmail.com>
Date:   Thu, 13 May 2021 11:47:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <601fa5a1-e52b-edf1-f32e-b1c454e23758@grimberg.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/12/2021 4:03 PM, Sagi Grimberg wrote:
> 
>> The __nvmf_check_ready() routine used to bounce all filesystem io if
>> the controller state isn't LIVE. However, a later patch changed the
>> logic so that it rejection ends up being based on the Q live check.
>> The fc transport has a slightly different sequence from rdma and tcp
>> for shutting down queues/marking them non-live. FC marks its queue
>> non-live after aborting all ios and waiting for their termination,
>> leaving a rather large window for filesystem io to continue to hit the
>> transport. Unfortunately this resulted in filesystem io or applications
>> seeing I/O errors.
>>
>> Change the fc transport to mark the queues non-live at the first
>> sign of teardown for the association (when i/o is initially terminated).
> 
> Sounds like the correct behavior to me, what is the motivation for doing
> that only after all I/O was aborted?
> 
> And,
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

source evolution over time (rdma/tcp changed how they worked) and the 
need didn't show up earlier based on the earlier checks.

-- james

