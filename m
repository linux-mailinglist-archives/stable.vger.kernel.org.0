Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19B623AC2D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgHCSNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 14:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 14:13:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5F5C06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 11:13:17 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so13417727plk.13
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 11:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xudpUBq+NDzS3IqxynYdwIGddLU8wuJKUCaPYNGlfss=;
        b=sko5ec0FuZjPqWaWARI7zOMm8BVQlDQLSYDmz1wlfxGSGD5gxhvEMB+W4TlJ1CztGZ
         JSpbeceEJG7q2T/1dQDrI7bz3sY24tWcNrrAKbd2/h5xJy+oYFDQ04hZ9N4lYk38R8zK
         B2d0rUkrQaJ39kcIFqcmYt0bgSpumzvFcpX3ILVHxJRwOZMKjFL7D+3rrgxg3JuJY1eR
         z9lO+1JGVSukGxnVgxEjgeWqhRsIIWM5knAG6xzNz45Fwr1V4pVSWYMs/bVIwBgF25G3
         taTv9ZGuWndoaRulutQ3bvn/rUE/OpzOT9eEeXCduN4T3OBvtFdpHMo4j1SK6xsz60hQ
         JRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xudpUBq+NDzS3IqxynYdwIGddLU8wuJKUCaPYNGlfss=;
        b=MkhU38Yv7yhxrbNKi7dwWghhtlw2aD5sV1JchW5181ebRX3Ge7MyjM795K91OxsgcK
         pZYCjbaM2ePJRqL25VIX4Q06vpkquqoL9ZOJBnE85GsyhBVX1/Lk6/SfH9NmX1MYEJgQ
         3biFCXALguaQxngkio8QAHcSd+lgErtigMTqeMzWKXoCaqhD2+z94chhd+oqFbwjI0um
         FfB1hvjc70LYDWQkjdWH4giR/rcE2gMciwkQ+1Cm2x97/zO3M0XxYZjiDzGGoVYpl9Lh
         hlwppD61witzA83fT4sFEEEmhYL7dlVndCtnXSWxYwmgRZWJdiMvf4OdYulkV2yivurk
         6jKg==
X-Gm-Message-State: AOAM530PLIh9XS8sS7sn5JR4tNbH0a6BG07KPB2h74xCeeLeYQZxFsr1
        uzYppCO2UNjS71SRpstr1uLDPd+qHUwKJJEUjJsjyg==
X-Google-Smtp-Source: ABdhPJwjQ3gw1usNMVQbIdYRPi5tkEqiFIneAvKDHvnwnpFZTKSYT3P7Muadl9Wxg8h2yuYouIFG6vl+oSTqFO2SwHY=
X-Received: by 2002:a17:90a:3ad1:: with SMTP id b75mr493431pjc.25.1596478396575;
 Mon, 03 Aug 2020 11:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200730205112.2099429-3-ndesaulniers@google.com> <20200801231815.7817920829@mail.kernel.org>
In-Reply-To: <20200801231815.7817920829@mail.kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 3 Aug 2020 11:13:04 -0700
Message-ID: <CAKwvOdnNud7L9YUmJYDOb71nq+v1+rjSMMbGwkcMZwt6Qr8OxA@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: backtrace-clang: add fixup for lr dereference
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Nathan Huckleberry <nhuck15@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 1, 2020 at 4:18 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang").
>
> The bot has tested the following trees: v5.7.11, v5.4.54.
>
> v5.7.11: Failed to apply! Possible dependencies:
>     5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
>     99c56f602183 ("ARM: backtrace-clang: check for NULL lr")
>
> v5.4.54: Failed to apply! Possible dependencies:
>     40ff1ddb5570 ("ARM: 8948/1: Prevent OOB access in stacktrace")
>     5489ab50c227 ("arm/asm: add loglvl to c_backtrace()")
>     99c56f602183 ("ARM: backtrace-clang: check for NULL lr")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

Ah, ok, I'll provide manual backports then once this hits mainline.
In that case, should I drop the explicit `Cc: stable...` tag?

(I don't think the dependency on the loglvl should be backported,
which is the source of conflict)
-- 
Thanks,
~Nick Desaulniers
