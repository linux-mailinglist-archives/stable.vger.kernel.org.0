Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF951948A6
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 21:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgCZUSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 16:18:33 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54700 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgCZUSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 16:18:33 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jHYxL-00CEzj-Da; Thu, 26 Mar 2020 21:18:23 +0100
Message-ID: <0945d867728008ad9d2243b4427220ef4745098f.camel@sipsolutions.net>
Subject: Re: [PATCH] kernel/taskstats: fix wrong nla type for
 {cgroup,task}stats policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Yafang Shao <laoar.shao@gmail.com>
Cc:     bsingharora@gmail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S.Miller" <davem@davemloft.net>
Date:   Thu, 26 Mar 2020 21:18:22 +0100
In-Reply-To: <20200326130808.ccbacd6cba99a40326936fea@linux-foundation.org>
References: <1585191042-9935-1-git-send-email-laoar.shao@gmail.com>
         <20200326130808.ccbacd6cba99a40326936fea@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-03-26 at 13:08 -0700, Andrew Morton wrote:

> > After our server is upgraded to a newer kernel, we found that it
> > continuesly print a warning in the kernel message. The warning is,
> > [832984.946322] netlink: 'irmas.lc': attribute type 1 has an invalid length.
> > 
> > irmas.lc is one of our container monitor daemons, and it will use
> > CGROUPSTATS_CMD_GET to get the cgroupstats, that is similar with
> > tools/accounting/getdelays.c. We can also produce this warning with
> > getdelays. For example, after running bellow command
> > 	$ ./getdelays -C /sys/fs/cgroup/memory
> > then you can find a warning in dmesg,
> > [61607.229318] netlink: 'getdelays': attribute type 1 has an invalid length.
> > 
> > This warning is introduced in commit 6e237d099fac ("netlink: Relax attr
> > validation for fixed length types"), which is used to check whether
> > attributes using types NLA_U* and NLA_S* have an exact length.
> > 
> > Regarding this issue, the root cause is cgroupstats_cmd_get_policy defines
> > a wrong type as NLA_U32, while it should be NLA_NESTED an its minimal
> > length is NLA_HDRLEN. That is similar to taskstats_cmd_get_policy.
> > 
> > As this behavior change really breaks our application, we'd better
> > cc stable as well.

Can you explain how it breaks the application? I mean, it's really only
printing a message to the kernel log in this case? At least that's what
you're describing.

I think you may be describing it wrong, because an NLA_NESTED is allowed
to be *empty* (but otherwise must have at least 4 bytes just like an
NLA_U32).

That said, I'm not even sure I agree that this fix is right? See below.

> Is it correct to say that although the code has always been incorrect,
> but only kernels after 6e237d099fac need this change?  If so, I'll add
> Fixes:6e237d099fac to guide the -stable backporting.

That doesn't really seem right - 6e237d099fac *relaxed* the checks. If
anything then it ought to point to 28033ae4e0f5 which may have actually
returned an error; but again, need to understand better what really the
issue is.

> > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > index e2ac0e3..b90a520 100644
> > --- a/kernel/taskstats.c
> > +++ b/kernel/taskstats.c
> > @@ -35,8 +35,8 @@
> >  static struct genl_family family;
> >  
> >  static const struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
> > -	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
> > -	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
> > +	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_NESTED },
> > +	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_NESTED },


I'm not sure where this is coming from - the kernel evidently uses them
as nested attributes in *outgoing* data (see mk_reply()), but as NLA_U32
in *incoming* data, (see cmd_attr_pid() and cmd_attr_tgid()).

I would generally recommend not doing such a thing as it's messy, but we
do have quite a few such instances cases. In all those cases must the
policy list the incoming policy since that's what the kernel uses to
validate the attributes.

IOW, this part of the change seems _wrong_.


> >   * Make sure they are always aligned.
> >   */
> >  static const struct nla_policy cgroupstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1] = {
> > -	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_U32 },
> > +	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_NESTED },
> >  };

And same here, actually.

johannes

