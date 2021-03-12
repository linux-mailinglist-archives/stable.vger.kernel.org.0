Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065E43389C8
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 11:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhCLKOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 05:14:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233194AbhCLKNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 05:13:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D786500D;
        Fri, 12 Mar 2021 10:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615543658;
        bh=QMrE+A6ORCrFH63cYp8pxH2+doIupCklRxSGd8rN99Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N3jc/5CTuykmDe3qlnrQyUHUc3sMwdEUVtEGBrn4GeoLr9sfJkQgsCvA6Tycjun4/
         5W6O/0ti+m7xSm27UEPi5jWLHJ/q5/3L78FYs15YYS4dI2prGzdgqlvVWN8fn6cURa
         YhH3Ei0zChd93FPVTsi6nim437Xa+AupbwIp/M9w=
Date:   Fri, 12 Mar 2021 11:07:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manoj Gupta <manojgupta@google.com>
Cc:     sashal@kernel.org, joe.lawrence@redhat.com,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Luis Lozano <llozano@google.com>,
        Jian Cai <jiancai@google.com>,
        Doug Anderson <dianders@google.com>
Subject: Re: 9c8e2f6d3d36 for linux-4.{4,9,14,19}-y
Message-ID: <YEs9Zz9oldcbDedI@kroah.com>
References: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 05:09:30PM -0800, Manoj Gupta wrote:
> Dear stable kernel maintainers,
> 
> Please consider applying the following patch for 4.{4,9,14,19}-y
> kernel branches.
> 9c8e2f6d3d36 scripts/recordmcount.{c,pl}: support -ffunction-sections
> .text.* section names
> 
> It is needed to fix a kernel boot issue with trunk clang compiler
> which now puts functions with  __cold attribute to .text.unlikely
> section.  Please feel free to  check
> https://bugs.chromium.org/p/chromium/issues/detail?id=1184483 for
> details.
> 
> 9c8e2f6d3d36 applies cleanly for 4.14 and 4.19.
> For 4.4 and 4.9, a slight changed diff for scripts/recordmcount.c is
> needed to apply the patch cleanly. The final changed lines are still
> the same.
> 
> scripts/recordmcount.c diff for 4.4 and 4.9 kernel.
> 
> --- a/scripts/recordmcount.c
> +++ b/scripts/recordmcount.c
> @@ -362,7 +362,7 @@ static uint32_t (*w2)(uint16_t);
>  static int
>  is_mcounted_section_name(char const *const txtname)
>  {
> -       return strcmp(".text",           txtname) == 0 ||
> +       return strncmp(".text",          txtname, 5) == 0 ||
>                 strcmp(".ref.text",      txtname) == 0 ||
>                 strcmp(".sched.text",    txtname) == 0 ||
>                 strcmp(".spinlock.text", txtname) == 0 ||
> 

Can you provide properly backported versions for 4.4 and 4.9 so I can
apply them?  Hand-editing them doesn't really work well...

thanks,

greg k-h
