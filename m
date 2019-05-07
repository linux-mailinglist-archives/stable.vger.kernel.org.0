Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512301693E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfEGRc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:32:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:55984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726256AbfEGRc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 13:32:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E641BAEA3;
        Tue,  7 May 2019 17:32:24 +0000 (UTC)
Date:   Tue, 7 May 2019 19:32:24 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
Message-ID: <20190507173224.GS31017@dhcp22.suse.cz>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-62-sashal@kernel.org>
 <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
 <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
 <20190507170208.GF1747@sasha-vm>
 <CAHk-=wi5M-CC3CUhmQZOvQE2xJgfBgrgyAxp+tE=1n3DaNocSg@mail.gmail.com>
 <20190507171806.GG1747@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507171806.GG1747@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-05-19 13:18:06, Sasha Levin wrote:
> On Tue, May 07, 2019 at 10:15:19AM -0700, Linus Torvalds wrote:
> > On Tue, May 7, 2019 at 10:02 AM Sasha Levin <sashal@kernel.org> wrote:
> > > 
> > > I got it wrong then. I'll fix it up and get efad4e475c31 in instead.
> > 
> > Careful. That one had a bug too, and we have 891cb2a72d82 ("mm,
> > memory_hotplug: fix off-by-one in is_pageblock_removable").
> > 
> > All of these were *horribly* and subtly buggy, and might be
> > intertwined with other issues. And only trigger on a few specific
> > machines where the memory map layout is just right to trigger some
> > special case or other, and you have just the right config.
> > 
> > It might be best to verify with Michal Hocko. Michal?
> 
> Michal, is there a testcase I can plug into kselftests to make sure we
> got this right (and don't regress)? We care a lot about memory hotplug
> working right.

As said in other email. The memory hotplug tends to work usually. It
takes unexpected memory layouts which trigger corner cases. This makes
testing really hard.
-- 
Michal Hocko
SUSE Labs
