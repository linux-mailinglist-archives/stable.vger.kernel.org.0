Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA7D24B0DF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgHTIQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgHTIOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 04:14:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587482080C;
        Thu, 20 Aug 2020 08:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597911245;
        bh=a9EMwQOztoal5ntoGgZ/p/FzC9zlwjl92x//5B9Ochk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eW9pvwPBfY+qYb/gemG5QOA7N1uyTNYP+mNSMeQmos8yVCzHCEqbTinPl8TzkGrAX
         6OPtk4EdmS6eiVfN1XuryaR0wvVQigsATX7kyZHXT/Esm28TCwamzbDTFR64J6PQXK
         NS48bWuLKQQ+/J90UJ+DtjdqqAXhsEWM/thsH22g=
Date:   Thu, 20 Aug 2020 10:14:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.com,
        david@redhat.com, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH STABLE 4.9] mm: Avoid calling build_all_zonelists_init
 under hotplug context
Message-ID: <20200820081426.GF4049659@kroah.com>
References: <20200818110046.6664-1-osalvador@suse.de>
 <20200818122446.GA15067@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818122446.GA15067@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 02:24:46PM +0200, Michal Hocko wrote:
> On Tue 18-08-20 13:00:46, Oscar Salvador wrote:
> > Recently a customer of ours experienced a crash when booting the
> > system while enabling memory-hotplug.
> > 
> > The problem is that Normal zones on different nodes don't get their private
> > zone->pageset allocated, and keep sharing the initial boot_pageset.
> > The sharing between zones is normally safe as explained by the comment for
> > boot_pageset - it's a percpu structure, and manipulations are done with
> > disabled interrupts, and boot_pageset is set up in a way that any page placed
> > on its pcplist is immediately flushed to shared zone's freelist, because
> > pcp->high == 1.
> > However, the hotplug operation updates pcp->high to a higher value as it
> > expects to be operating on a private pageset.
> > 
> > The problem is in build_all_zonelists(), which is called when the first range
> > of pages is onlined for the Normal zone of node X or Y:
> > 
> > 	if (system_state == SYSTEM_BOOTING) {
> > 		build_all_zonelists_init();
> > 	} else {
> > 	#ifdef CONFIG_MEMORY_HOTPLUG
> > 		if (zone)
> > 			setup_zone_pageset(zone);
> > 	#endif
> > 		/* we have to stop all cpus to guarantee there is no user
> > 		of zonelist */
> > 		stop_machine(__build_all_zonelists, pgdat, NULL);
> > 		/* cpuset refresh routine should be here */
> > 	}
> > 
> > When called during hotplug, it should execute the setup_zone_pageset(zone)
> > which allocates the private pageset.
> > However, with memhp_default_state=online, this happens early while
> > system_state == SYSTEM_BOOTING is still true, hence this step is skipped.
> > (and build_all_zonelists_init() is probably unsafe anyway at this point).
> > 
> > Another hotplug operation on the same zone then leads to zone_pcp_update(zone)
> > called from online_pages(), which updates the pcp->high for the shared
> > boot_pageset to a value higher than 1.
> > At that point, pages freed from Node X and Y Normal zones can end up on the same
> > pcplist and from there they can be freed to the wrong zone's freelist,
> > leading to the corruption and crashes.
> > 
> > Please, note that upstream has fixed that differently (and unintentionally) by
> > adding another boot state (SYSTEM_SCHEDULING), which is set before smp_init().
> > That should happen before memory hotplug events even with memhp_default_state=online.
> > Backporting that would be too intrusive.
> > 
> > Signed-off-by: Oscar Salvador <osalvador@suse.de>
> > Debugged-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Yes, I believe this is the easiest and the least scary way to fix the
> issue for stable kernel users. Feel free to add
> Acked-by: Michal Hocko <mhocko@suse.com> # for stable trees
> 
> for that purpose.

Now queued up, thanks!

greg k-h
