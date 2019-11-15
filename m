Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAEDFE47D
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 19:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfKOSDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 13:03:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:44928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfKOSDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 13:03:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 46E8EB9DB;
        Fri, 15 Nov 2019 18:03:04 +0000 (UTC)
Date:   Fri, 15 Nov 2019 19:03:03 +0100
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
Message-ID: <20191115180303.GC15216@dhcp22.suse.cz>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
 <20191114191657.GN20866@dhcp22.suse.cz>
 <20191114192018.GJ4163745@devbig004.ftw2.facebook.com>
 <20191114193340.GA24848@dhcp22.suse.cz>
 <20191114193736.GL4163745@devbig004.ftw2.facebook.com>
 <20191115174031.GA15216@dhcp22.suse.cz>
 <20191115174721.GB15216@dhcp22.suse.cz>
 <20191115174844.GR4163745@devbig004.ftw2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115174844.GR4163745@devbig004.ftw2.facebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 15-11-19 09:48:44, Tejun Heo wrote:
> On Fri, Nov 15, 2019 at 06:47:21PM +0100, Michal Hocko wrote:
> > s@online@offline@
> > 
> > And reading after myself it turned out to sound differently than I
> > meant. What I wanted to say really is, what is the difference that
> > css_tryget_online really guarantee when the css might go offline right
> > after the call suceeds so more specifically what is the difference
> > between
> > 	if (css_tryget()) {
> > 		if (online)
> > 			DO_SOMETHING
> > 	}
> > and
> > 	if (css_tryget_online()) {
> > 		DO_SOMETHING
> > 	}
> > 
> > both of them are racy and do not provide any guarantee wrt. online
> > state.
> 
> It's about not giving new reference when the object is known to be
> delted to the user.

This part is clear to me. The failure just says it is already too late
to do anything. I just still struggle why the success is telling me much
more when the state might change before I can do anything on the object.
I could see a usefulness if I've had a guarantee that the object stays
online while I hold a $FOO lock but if there is nothing like that then 
we are just having already too late or potentially too late.

Anyway it's been a hard week and the brain is just going for the weekend
so I just might be dense now.

> Can you please think more about how file deletions work?

I will try that with a fresh brain next week.
-- 
Michal Hocko
SUSE Labs
