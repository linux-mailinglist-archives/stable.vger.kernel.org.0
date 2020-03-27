Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E213D194E24
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 01:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgC0AkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 20:40:01 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:36160 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0AkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 20:40:00 -0400
Received: by mail-il1-f195.google.com with SMTP id p13so7246633ilp.3;
        Thu, 26 Mar 2020 17:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zd/d+NmMfPoiVkw185r4QcNynYeA8Jn7+WiOnzp7Ycc=;
        b=W5nlJorNuK4rURuQTs6iC1P12yA5n9Wuu8NtBkUOsA28f/gRN3PPhsNN16ANwGfkyK
         r9e7/WcZ5jqGRCnCUjy+RsHIPuJ9hJEpbEhmRVJyTbv4DA0IBeQDyu/frMlUWMALBvv0
         7gi7ne70vx/TwDzk3Ajx4DKoosU7UB7N6wuADgzjg2dkIyQWRit8BRdiCnYs+lUEBQWd
         uaJZwQjJtjE4YId47nkZmDuTQ+nkflxbm8knUO4RmmXr6E0isGA7e+VoFT13I6sgvHBh
         p0Cen6VvO+2Fh6EJhThKKmjytiluW0aJqdUPsCPFXeXzgJJwbDnaZxe9scXURZI2iiDx
         gqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zd/d+NmMfPoiVkw185r4QcNynYeA8Jn7+WiOnzp7Ycc=;
        b=lRhV7iroaUo1+KV7DXscSc7QMn69tIDhdfQ36m69eKsVzhz7zL/UGxTc30pVodRKI5
         zVa6wxWBZgQE+iLx8rmTD0oBoH+6gIknza4XDdLmLArQ1mloFiuonOvdfTUVUvBa5FxC
         BM3XDIaWbDqhUGWWJCK5LcaxFASm05rmtfROqcBRMHaXDGl/6VYhMf/3CGeUDzdpj6j7
         mBHyDi1oOs0kgcHxd+Wpt0OZjS/kC7AbU36/AjaxB+jW4T8Q/VAZAG586qTGTRHKN4xw
         d7DfTPof/Cq3tra7X83JmJ4YjBgTO+AoBZuBO96zSfCqcIyiAl1AuSkcsHUYnmT3T3nz
         O8vA==
X-Gm-Message-State: ANhLgQ0KYy2qx7meKjN/0pJUqb6rAxLOMkmmtSOSTaVudjCOoh5U2TXY
        PsJUYfhtKFetxgcmhIAgtJNr7PtTQiajDDVK2Pg=
X-Google-Smtp-Source: ADFU+vvq6MTlWxf9MwL0wPp/8QhnDH4n7lMLXziqgL0JnLCFB/c74o1Hh1ddfrQpa2QnhBwjCPHktiDH7/9v0k39Nfw=
X-Received: by 2002:a92:d850:: with SMTP id h16mr11422557ilq.203.1585269599596;
 Thu, 26 Mar 2020 17:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <1585191042-9935-1-git-send-email-laoar.shao@gmail.com>
 <20200326130808.ccbacd6cba99a40326936fea@linux-foundation.org>
 <b879b50324b502cbd3f8439182d63532518d7315.camel@sipsolutions.net> <ed7c4063-8b45-9fc8-5b92-a903d9da4054@gmail.com>
In-Reply-To: <ed7c4063-8b45-9fc8-5b92-a903d9da4054@gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 27 Mar 2020 08:39:23 +0800
Message-ID: <CALOAHbB3mByKY4jfkHLBMu+GOt5XiXURXYwVhExXc4DdZThhVQ@mail.gmail.com>
Subject: Re: [PATCH] kernel/taskstats: fix wrong nla type for
 {cgroup,task}stats policy
To:     David Ahern <dsahern@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        bsingharora@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "David S.Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 5:11 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/26/20 2:28 PM, Johannes Berg wrote:
> >
> > And looking at this ... well, that code is completely wrong?
> >
> > E.g.
> >
> >                 rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
> >                               cmd_type, &tid, sizeof(__u32));
> >
> > (cmd_type is one of TASKSTATS_CMD_ATTR_TGID, TASKSTATS_CMD_ATTR_PID)
> >
> > or it might do
> >
> >                 rc = send_cmd(nl_sd, id, mypid, CGROUPSTATS_CMD_GET,
> >                               CGROUPSTATS_CMD_ATTR_FD, &cfd, sizeof(__u32));
> >
> > so clearly it wants to produce a u32 attribute.
> >
> > But then
> >
> > static int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
> >              __u8 genl_cmd, __u16 nla_type,
> >              void *nla_data, int nla_len)
> > {
> > ...
> >
> >         na = (struct nlattr *) GENLMSG_DATA(&msg);
> >
> > // this is still fine
> >
> >         na->nla_type = nla_type;
> >
> > // this is also fine
> >
> >         na->nla_len = nla_len + 1 + NLA_HDRLEN;
> >
> > // but this??? the nla_len of a netlink attribute should just be
> > // the len ... what's NLA_HDRLEN doing here? this isn't nested
> > // here we end up just reserving 1+NLA_HDRLEN too much space
> >
> >         memcpy(NLA_DATA(na), nla_data, nla_len);
> >
> > // but then it anyway only fills the first nla_len bytes, which
> > // is just like a regular attribute.
> >
> >         msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
> > // note that this is also wrong - it should be
> > // += NLA_ALIGN(NLA_HDRLEN + nla_len)
> >
> >
> >
> > So really I think what happened here is precisely what we wanted -
> > David's kernel patch caught the broken userspace tool.
>
> agreed. The tool needs to be fixed, not the kernel policy.
>
> I do not get the error message with this change as Johannes points out
> above:
>
> diff --git a/tools/accounting/getdelays.c b/tools/accounting/getdelays.c
> index 8cb504d30384..e90fd133df0e 100644
> --- a/tools/accounting/getdelays.c
> +++ b/tools/accounting/getdelays.c
> @@ -136,7 +136,7 @@ static int send_cmd(int sd, __u16 nlmsg_type, __u32
> nlmsg_pid,
>         msg.g.version = 0x1;
>         na = (struct nlattr *) GENLMSG_DATA(&msg);
>         na->nla_type = nla_type;
> -       na->nla_len = nla_len + 1 + NLA_HDRLEN;
> +       na->nla_len = nla_len + NLA_HDRLEN;
>         memcpy(NLA_DATA(na), nla_data, nla_len);
>         msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
>

Right. This is the right thing to do.
I missed that the nla_len() will minus the NLA_HDRLEN.

Would you pls. submit a patch ?

Feel free to add:
Tested-by: Yafang Shao <laoar.shao@gmail.com>

Thanks
Yafang
