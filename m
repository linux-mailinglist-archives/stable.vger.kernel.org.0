Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D08C32039C
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 04:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBTDyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 22:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhBTDyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 22:54:15 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E13C061786
        for <stable@vger.kernel.org>; Fri, 19 Feb 2021 19:53:35 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id j1so3305478pgh.4
        for <stable@vger.kernel.org>; Fri, 19 Feb 2021 19:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hZR7MYcyzR0lcQH8kosfx6j4kgro3Q43EOJj2Z739Y0=;
        b=Y6k/CbQHHgOVORsf0NCEnmi8vi9FJSzGgNfnvMnWY4vKoLQDL1d+fMI8ZXEN+Ghev8
         94uUc9GxkS2NygXctSB42Lp7AHYTnxOMvtV51vGuk/s3fX6DPh+zPf4wBgNDgCgnbDj+
         o3KoGL72GvbWVLYvlI0I6gYlg7X0AV93SdCixaxc/OSsi8EaVhGTYbPxyw3/D4Ay4pYe
         PIFEk9J7mSXSAx3fSR/5qRwLZ1T2qlviGQJI7zLZ3pyuBdXy2+YFv2kj3rxqIpzrpur2
         F7grt/Y4XODoKDyTxSbVrvhX4wsGC/qJuPTOGuO/AcmMujUC46oMO0WGnSZwwzuK9dHP
         2V5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hZR7MYcyzR0lcQH8kosfx6j4kgro3Q43EOJj2Z739Y0=;
        b=mEfZ9Ym3Cc9qJSPFS/4GKu2IZqCLGAHqXfolfTmcuwlr2t6aSAXObqp4n/TKYW749y
         DypL8ALdUUijLfuPR4dtwtSKkExu4vVLXkQzFiNxJLri9Ty5zylXkJKDdSZoLQjt3tfT
         Z1R4mOnbHlNb05cLQTjG+jqUPwE0JYjrhuJtctiAYwVVuyWydUfE4vpmiQEYImcuaYQt
         2j8nqUTqqV2iPtzfiOBs5Q2QFto/8mBdcXsm5UlO7Q9nnA/Qv3A1phConS4VgqWJxz+f
         JgvSUlKY0oU5Ctq7su/SfxNwHhJ4UFxRfiruRuoA0kUG6BSna1WeIrjGMoRk3e+kU+9z
         sCqw==
X-Gm-Message-State: AOAM530ebQA6DiEzwg0UqTnDdeF9uXRKKnD9Vs+qxb+7OaD71hhRkXnT
        xZ+lkyA7XCiIPYsfC0eEJmTjfYJ0ZgsZgQ==
X-Google-Smtp-Source: ABdhPJxuIPacCvXQaUiXZ3NuxlD5SVo36rSLzGm/LfdfDFn+T1mAtLdJVcEVNWPLSb5YFenQZtVTVg==
X-Received: by 2002:aa7:83cc:0:b029:1ed:446b:1ae2 with SMTP id j12-20020aa783cc0000b02901ed446b1ae2mr4776151pfn.47.1613793214622;
        Fri, 19 Feb 2021 19:53:34 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x184sm3394143pfx.2.2021.02.19.19.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 19:53:34 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: wait potential ->release() on resurrect
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1613785076.git.asml.silence@gmail.com>
 <75e1c94aff46a5bc409f50e50207f4d9a01ff9a0.1613785076.git.asml.silence@gmail.com>
 <914848f1-f30e-4d3a-ab40-9db78e1321b7@kernel.dk>
 <217745e7-0e2b-0faa-8fa9-8e4757515128@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b297d5af-8142-46bb-19fa-dac2ba97691f@kernel.dk>
Date:   Fri, 19 Feb 2021 20:53:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <217745e7-0e2b-0faa-8fa9-8e4757515128@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/19/21 8:47 PM, Pavel Begunkov wrote:
> On 20/02/2021 03:40, Jens Axboe wrote:
>> On 2/19/21 6:39 PM, Pavel Begunkov wrote:
>>> There is a short window where percpu_refs are already turned zero, but
>>> we try to do resurrect(). Play nicer and wait for all users to leave RCU
>>> section.
>>
>> We need to do something better than synchronize_rcu() here, that can
>> take a long time on a loaded box. I'll try and think about this one.
> 
> It only happens when it can't be drained and there are task_works or
> signals. I have another patch, doing it via tryget, but it's uglier and
> I'd rather prefer synchronize_rcu for stable.

Right, but the task_work coming in may not be unlikely. So it's not
strictly an error path.

-- 
Jens Axboe

