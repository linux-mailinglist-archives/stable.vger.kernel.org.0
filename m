Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B10C44C0B2
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 13:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhKJMGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 07:06:36 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:43494 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhKJMGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 07:06:08 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 033261FD6F;
        Wed, 10 Nov 2021 12:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636545800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u3e5Y6mxt6D3IfPmlT0aEiymDw2J77osTi1AWrqymp4=;
        b=tvUmgsOmL5TWovVFHL0gVWZDhTH4zlzq8EycjzDJHHoFgTEqrVS0vTSgoGYbfK+8Mad1rj
        G2tyVmz2obJ4q3qZ3STDJ6QAJKyiKfVvN/nw5eAIzELZ2xTp6wtko19ArGi4BwpSvsojBj
        4IKOqH6LPslVbYOBcc2c7f89uFQ8sK4=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D78E8A3B8D;
        Wed, 10 Nov 2021 12:03:19 +0000 (UTC)
Date:   Wed, 10 Nov 2021 13:03:19 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        Yi Fan <yfa@google.com>, shreyas.joshi@biamp.com,
        Joshua Levasseur <jlevasseur@google.com>, sashal@kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        wklin@google.com, mfaltesek@google.com
Subject: Re: [PATCH] printk/console: Allow to disable console output by using
 console="" or console=null
Message-ID: <YYu1B40MQx2+WkZ6@alley>
References: <YYqZdkLBAC8mtRSC@alley>
 <a46e9a26-5b9f-f14c-26be-0b4d41fa7429@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a46e9a26-5b9f-f14c-26be-0b4d41fa7429@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 2021-11-09 10:15:12, Guenter Roeck wrote:
> On 11/9/21 7:53 AM, Petr Mladek wrote:
> > The commit 48021f98130880dd74 ("printk: handle blank console arguments
> > passed in.") prevented crash caused by empty console= parameter value.
> > 
> > Unfortunately, this value is widely used on Chromebooks to disable
> > the console output. The above commit caused performance regression
> > because the messages were pushed on slow console even though nobody
> > was watching it.
> > 
> 
> We actually had to revert this patch on Chromebooks, so we'll have to revert
> it again from stable releases after it gets there.

What patch was or need to get reverted on Chromebooks, please?

  1. commit 48021f98130880dd74 ("printk: handle blank console
     arguments passed in.")

or

  2. commit commit 3cffa06aeef7ece30f6b5ac0e ("printk/console: Allow
     to disable console output by using console="" or console=null")


I know that the 1st patch caused problems on Chromebook. The 2nd one
was supposed to fix the problem.

The 2nd patch is being backported here? Do you still see the problems
with it, please?


> The problem is two-fold:
> 
> First, it is used in Chromebooks to disable the default console in production
> images; that default console may be set in a devicetree file, and this patch
> doesn't really disable it. In other words, Chromebooks use "console=" to
> implement "mute_console" as suggested below, and this patch does not address
> that use case.

I guess that you are talking about the 1st patch.

The 2nd patch should make it working basically the same way as when reverting
the 1st patch. The difference is that it prefers the fake ttynull
console driver instead of none. It should be better because it will
provide a kind of null console for stdin/stdou/stderr of the init
process. But it still should result into a none-driver when ttynull
driver is not available.

Or do you use another extra patch for Chromebooks, please?

> Second, the patch causes some unexplained problems with dm-verity, which
> inexplicably fails on some Chromebooks when the patch is in place.
> We never tracked down the root cause because the patch doesn't work
> for us anyway.

Interesting. I wonder what console was really registered when it complained.

Best Regards,
Petr
