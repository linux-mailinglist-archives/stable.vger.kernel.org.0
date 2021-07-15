Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941DA3CA171
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 17:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238690AbhGOPau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 11:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhGOPat (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 11:30:49 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB85C061760
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 08:27:56 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so6535941otq.11
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 08:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Ds+bjf4PfC5bkHeufgUSDHW7WzmtQEzph79Y9c1bnI=;
        b=wrUsu36HrQdl+V7iK7ZHXGh+4F7c8wbFcjZL3//oQHTOw8l/GCCxfy4z89+/0Q7hMl
         G3q1mXMeOGTxJfu6XPnJGMJq81B49B5/3AgqtLOOEDvcIP/6crj0gXUCRZQxI6uQ72df
         JQaRz+6WQmhnxiEygMEEIP3IBQphJACO4NPiJ9LnrSxY/o726btX7I6uAq9MftR0ukkH
         hccp9q+KbKGEiGnN8Op7oC94xl/XL6V/R20fPrhsGvH8UtizCZyHd0B5PETdQe7GljXT
         Hx7rCnkPH21oh5En8qyckiYVXCo4ErPD0GPVj/8XXx0/nd23NKHY9E6YgFKKw04kDAPX
         O0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Ds+bjf4PfC5bkHeufgUSDHW7WzmtQEzph79Y9c1bnI=;
        b=RS1ggVUKp6wiwVT4xs5WUl0TF46D4ZQdBUY9Iu5u22rtPQpZ80rgS2Dqg8p/+g2fjz
         9NfdtxHhnjPK4bLowidrGCvgb40tJtwq/i60sKYeH/PY6a6dqBOy5uzkB0jQJhoBrxnl
         81NIDlJsETrQEfCgU20SEK3pdGFeYmg7VKStR5LSo5QRN3Mtc++Py2quBY6d/JAda6Z1
         Slr1H7OQlMuzQuhpWSz0DAqSNiy9Ncdi18xb+MaIVt1u81P3hP2zM1VYEakGvO6RsJwl
         mKsmWLnzqmsCrh+x0MYUaf51yanXalnpWDvelWrpGxSqIBh3jM8ervGdL611EYmPEM66
         iP5w==
X-Gm-Message-State: AOAM533DYGInChwXbMLyzDCIlg7O389i0l3KkWcI7tbys5iC1G8sY+XR
        JU1nuYAAoS/vnxKc4FGMufdQI/cUOU6imQ==
X-Google-Smtp-Source: ABdhPJwBhTMxIAVGPIlv3Hn+mnmRz9ROUHjlWhdzsEg4nEHfoNurmtDg6LRKABg7fz6E19dZE9KWbw==
X-Received: by 2002:a9d:4e03:: with SMTP id p3mr4201481otf.214.1626362875425;
        Thu, 15 Jul 2021 08:27:55 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r9sm1128074oos.7.2021.07.15.08.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 08:27:55 -0700 (PDT)
Subject: Re: [PATCH stable-5.10] io_uring: fix clear IORING_SETUP_R_DISABLED
 in wrong function
To:     Greg KH <gregkh@linuxfoundation.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210715131825.2410912-1-yangyingliang@huawei.com>
 <YPA2kfnTb5VtSTMm@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2d9aa268-fd78-17ec-df0f-00daa1138a72@kernel.dk>
Date:   Thu, 15 Jul 2021 09:27:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YPA2kfnTb5VtSTMm@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/21 7:22 AM, Greg KH wrote:
> On Thu, Jul 15, 2021 at 09:18:25PM +0800, Yang Yingliang wrote:
>> In commit 3ebba796fa25 ("io_uring: ensure that SQPOLL thread is started for exit"),
>> the IORING_SETUP_R_DISABLED is cleared in io_sq_offload_start(), but when backport
>> it to stable-5.10, IORING_SETUP_R_DISABLED is cleared in __io_req_task_submit(),
>> move clearing IORING_SETUP_R_DISABLED to io_sq_offload_start() to fix this.
>>
>> Fixes: 6cae8095490ca ("io_uring: ensure that SQPOLL thread is started for exit")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>  fs/io_uring.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I need an ack from Jens before I can take this...

Ack, that looks like a bad merge. Fine to apply this patch, thanks.

-- 
Jens Axboe

