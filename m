Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCF32645A4
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 14:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIJMDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 08:03:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:41100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730244AbgIJMBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 08:01:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31B87AD36;
        Thu, 10 Sep 2020 12:01:40 +0000 (UTC)
Date:   Thu, 10 Sep 2020 14:01:23 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, rafael@kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20200910120123.GF28354@dhcp22.suse.cz>
References: <20200909074011.GD7348@dhcp22.suse.cz>
 <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
 <20200909090953.GE7348@dhcp22.suse.cz>
 <4cdb54be-1a92-4ba4-6fee-3b415f3468a9@linux.ibm.com>
 <20200909105914.GF7348@dhcp22.suse.cz>
 <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
 <20200910072331.GB28354@dhcp22.suse.cz>
 <31cfdf35-618f-6f56-ef16-0d999682ad02@linux.ibm.com>
 <20200910111246.GE28354@dhcp22.suse.cz>
 <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 10-09-20 13:35:32, Laurent Dufour wrote:
> Le 10/09/2020 à 13:12, Michal Hocko a écrit :
> > On Thu 10-09-20 09:51:39, Laurent Dufour wrote:
> > > Le 10/09/2020 à 09:23, Michal Hocko a écrit :
> > > > On Wed 09-09-20 18:07:15, Laurent Dufour wrote:
> > > > > Le 09/09/2020 à 12:59, Michal Hocko a écrit :
> > > > > > On Wed 09-09-20 11:21:58, Laurent Dufour wrote:
> > > > [...]
> > > > > > > For the point a, using the enum allows to know in
> > > > > > > register_mem_sect_under_node() if the link operation is due to a hotplug
> > > > > > > operation or done at boot time.
> > > > > > 
> > > > > > Yes, but let me repeat. We have a mess here and different paths check
> > > > > > for the very same condition by different ways. We need to unify those.
> > > > > 
> > > > > What are you suggesting to unify these checks (using a MP_* enum as
> > > > > suggested by David, something else)?
> > > > 
> > > > We do have system_state check spread at different places. I would use
> > > > this one and wrap it behind a helper. Or have I missed any reason why
> > > > that wouldn't work for this case?
> > > 
> > > That would not work in that case because memory can be hot-added at the
> > > SYSTEM_SCHEDULING system state and the regular memory is also registered at
> > > that system state too. So system state is not enough to discriminate between
> > > the both.
> > 
> > If that is really the case all other places need a fix as well.
> > Btw. could you be more specific about memory hotplug during early boot?
> > How that happens? I am only aware of https://lkml.kernel.org/r/20200818110046.6664-1-osalvador@suse.de
> > and that doesn't happen as early as SYSTEM_SCHEDULING.
> 
> That points has been raised by David, quoting him here:
> 
> > IIRC, ACPI can hotadd memory while SCHEDULING, this patch would break that.
> > 
> > Ccing Oscar, I think he mentioned recently that this is the case with ACPI.

: Please, note that upstream has fixed that differently (and unintentionally) by
: adding another boot state (SYSTEM_SCHEDULING), which is set before smp_init().
: That should happen before memory hotplug events even with memhp_default_state=online.
: Backporting that would be too intrusive.

Either I am confused or the above says that no hotplug should happen
during SYSTEM_SCHEDULING even in the above case. I really have hard time
to imagine how an early boot hotplug should even work. We start with a
memory layout provided by a BIOS/FW and intiailize it statically. How
would a hotplug even actually trigger that early?
-- 
Michal Hocko
SUSE Labs
