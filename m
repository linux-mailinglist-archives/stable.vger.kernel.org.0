Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE34D25ECF9
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 07:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgIFFYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Sep 2020 01:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgIFFYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Sep 2020 01:24:49 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B69C061573
        for <stable@vger.kernel.org>; Sat,  5 Sep 2020 22:24:48 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id j11so13706996ejk.0
        for <stable@vger.kernel.org>; Sat, 05 Sep 2020 22:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=4CuUCNhDMhKM/CNOfzbhwqbfA/RaXZSsfw3uN5K/Sv0=;
        b=HGtFcAUT0RyOfTXwtkfa5ariQkcfBJmiOocmpqgFtqGtbqxeHaUQfuhXvUSyiboHLc
         PQjPaNVdUugVhhoqrWDuXr8zURryKQJmM8nhBhLikQdmcbX5C6lnpDPH/NgyEHVPIy3O
         wJrhhZJ2aN9gFRsZBEmsM5j8DmxG00qEaf3jedznqi1E9jMbmSr0sN+V6YE1qzaYqcpt
         v9e2jyiyAbxkHwSzY43982zNmW4BerhAFz/ZaYOoExRsCxqjMXZ2slO3AiboBSNMWsOa
         sv3FmXRC6bTnSnqgqU6El1ZPEB1mrDyLqrByHnEQMIiuAcB3SKd5o12v1VUsOzuint8y
         DPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=4CuUCNhDMhKM/CNOfzbhwqbfA/RaXZSsfw3uN5K/Sv0=;
        b=NbJW9dA8T2IMi21SNefgcxmDLg4SMSe79HPFH6JVqeouL+VPTGsxqfz0v4TY/EN41A
         LTs82CyDmSCWd7z25/klTWyzG3YdFFohpPYUArGawLJ8Pv7Swiw7qb29Kh4fMEueaPlK
         wyD9h8a6ZrAG0w+gzU5CW2VSa1gJSeu8hrVKvJ4iFGt4Yjmc1O4HDjqe0treqhlM3nP4
         hC9ZKhxIwpYBSfLYhDTNEW6FX+CUudILXGEoq8GWVUUjcxdR7eRKRM4WikqeAXBkLQm+
         esMHFUMZqEWTdZp02TtrzSquiTdaMHpueiJL5Og8oIKhD+vKbyyjD5N5yFU1c3Dakt5h
         wsjw==
X-Gm-Message-State: AOAM533f7qB6vBNBu00KGwIU8/q0pWdywy9DzE2uUt9khkuMP5lRStyt
        Zp/8EKCGwXdXVt7zwA98oNA=
X-Google-Smtp-Source: ABdhPJw3XWo76I2xtI6p/rYdFRME5bJNBWUE4RhMj4UTP0nA4jTV/1SXDNZZ8WMsuIbXmKInEZw4ww==
X-Received: by 2002:a17:906:3791:: with SMTP id n17mr14913636ejc.216.1599369885232;
        Sat, 05 Sep 2020 22:24:45 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2450:10d2:194d:8849:ff16:60d8:971e])
        by smtp.gmail.com with ESMTPSA id f13sm11136796ejb.81.2020.09.05.22.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 22:24:44 -0700 (PDT)
From:   SeongJae Park <sj38.park@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     SeongJae Park <sj38.park@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
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
Date:   Sun,  6 Sep 2020 07:24:31 +0200
Message-Id: <20200906052432.10100-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200905225028.GK8670@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 5 Sep 2020 18:50:28 -0400 Sasha Levin <sashal@kernel.org> wrote:

> On Sat, Sep 05, 2020 at 10:02:20AM +0200, SeongJae Park wrote:
> >From: SeongJae Park <sjpark@amazon.com>
> >
> >On Sat, 5 Sep 2020 09:09:46 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> >> On Fri, Sep 04, 2020 at 04:17:48PM +0200, SeongJae Park wrote:
> >> > > <snip>
> >> > >
> >> > > Stopping right here, if you have fixes that will not cleanly apply, and
> >> > > you think they should be applied, please fix them and send the proper
> >> > > backport.  I don't have the cycles to do these on my own.
> >> > >
> >> > > Same for anything else here that you think should be applied but does
> >> > > not cleanly build/apply.
> >> >
> >> > Totally agreed.  Actually, I posted a similar report[1] before and received
> >> > similar response.  I promised to back-port some of those by myself.  That's
> >> > still in my TODO list, but I was unable to get a time to revisit it quite long
> >> > time.  From this, I realized that it wouldn't be easy to review, test, and
> >> > backport all of the such suspicious things by myself.  Scaling up to multiple
> >> > stable series (the tool says there are 152 fixes and 147 mentions for 4.9.y)
> >> > seems impossible.
> >> >
> >> > For the reason, I updated the tool to make the report to be sent to not only
> >> > the stable maintainers but also the authors of the suspicious commits, because
> >> > the review / test / backport of their own commits would be much easier that
> >> > others.  As a result, we were able to find one suspended commit:
> >> > https://lore.kernel.org/stable/CAKfTPtAkOes+HmVabRazhCBBUo0M+QW38q3Zzj_O3O+Ghvc1pA@mail.gmail.com/
> >>
> >> That work had already been done before your email was sent.
> >>
> >> I too can write a tool that sends out "this patch might be for stable,
> >> will you do the work for it!" emails, but that's a bit rude to ask
> >> others to do your work for you, don't you agree?  By asking me and
> >> others to dig through this list, when you said you don't have the time
> >> to do so, feels very odd to me.
> >
> >I thought the tool and this report are like a very simple form of the CI test
> >bots like 0day, syzbot, or some kind of static analyzers.  Mine has quite large
> >number of false positives, though.  Actually that was my only one concern.
> >Therefore I thought asking the authors to check this could be a little bit
> >annoying and therefore I asked them to let me know if they don't want this.
> >I also thought making an explicit list of false-positive 'Fixes:' could help
> >someone in the community.  Also, I didn't intend to make others do my work
> >instead, but I just wanted to help the community finding missed patches.
> 
> And that's a good goal, but the help we need to accomplish that is in
> the manual parts of the process which we can't automate: figuring out
> whether a patch really needs to be backported, and doing the actual
> backport.
> 
> I'd encourage you to pick a small subset of your results and try doing
> just that - it's not "all of nothing" and even doing a few of these will
> help.

Thanks for the kind explnation :)


Thanks,
SeongJae Park
