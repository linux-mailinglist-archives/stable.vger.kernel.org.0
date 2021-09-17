Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA8640F60A
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 12:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243060AbhIQKkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 06:40:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53720 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhIQKkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 06:40:07 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631875124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16iUxj3eiuaCP/9TBPCFqcGSZj1p057zFz1JxTO3kUM=;
        b=eC8MEUgoYpvXr6vuiyJcLTtFI8I/xnufLWvB6qMcY8Ad+JtigyfyRfAxaqlorn98YwraZz
        dO/TMg8zPfDnrxKqH/XWjq/k9gLORc/NU9ll8PnbhckTJadFbaa+pgI2HjrT/3Hs/KDB7I
        a9lXQeO7vNE3+b9t2TRHSxAT+On0jF+q0XT/Ka5goyEu9uZfWnRjn5P57pweKVLDqvygie
        QyULZF1uLVm9bDPJVd4ubkDbvz6CGBwGPWcUh40iFsDNmm0op/1I/7u7fy+0+F/W+Ayfei
        5w5YnMdK/mxkUuQsVx5rGdWJ419mFuJY3e/BoU6d4JWxXBbGtxYTjYoQNsnBRw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631875124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16iUxj3eiuaCP/9TBPCFqcGSZj1p057zFz1JxTO3kUM=;
        b=tuEfGltlE3SlvZOuN2I7P+FjVCjhOYmdtUtk/Mvt1wlX4+n86vO17pFYzjQlIpg7wb2ubb
        VTMQO9fzQsXcR9DQ==
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
In-Reply-To: <YURQ4ZFDJ8E9MJZM@kroah.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx> <YURQ4ZFDJ8E9MJZM@kroah.com>
Date:   Fri, 17 Sep 2021 12:38:43 +0200
Message-ID: <87sfy38p1o.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17 2021 at 10:25, Greg Kroah-Hartman wrote:
> On Fri, Sep 17, 2021 at 12:32:17AM +0200, Thomas Gleixner wrote:
>> I already got a private bug report vs. that on 5.10.65. Annoyingly
>> 5.10.5 does not have the issue despite the fact that the resulting diff
>> between those two versions in hrtimer.c is just in comments.

The bug report turned out to be a red hering. Probably caused by a
bisect gone wrong. The real culprit was the posix-cpu-timer change which
got reverted already.

> Looks like Sasha picked it up with the AUTOSEL process, and emailed you
> about this on Sep 5:
> 	https://lore.kernel.org/r/20210906012153.929962-12-sashal@kernel.org

which I obviously missed.

> I will revert it if you don't think it should be in the stable trees.

It's a pure performance improvement, so according to stable rules it
should not be there.

> Also, if you want AUTOSEL to not look at any hrtimer.c patches, just let
> us know and Sasha will add it to the ignore-list.

Nah. I try to pay more attention. I'm not against AUTOSEL per se, but
could we change the rules slightly?

Any change which is selected by AUTOSEL and lacks a Cc: stable@... is
put on hold until acked by the maintainer unless it is a prerequisite
for applying a stable tagged fix?

This can be default off and made effective on maintainer request.

Hmm?

Thanks,

        tglx


