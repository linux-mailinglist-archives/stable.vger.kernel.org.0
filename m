Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90778FCEC8
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 20:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKNTdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 14:33:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:55164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726444AbfKNTdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 14:33:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2A13B2AD;
        Thu, 14 Nov 2019 19:33:41 +0000 (UTC)
Date:   Thu, 14 Nov 2019 20:33:40 +0100
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
Message-ID: <20191114193340.GA24848@dhcp22.suse.cz>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
 <20191114191657.GN20866@dhcp22.suse.cz>
 <20191114192018.GJ4163745@devbig004.ftw2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114192018.GJ4163745@devbig004.ftw2.facebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 14-11-19 11:20:18, Tejun Heo wrote:
> Hello,
> 
> On Thu, Nov 14, 2019 at 08:16:57PM +0100, Michal Hocko wrote:
> > Then what is the point of this function and what about all other users?
> 
> It is useful for controlling admissions of new userspace visible uses
> - e.g. a tracepoint shouldn't be allowed to be attached to a cgroup
> which has already been deleted.

I am not sure I understand. Roman says that the cgroup can get offline
right after the function returns. How is "already deleted" different
from "just deleted"? I thought that the state is preserved at least
while the rcu lock is held but my memory is dim here.

> We're just using it too liberally.

Can we get a doc update to be explicit about sensible usecases so that
others can be dropped accordingly? 
-- 
Michal Hocko
SUSE Labs
