Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546A2194E2C
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 01:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgC0AoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 20:44:05 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:35189 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0AoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 20:44:05 -0400
Received: by mail-il1-f194.google.com with SMTP id 7so7270995ill.2;
        Thu, 26 Mar 2020 17:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kLzu2msHymfhVb6TpgYrrxOa2r3SSoJwicYD2qkXWJY=;
        b=fjtw34695b6ne7qQks56S6mWm2ms6Nd/YA6PeLVp1zbXLzWHvVFhpGQhgF6K04XSPa
         wSBmW0if2oiFam5egMjMyHNzM5+7n8N9yprbngRhXkQuVPrbuIypQ4mEeckNb5jr4d1R
         T13uUlMmk9vUKmRYXPQXUdktmE1b0fFbbBGmOBZv0Bm3iWIXf8lvmRbdKvwDIyaFNjx8
         N4Q3YnLym2hnGBJeUl9LPNjIggquGgpUkcXLZyhIcGAgNjphOREs+qi2WslgJB2560Q4
         oTof1s9MnTGYjWc/Cm81GBEdMAPHJ894MXjYTdMZQMEU0m5MlQ9NFElSCORUhLQjKN0h
         piWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kLzu2msHymfhVb6TpgYrrxOa2r3SSoJwicYD2qkXWJY=;
        b=kLyI1te3OxYsRlosZTkguv15bahq+ZWxCT+ng+dcsixaYmT4lXfzFLyrvgi0MaMhsC
         dJdM+wWVHkN59/XXZf9/F899yOXvAGjFEGVqTbbyhFNyacnYwOyf+YDrVwbQNrAfpZK6
         wrFuzVxRxPv9D+Pif75dZlJ/PqOBfZwV9Te+ommC8egJGF5nY7JClAt6PYmBhQXrbPbB
         JMEYfh+sPNgtcLrSuVtYLTXK0NeYCGWFiYtfLCe+wrGKOU5ec7UrAgkeUPHoewGNmjU7
         XyNZlFBbCABNiViejEmMtn62BmwURxCJy16tOGKOLx27rzh3tTZ7RH10QwWnb/Gcm46X
         d/YQ==
X-Gm-Message-State: ANhLgQ3y/UpwOIZk75PzUcKAOoc5I7Ry1Exa03edDj4CO/tym+kHAUko
        ILHV/Pz+zK/XJ1pYqMmrpnuNEU1tSfC+rJFDMqPP/V7KGBF/xg==
X-Google-Smtp-Source: ADFU+vt1NlUlR80g6tBN/YWZAZQowsY9DLWFkTfTszWkamu2Pvj3oeOXAArbrSnLPoQzfbRnKLv8IHCf6XbQ2q/gSBo=
X-Received: by 2002:a92:7b10:: with SMTP id w16mr11221793ilc.93.1585269844316;
 Thu, 26 Mar 2020 17:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <1585191042-9935-1-git-send-email-laoar.shao@gmail.com>
 <20200326130808.ccbacd6cba99a40326936fea@linux-foundation.org> <0945d867728008ad9d2243b4427220ef4745098f.camel@sipsolutions.net>
In-Reply-To: <0945d867728008ad9d2243b4427220ef4745098f.camel@sipsolutions.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 27 Mar 2020 08:43:28 +0800
Message-ID: <CALOAHbCwUYGK_cbdBmz5Htr6a+KuVsTQT8q=wBw73CemGhuuFQ@mail.gmail.com>
Subject: Re: [PATCH] kernel/taskstats: fix wrong nla type for
 {cgroup,task}stats policy
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>, bsingharora@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        "David S.Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 4:18 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2020-03-26 at 13:08 -0700, Andrew Morton wrote:
>
> > > After our server is upgraded to a newer kernel, we found that it
> > > continuesly print a warning in the kernel message. The warning is,
> > > [832984.946322] netlink: 'irmas.lc': attribute type 1 has an invalid length.
> > >
> > > irmas.lc is one of our container monitor daemons, and it will use
> > > CGROUPSTATS_CMD_GET to get the cgroupstats, that is similar with
> > > tools/accounting/getdelays.c. We can also produce this warning with
> > > getdelays. For example, after running bellow command
> > >     $ ./getdelays -C /sys/fs/cgroup/memory
> > > then you can find a warning in dmesg,
> > > [61607.229318] netlink: 'getdelays': attribute type 1 has an invalid length.
> > >
> > > This warning is introduced in commit 6e237d099fac ("netlink: Relax attr
> > > validation for fixed length types"), which is used to check whether
> > > attributes using types NLA_U* and NLA_S* have an exact length.
> > >
> > > Regarding this issue, the root cause is cgroupstats_cmd_get_policy defines
> > > a wrong type as NLA_U32, while it should be NLA_NESTED an its minimal
> > > length is NLA_HDRLEN. That is similar to taskstats_cmd_get_policy.
> > >
> > > As this behavior change really breaks our application, we'd better
> > > cc stable as well.
>
> Can you explain how it breaks the application? I mean, it's really only
> printing a message to the kernel log in this case? At least that's what
> you're describing.
>
> I think you may be describing it wrong, because an NLA_NESTED is allowed
> to be *empty* (but otherwise must have at least 4 bytes just like an
> NLA_U32).
>
> That said, I'm not even sure I agree that this fix is right? See below.
>
> > Is it correct to say that although the code has always been incorrect,
> > but only kernels after 6e237d099fac need this change?  If so, I'll add
> > Fixes:6e237d099fac to guide the -stable backporting.
>
> That doesn't really seem right - 6e237d099fac *relaxed* the checks. If
> anything then it ought to point to 28033ae4e0f5 which may have actually
> returned an error; but again, need to understand better what really the
> issue is.
>
> > > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > > index e2ac0e3..b90a520 100644
> > > --- a/kernel/taskstats.c
> > > +++ b/kernel/taskstats.c
> > > @@ -35,8 +35,8 @@
> > >  static struct genl_family family;
> > >
> > >  static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
> > > -   [TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
> > > -   [TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
> > > +   [TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_NESTED },
> > > +   [TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_NESTED },
>
>
> I'm not sure where this is coming from - the kernel evidently uses them
> as nested attributes in *outgoing* data (see mk_reply()), but as NLA_U32
> in *incoming* data, (see cmd_attr_pid() and cmd_attr_tgid()).
>

Thanks for the explanation.
The nested attributes is only used in *outgoing* data, rather than the
'incoming' data.

> I would generally recommend not doing such a thing as it's messy, but we
> do have quite a few such instances cases. In all those cases must the
> policy list the incoming policy since that's what the kernel uses to
> validate the attributes.
>
> IOW, this part of the change seems _wrong_.
>
>
> > >   * Make sure they are always aligned.
> > >   */
> > >  static const struct nla_policy cgroupstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
> > > -   [CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_U32 },
> > > +   [CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_NESTED },
> > >  };
>
> And same here, actually.
>
> johannes
>


Thanks
Yafang
