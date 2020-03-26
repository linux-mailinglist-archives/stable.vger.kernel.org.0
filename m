Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F101948F9
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 21:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgCZU2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 16:28:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54802 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728765AbgCZU2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 16:28:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jHZ6j-00CGGW-CK; Thu, 26 Mar 2020 21:28:05 +0100
Message-ID: <b879b50324b502cbd3f8439182d63532518d7315.camel@sipsolutions.net>
Subject: Re: [PATCH] kernel/taskstats: fix wrong nla type for
 {cgroup,task}stats policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Yafang Shao <laoar.shao@gmail.com>
Cc:     bsingharora@gmail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S.Miller" <davem@davemloft.net>
Date:   Thu, 26 Mar 2020 21:28:03 +0100
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
> (cc's added)
> 
> On Wed, 25 Mar 2020 22:50:42 -0400 Yafang Shao <laoar.shao@gmail.com> wrote:
> 
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

And looking at this ... well, that code is completely wrong?

E.g.

                rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
                              cmd_type, &tid, sizeof(__u32));

(cmd_type is one of TASKSTATS_CMD_ATTR_TGID, TASKSTATS_CMD_ATTR_PID)

or it might do

                rc = send_cmd(nl_sd, id, mypid, CGROUPSTATS_CMD_GET,
                              CGROUPSTATS_CMD_ATTR_FD, &cfd, sizeof(__u32));

so clearly it wants to produce a u32 attribute.

But then

static int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
             __u8 genl_cmd, __u16 nla_type,
             void *nla_data, int nla_len)
{
...

        na = (struct nlattr *) GENLMSG_DATA(&msg);

// this is still fine

        na->nla_type = nla_type;

// this is also fine

        na->nla_len = nla_len + 1 + NLA_HDRLEN;

// but this??? the nla_len of a netlink attribute should just be
// the len ... what's NLA_HDRLEN doing here? this isn't nested
// here we end up just reserving 1+NLA_HDRLEN too much space

        memcpy(NLA_DATA(na), nla_data, nla_len);

// but then it anyway only fills the first nla_len bytes, which
// is just like a regular attribute.

        msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
// note that this is also wrong - it should be 
// += NLA_ALIGN(NLA_HDRLEN + nla_len)



So really I think what happened here is precisely what we wanted -
David's kernel patch caught the broken userspace tool.

johannes

