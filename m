Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA71F4290
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 09:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfKHIxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 03:53:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:40428 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbfKHIxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 03:53:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BD938B219;
        Fri,  8 Nov 2019 08:53:38 +0000 (UTC)
Date:   Fri, 8 Nov 2019 09:53:37 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191108085337.GA15658@dhcp22.suse.cz>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191107122125.GS8314@dhcp22.suse.cz>
 <20191107164236.GB2919@castle.dhcp.thefacebook.com>
 <20191107170200.GX8314@dhcp22.suse.cz>
 <20191107224107.GA8219@castle.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107224107.GA8219@castle.DHCP.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 07-11-19 22:41:13, Roman Gushchin wrote:
> On Thu, Nov 07, 2019 at 06:02:00PM +0100, Michal Hocko wrote:
> > On Thu 07-11-19 16:42:41, Roman Gushchin wrote:
[...]
> > > It's an exiting task with the PF_EXITING flag set and it's in their late stages
> > > of life.
> > 
> > This is a signal delivery path AFAIU (get_signal) and the coredumping
> > happens before do_exit. My understanding is that that unlinking
> > happens from cgroup_exit. So either I am misreading the backtrace or
> > there is some other way to leave cgroups or there is something more
> > going on.
> 
> Yeah, you're right. I have no better explanation for this and the similar,
> mentioned in the commit bsd accounting issue,

Tejun mentioned bsd accounting issue as well, but I do not see any
explicit reference to it in neither of the two patches.

> than some very rare race condition
> that allows cgroups to be offlined with a task inside.
> 
> I'll think more about it.

Thanks a lot. As I've said, I am not opposing this change once we have a
proper changelog but I find the explanation really weak. If there is a
race then it should be fixed as well.

Thanks!
-- 
Michal Hocko
SUSE Labs
