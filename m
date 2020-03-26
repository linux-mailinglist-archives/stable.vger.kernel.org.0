Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC5B194A09
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 22:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgCZVLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 17:11:31 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35796 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgCZVLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 17:11:30 -0400
Received: by mail-qt1-f194.google.com with SMTP id e14so6866476qts.2;
        Thu, 26 Mar 2020 14:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eLfTtrwRje07AWDZpn09mSkvQBzmIq1oo7oviI8+vjc=;
        b=D+ZaouzyWVkeh/tg2dxEGWI7lSrEKuZRVvZEJXqhdsJYjYF6RuDFv+iCeZNu/uR1aB
         CtuCXafg+nGox7cQ22IfUNRqiqD2eys6MR6PcJco/tRujHNvGWBS4fSUoRF9/kL/oYw4
         VDfuB/0+7kue2+2XiOc3MM1dY6qw7aCEpUM4WdjrlYxx5NYU4tB18mqE8MRZY18mggsM
         /6XpUUS3xzqb1KwBbccYiHZt6XfJw+YeAXDw/p6pMMNMEGv8McwmCEOZIXZfMT6RYy5m
         L/NIp3AGqJGLx0WsdICv803j7LLROT+dOBSWJHdyrpiHI8JRgKICreGaE87pUK5LG9jH
         bs0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eLfTtrwRje07AWDZpn09mSkvQBzmIq1oo7oviI8+vjc=;
        b=p4A3nCjWjoATPcqAW4SZYeuXcEEemboz77ULo5fc5HhUhcntON2GB1mySVeSSDU2Xw
         +SPODOVv1npvTnS7LG/eqdcaGXbxInaelmFRriTNZL4s4JRWoNexWIMPQa9Z7kETkYnz
         o5c9WOvuYPRCiYcjwkr8rEvSEvr9qpVN55ACOQ8asjIa2BUt0u2uSwGJ2/7mUTVOg9kf
         RLCnsMLoYzpZWT2Tj2wNrqqMoWRTWOj3kn8eQnSDQdp0RVSxqgpTzsTjO00lS6af0aeN
         Il/IX6OnHqPGlFbbFkMtWlcPkbuR6T0veNo9yAlXAW8XRdCvueskWkD9A3LuNbkNcD9R
         J95g==
X-Gm-Message-State: ANhLgQ3sTCZHxgh4vMu67HNcEUMdvpjgjm8b+v+daH3dkcNHKRp8MwXQ
        YkwrW67YPvS6e1i8HqrqVJE=
X-Google-Smtp-Source: ADFU+vs6AAzUK+4IaRXZ1AG8R7BkDnAFC5dJItM6fwqni4Beovp97N9ZLkmWZO6gAlfW3FDMLlFXJA==
X-Received: by 2002:aed:21c5:: with SMTP id m5mr10717014qtc.42.1585257088466;
        Thu, 26 Mar 2020 14:11:28 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:69d5:d817:1ef6:d239? ([2601:282:803:7700:69d5:d817:1ef6:d239])
        by smtp.googlemail.com with ESMTPSA id h138sm2144030qke.86.2020.03.26.14.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 14:11:27 -0700 (PDT)
Subject: Re: [PATCH] kernel/taskstats: fix wrong nla type for
 {cgroup,task}stats policy
To:     Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yafang Shao <laoar.shao@gmail.com>
Cc:     bsingharora@gmail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S.Miller" <davem@davemloft.net>
References: <1585191042-9935-1-git-send-email-laoar.shao@gmail.com>
 <20200326130808.ccbacd6cba99a40326936fea@linux-foundation.org>
 <b879b50324b502cbd3f8439182d63532518d7315.camel@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ed7c4063-8b45-9fc8-5b92-a903d9da4054@gmail.com>
Date:   Thu, 26 Mar 2020 15:11:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b879b50324b502cbd3f8439182d63532518d7315.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/26/20 2:28 PM, Johannes Berg wrote:
> 
> And looking at this ... well, that code is completely wrong?
> 
> E.g.
> 
>                 rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
>                               cmd_type, &tid, sizeof(__u32));
> 
> (cmd_type is one of TASKSTATS_CMD_ATTR_TGID, TASKSTATS_CMD_ATTR_PID)
> 
> or it might do
> 
>                 rc = send_cmd(nl_sd, id, mypid, CGROUPSTATS_CMD_GET,
>                               CGROUPSTATS_CMD_ATTR_FD, &cfd, sizeof(__u32));
> 
> so clearly it wants to produce a u32 attribute.
> 
> But then
> 
> static int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
>              __u8 genl_cmd, __u16 nla_type,
>              void *nla_data, int nla_len)
> {
> ...
> 
>         na = (struct nlattr *) GENLMSG_DATA(&msg);
> 
> // this is still fine
> 
>         na->nla_type = nla_type;
> 
> // this is also fine
> 
>         na->nla_len = nla_len + 1 + NLA_HDRLEN;
> 
> // but this??? the nla_len of a netlink attribute should just be
> // the len ... what's NLA_HDRLEN doing here? this isn't nested
> // here we end up just reserving 1+NLA_HDRLEN too much space
> 
>         memcpy(NLA_DATA(na), nla_data, nla_len);
> 
> // but then it anyway only fills the first nla_len bytes, which
> // is just like a regular attribute.
> 
>         msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
> // note that this is also wrong - it should be 
> // += NLA_ALIGN(NLA_HDRLEN + nla_len)
> 
> 
> 
> So really I think what happened here is precisely what we wanted -
> David's kernel patch caught the broken userspace tool.

agreed. The tool needs to be fixed, not the kernel policy.

I do not get the error message with this change as Johannes points out
above:

diff --git a/tools/accounting/getdelays.c b/tools/accounting/getdelays.c
index 8cb504d30384..e90fd133df0e 100644
--- a/tools/accounting/getdelays.c
+++ b/tools/accounting/getdelays.c
@@ -136,7 +136,7 @@ static int send_cmd(int sd, __u16 nlmsg_type, __u32
nlmsg_pid,
        msg.g.version = 0x1;
        na = (struct nlattr *) GENLMSG_DATA(&msg);
        na->nla_type = nla_type;
-       na->nla_len = nla_len + 1 + NLA_HDRLEN;
+       na->nla_len = nla_len + NLA_HDRLEN;
        memcpy(NLA_DATA(na), nla_data, nla_len);
        msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);

