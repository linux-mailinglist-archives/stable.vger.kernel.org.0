Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C913016ED
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 17:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbhAWQmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 11:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbhAWQme (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 11:42:34 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874A4C0613D6;
        Sat, 23 Jan 2021 08:41:53 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id q12so11855928lfo.12;
        Sat, 23 Jan 2021 08:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s12qlChk6RemkoIoox1VilM8wjYso4uESt9Y0Hae84M=;
        b=LGowOONvNPPLaHeSH1bgMM8A2VGqvkBNpkz7QLzz4RW9iK/7IWVlAZbmzpDVfvlHsN
         9jgB/yInku+DSa9vyzLPXNUJi2zLhR6c/Jujqx5c0Ekqbc7FezSxjQFUvnPf5l73+OnS
         ZJZ3t1VI4MZYKBL5SwIQ2A7wfZ+kp+mWnp1cHHJkXceelSZ5g8FzZiyi4HXsQtaEZSQ+
         T2qH6d+hVaFg2FF+NN6zF3JNYNXnKd8//NEjvqlr8ck8DLqYglznZij2V8/S5X2qjn24
         6+BFo3eXW2KfOVTSWdUDp4GKFpt4WAgI3zV2VC/mfpT1Ni/Wq3v6OS5+JcBGi4QiiyBC
         CTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s12qlChk6RemkoIoox1VilM8wjYso4uESt9Y0Hae84M=;
        b=N6U2LLFN11BPtGdwHT4ggPlM0BwG22aIRAOtF9nyo7Q3CTNaOZ6s7Wsgaynww1Q/V4
         bK9sEa++04TQ3EXjZ48FkwSCEVqIbP8Y8kXmGHNeP7Z+VcSqfiarEXyNiOfOeInRZbyN
         gxHUziOcjyGj89AbL15MkF20u5FSUQNu2q7dEP7VI3SlbzIP/vZTN6ijUBcNTqmz5wAf
         tgSgLuchsxShQPAS6JC3eL0FTFgBvahjMwOGRJCkweSqztXcq9v2BTfp57f6jWFTWHi/
         d+1mNR2GNM6fjdHoUDpH/G7cR+uE3kMdxyz6gK0GKwYqwYCtZWAniCxtlDtDEoI4izYg
         OI4w==
X-Gm-Message-State: AOAM530Z6sUEb0iTJnYXfJa66O//Hza8UUxCIaXRbZ4e1tbQlee2TUZf
        rFYxDgxxQxWIX8Inln6WPmnCEvr2QqM=
X-Google-Smtp-Source: ABdhPJxmFwN9UXnJ/wbEfL8snhwiiwm9PtxZeqECpgG1hIXbnm+C6JVgm0K7OOID/Y5pAqiC0TolEQ==
X-Received: by 2002:ac2:43c5:: with SMTP id u5mr66347lfl.656.1611420110190;
        Sat, 23 Jan 2021 08:41:50 -0800 (PST)
Received: from [192.168.1.101] ([178.176.79.63])
        by smtp.gmail.com with ESMTPSA id o12sm1130242lfl.249.2021.01.23.08.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 08:41:49 -0800 (PST)
Subject: Re: [RE-RESEND PATCH 1/4] usb: musb: Fix runtime PM race in
 musb_queue_resume_work
To:     Paul Cercueil <paul@crapouillou.net>, Bin Liu <b-liu@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tony Lindgren <tony@atomide.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210123142502.16980-1-paul@crapouillou.net>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <72e48343-f87e-5fed-809c-41995197019e@gmail.com>
Date:   Sat, 23 Jan 2021 19:41:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210123142502.16980-1-paul@crapouillou.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/21 5:24 PM, Paul Cercueil wrote:

> musb_queue_resume_work() would call the provided callback if the runtime
> PM status was 'active'. Otherwise, it would enqueue the request if the
> hardware was still suspended (musb->is_runtime_suspended is true).
> 
> This causes a race with the runtime PM handlers, as it is possible to be
> in the case where the runtime PM status is not yet 'active', but the
> hardware has been awaken (PM resume function has been called).

   Awakened. :-)

> When hitting the race, the resume work was not enqueued, which probably
> triggered other bugs further down the stack. For instance, a telnet
> connection on Ingenic SoCs would result in a 50/50 chance of a
> segmentation fault somewhere in the musb code.
> 
> Rework the code so that either we call the callback directly if
> (musb->is_runtime_suspended == 0), or enqueue the query otherwise.
> 
> Fixes: ea2f35c01d5e ("usb: musb: Fix sleeping function called from invalid context for hdrc glue")
> Cc: stable@vger.kernel.org # v4.9+
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
[...]


MBR, Sergei
