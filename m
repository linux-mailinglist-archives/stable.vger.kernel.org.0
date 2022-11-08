Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD25262138F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiKHNvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiKHNvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:51:24 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA15623AA
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:51:18 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id 13so38834349ejn.3
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 05:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A7/QEu2TvHXhOSYbtw3o8zbJW2eMLja/d3Fk5yvRrPo=;
        b=f1JCxMsx0M8HqwDkU6lPwPysCMC5ZPsDr6Jp/wS5hGVNoGqE1t/5/jeioXRGCABh3x
         ql48ZwD2xI3RMDLry2HobRimhA42BGuupXzKcdCO5jgTGOlZZ/7ayqBMZ/HjKupSQSBR
         mmdmuISZbdqN8sy9IOyMbtulIFa7pm79Ipwr+vmfIxyCsga2AjvIIqK5eEpA1wsC3Etw
         FQy8UB+7AwA9LiCC9vnMj7hjE8m9rpw9U/BAg79Xe3Ote8+Z2M7Wr+caV4fAAGwChEpg
         A8XyRK55MyQk06bdE9xrNCdweuokE6wuaq7XgHJro4juHaptTbn8yzhujMZPVFBiYr5C
         3rmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7/QEu2TvHXhOSYbtw3o8zbJW2eMLja/d3Fk5yvRrPo=;
        b=qZFooABfGiW4NmrUEk6VpkIAnFeUsaMeRo5Vz4B2sxIcRRXf5tvxnOKnEe8fU3c99u
         hkUjDqWu0pZV1WqHITe6T6MZ9p5mkJNEdQvOEkk2AXYfFJrXVoppEnGDkS9AWSlqeCnB
         JAwpXJ2UjcNk32w4dI28d+mGQ/uUJFEgSj2z6njYROape3VwxRV/wzYvyPgxiWkuhvgS
         U3QvpVxw0W6Co+qJbQ+mBeKpbgIrapVOLEGfKBQm1NF46vJ1dD5CM1JhTBgrbUhKxLTp
         11b6e3sXkigo/g9XtTxLOReDNczrPVfyMGz5kvzEiHnjk7EmAr95FWPW4U8vEbwXHnE6
         Zh0w==
X-Gm-Message-State: ACrzQf1ypkJQ2S0kg41w/GPoFQyb5MGqFWeyrXs6KJL0LbjT+l4ssEQR
        rXSgXDmMW3WzyWfk3/9u/8j6kMwsqZ0ZmjkMt+pybg==
X-Google-Smtp-Source: AMsMyM79KvOsxzfjetEB86Sdu7VIJROuy3ZeVkMSVcKuj87bYFpXtSO7RTOBFnXl8dhumxgQwYgoMmCddx5YulhrVUQ=
X-Received: by 2002:a17:906:4c4b:b0:7ad:a197:b58e with SMTP id
 d11-20020a1709064c4b00b007ada197b58emr54144312ejw.203.1667915476425; Tue, 08
 Nov 2022 05:51:16 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYv5-og6kr8PgGCg-wYUK3PGCQmvbY1YYews5-C8XwxSww@mail.gmail.com>
In-Reply-To: <CA+G9fYv5-og6kr8PgGCg-wYUK3PGCQmvbY1YYews5-C8XwxSww@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 8 Nov 2022 14:51:04 +0100
Message-ID: <CACRpkdb8ynRrXZ0O4cxoGSn2zQ1rr7zkDiTz78Pm+GPc30p_Nw@mail.gmail.com>
Subject: Re: KASAN / KUNIT: testing ran on qemu-arm and list of failures
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Gow <davidgow@google.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Vitor Massaru Iha <vitor@massaru.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 2, 2022 at 3:15 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:

> This is a report to get a quick update on kasan on qemu-arm.
>
> The KASAN / KUNIT testing ran on qemu-arm and the following test cases failed
> and the kernel crashed.
>
> Following tests failed,
>     kasan_strings - FAILED
>     vmalloc_oob - FAILED
>     kasan_memchr - FAILED
>     kasan - FAILED
>     kasan_bitops_generic - FAILED
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Which isn't very strange since:

> [  429.920201] Insufficient stack space to handle exception!

the system ran out of stack. With VMAP stack and IRQSTACKS
there is really not much more memory we can provide.

When I discussed this with syzbot it seemed they were using some
really big userspace program written in Go that just used up all
the virtual memory :P

I don't know the nature of this test though. Using a lot of memory??

Yours,
Linus Walleij
