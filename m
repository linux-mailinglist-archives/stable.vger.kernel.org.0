Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F299625EB94
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 00:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgIEWub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 18:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728727AbgIEWua (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 18:50:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E061820797;
        Sat,  5 Sep 2020 22:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599346230;
        bh=U0bt2hFoSS5ciurGZVp4VnMMcVkVgqn0mex9MRJ0aU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tZsYvM8zaQsHa2Ju4AdJLNZ1PecWK2YseNRJBHBs582n/gSoV9sxz2VjO3dcq77Eh
         Z9E9rtwQ/FcQm0c6RRjz7M+HToHuj2z3F9EaBlabGmRfNH+INHdPmng2XHiuRgfjxA
         e49ToJrDWZCqAfm8fZdnPrpb5P/hlhKGLiSj2QZ8=
Date:   Sat, 5 Sep 2020 18:50:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     SeongJae Park <sj38.park@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        SeongJae Park <sjpark@amazon.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Filipe Manana <fdmanana@suse.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, Jan Kara <jack@suse.cz>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Adam Ford <aford173@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>, amit@kernel.org,
        stable@vger.kernel.org
Subject: Re: [5.4.y] Found 27 commits that might missed
Message-ID: <20200905225028.GK8670@sasha-vm>
References: <20200905070946.GA184702@kroah.com>
 <20200905080220.23493-1-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200905080220.23493-1-sj38.park@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 05, 2020 at 10:02:20AM +0200, SeongJae Park wrote:
>From: SeongJae Park <sjpark@amazon.com>
>
>On Sat, 5 Sep 2020 09:09:46 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:
>
>> On Fri, Sep 04, 2020 at 04:17:48PM +0200, SeongJae Park wrote:
>> > > <snip>
>> > >
>> > > Stopping right here, if you have fixes that will not cleanly apply, and
>> > > you think they should be applied, please fix them and send the proper
>> > > backport.  I don't have the cycles to do these on my own.
>> > >
>> > > Same for anything else here that you think should be applied but does
>> > > not cleanly build/apply.
>> >
>> > Totally agreed.  Actually, I posted a similar report[1] before and received
>> > similar response.  I promised to back-port some of those by myself.  That's
>> > still in my TODO list, but I was unable to get a time to revisit it quite long
>> > time.  From this, I realized that it wouldn't be easy to review, test, and
>> > backport all of the such suspicious things by myself.  Scaling up to multiple
>> > stable series (the tool says there are 152 fixes and 147 mentions for 4.9.y)
>> > seems impossible.
>> >
>> > For the reason, I updated the tool to make the report to be sent to not only
>> > the stable maintainers but also the authors of the suspicious commits, because
>> > the review / test / backport of their own commits would be much easier that
>> > others.  As a result, we were able to find one suspended commit:
>> > https://lore.kernel.org/stable/CAKfTPtAkOes+HmVabRazhCBBUo0M+QW38q3Zzj_O3O+Ghvc1pA@mail.gmail.com/
>>
>> That work had already been done before your email was sent.
>>
>> I too can write a tool that sends out "this patch might be for stable,
>> will you do the work for it!" emails, but that's a bit rude to ask
>> others to do your work for you, don't you agree?  By asking me and
>> others to dig through this list, when you said you don't have the time
>> to do so, feels very odd to me.
>
>I thought the tool and this report are like a very simple form of the CI test
>bots like 0day, syzbot, or some kind of static analyzers.  Mine has quite large
>number of false positives, though.  Actually that was my only one concern.
>Therefore I thought asking the authors to check this could be a little bit
>annoying and therefore I asked them to let me know if they don't want this.
>I also thought making an explicit list of false-positive 'Fixes:' could help
>someone in the community.  Also, I didn't intend to make others do my work
>instead, but I just wanted to help the community finding missed patches.

And that's a good goal, but the help we need to accomplish that is in
the manual parts of the process which we can't automate: figuring out
whether a patch really needs to be backported, and doing the actual
backport.

I'd encourage you to pick a small subset of your results and try doing
just that - it's not "all of nothing" and even doing a few of these will
help.

-- 
Thanks,
Sasha
