Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D1EFE44D
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 18:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfKORrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 12:47:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:34730 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfKORrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 12:47:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 956CEAFF1;
        Fri, 15 Nov 2019 17:47:22 +0000 (UTC)
Date:   Fri, 15 Nov 2019 18:47:21 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191115174721.GB15216@dhcp22.suse.cz>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
 <20191114191657.GN20866@dhcp22.suse.cz>
 <20191114192018.GJ4163745@devbig004.ftw2.facebook.com>
 <20191114193340.GA24848@dhcp22.suse.cz>
 <20191114193736.GL4163745@devbig004.ftw2.facebook.com>
 <20191115174031.GA15216@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115174031.GA15216@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 15-11-19 18:40:31, Michal Hocko wrote:
> On Thu 14-11-19 11:37:36, Tejun Heo wrote:
> > Hello,
> > 
> > On Thu, Nov 14, 2019 at 08:33:40PM +0100, Michal Hocko wrote:
> > > > It is useful for controlling admissions of new userspace visible uses
> > > > - e.g. a tracepoint shouldn't be allowed to be attached to a cgroup
> > > > which has already been deleted.
> > > 
> > > I am not sure I understand. Roman says that the cgroup can get offline
> > > right after the function returns. How is "already deleted" different
> > > from "just deleted"? I thought that the state is preserved at least
> > > while the rcu lock is held but my memory is dim here.
> > 
> > It's the same difference as between "opening a file and deleting it"
> > and "deleting a file and opening it".
> 
> I am sorry but I do not follow. How can css_tryget_online provide the
> same semantic when the css can go offline right after the tryget call
> returns so it is effectivelly undistinguishable from the case when the
> css was already online before the call was made.

s@online@offline@

And reading after myself it turned out to sound differently than I
meant. What I wanted to say really is, what is the difference that
css_tryget_online really guarantee when the css might go offline right
after the call suceeds so more specifically what is the difference
between
	if (css_tryget()) {
		if (online)
			DO_SOMETHING
	}
and
	if (css_tryget_online()) {
		DO_SOMETHING
	}

both of them are racy and do not provide any guarantee wrt. online
state.
-- 
Michal Hocko
SUSE Labs
