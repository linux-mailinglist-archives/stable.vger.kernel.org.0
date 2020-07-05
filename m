Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD80214CC4
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 15:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgGENaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 09:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgGENaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jul 2020 09:30:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68FFD20723;
        Sun,  5 Jul 2020 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593955816;
        bh=R8bRU8MCs14pPLpDWO76uKEOJ1aY6dYg0uQLxYobpBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kF5d91yYLOjNA0kRzCaIHoiup/65kELU4TpM9z0ljCfwvko8Qb5vrkndit5Fk4eQB
         RZxxt8XsiuK9sjEN0IJ5SaEKSuk6TUnsodpW68ApfBE4t3WxxzUmp8sCeobWuUozuc
         CgSLn1KIlIefGBraixUPfiR5/wUmsE87HOe7ZT/o=
Date:   Sun, 5 Jul 2020 09:30:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4.19 119/131] tracing: Fix event trigger to accept
 redundant spaces
Message-ID: <20200705133015.GH2722994@sasha-vm>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-120-sashal@kernel.org>
 <20200702211728.GD5787@amd>
 <20200703060439.GB6344@kroah.com>
 <20200703192102.GA31738@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200703192102.GA31738@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 03, 2020 at 09:21:03PM +0200, Pavel Machek wrote:
>
>> > > commit 6784beada631800f2c5afd567e5628c843362cee upstream.
>> > >
>> > > Fix the event trigger to accept redundant spaces in
>> > > the trigger input.
>> > >
>> > > For example, these return -EINVAL
>> > >
>> > > echo " traceon" > events/ftrace/print/trigger
>> > > echo "traceon  if common_pid == 0" > events/ftrace/print/trigger
>> > > echo "disable_event:kmem:kmalloc " > events/ftrace/print/trigger
>> > >
>> > > But these are hard to find what is wrong.
>> > >
>> > > To fix this issue, use skip_spaces() to remove spaces
>> > > in front of actual tokens, and set NULL if there is no
>> > > token.
>> >
>> > For the record, I'm not fan of this one. It is ABI change, not a
>> > bugfix.
>> >
>> > Yes, it makes kernel interface "easier to use". It also changes
>> > interface in the middle of stable series, and if people start relying
>> > on new interface and start putting extra spaces, they'll get nasty
>> > surprise when they move code to the older kernel.
>>
>> If an interface changes anywhere that breaks userspace, it needs to be
>> not done, stable kernels are not an issue here or not.
>
>I'm not saying it is a regression; I'd scream way more if that was the
>case. I'm saying it is nowhere near a fix.
>
>We really don't want userspace doing:
>
>> > > echo " traceon" > events/ftrace/print/trigger
>
>Because it does not work on older kernels. It will work on 4.19.131
>and break on 5.6.19.

Moving to an EOL kernel is very much unsupported.

-- 
Thanks,
Sasha
