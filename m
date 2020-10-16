Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF49290C37
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408143AbgJPT04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408000AbgJPT04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:26:56 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576E8C0613D3
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 12:26:56 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y14so2035278pfp.13
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 12:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q+xomdvChdo5zdEjywnW+el0heK53JsReebPNJYG4Cg=;
        b=MXsrRYXhSSgbHuulEEvSjMqmzU6uwN5TigG0L6Cm/fLBWNiA9PI87ocHBhra6pXwR+
         /zLKxbyYenXJhUPPjm6jL/ImkeZNFi4tkGxCCy2budzQfUVVE6G/xJRgD46r8A9/XL+h
         3iU3zbyB1YQMQmqN0wEM2VgCnNkXE7rt2n4Q4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q+xomdvChdo5zdEjywnW+el0heK53JsReebPNJYG4Cg=;
        b=MqAenofmz3Bc22ErWnkuwuefUjaiCcqJl+tN65F/i8owXDFsy8N5WjsAq983JUXUxb
         3nOpHWzR52ZTdOFn+DMhkhi9JleB9nqdyxme86hlcNoFLx01pr6POTx6BnQgpQtFjHl5
         vfqyCuaYu6SDGar+3wgEQ6cSCwKF2EoOpiMF/3fyZGgzUxNR1qHxtEHpeQJo4ZkuNRFz
         Ll7qaFsjww1Vmxkb4AcPZlxCnua+UC/smSbmehiEJbhM93TOCFvOm4FHwRxIbIT0dsUA
         5QInmXNFdsVIAtsrdhR/uPOnqtTTPXcgbY9/GiNNqclXMOA/xVPae/jXu96W413+YU9I
         L8yg==
X-Gm-Message-State: AOAM531nw+u5maUr6JzAWD/GSYNrrD8ZGZ+Y3xnicgjv9NJ81DNVlNs+
        f+vLHTIBGxZ7v5LIUXPGihjTcxGto1/GAQ==
X-Google-Smtp-Source: ABdhPJzroJN6pEezenaV3/11fdBSOVh2aCYVUkdr1m1/Fa3n3k0Hj6rVuy6vwyrP/08ZbvR1lnsfNA==
X-Received: by 2002:a63:e111:: with SMTP id z17mr4375553pgh.267.1602876415904;
        Fri, 16 Oct 2020 12:26:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d9sm3662110pjx.47.2020.10.16.12.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 12:26:55 -0700 (PDT)
Date:   Fri, 16 Oct 2020 12:26:54 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Petr Mladek <pmladek@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Mike Rapoport <rppt@kernel.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] reboot: fix parsing of reboot cpu number
Message-ID: <202010161226.B136CDC8@keescook>
References: <20201016180907.171957-1-mcroce@linux.microsoft.com>
 <20201016180907.171957-3-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016180907.171957-3-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 08:09:07PM +0200, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> The kernel cmdline reboot= argument allows to specify the CPU used
> for rebooting, with the syntax `s####` among the other flags, e.g.
> 
>   reboot=soft,s4
>   reboot=warm,s31,force
> 
> In the early days the parsing was done with simple_strtoul(), later
> deprecated in favor of the safer kstrtoint() which handles overflow.
> 
> But kstrtoint() returns -EINVAL if there are non-digit characters
> in a string, so if this flag is not the last given, it's silently
> ignored as well as the subsequent ones.
> 
> To fix it, revert the usage of simple_strtoul(), which is no longer
> deprecated, and restore the old behaviour.

It is? Is there a reference, because this was never updated:
https://www.kernel.org/doc/html/latest/process/deprecated.html#simple-strtol-simple-strtoll-simple-strtoul-simple-strtoull

-- 
Kees Cook
