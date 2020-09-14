Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902E4268713
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 10:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgINITb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 04:19:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:59616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgINITb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 04:19:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5C04CAC46;
        Mon, 14 Sep 2020 08:19:45 +0000 (UTC)
Date:   Mon, 14 Sep 2020 10:19:26 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     David Hildenbrand <david@redhat.com>
Cc:     Laurent Dufour <ldufour@linux.ibm.com>, akpm@linux-foundation.org,
        mhocko@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/3] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20200914081921.GA15113@linux>
References: <20200911134831.53258-1-ldufour@linux.ibm.com>
 <20200911134831.53258-3-ldufour@linux.ibm.com>
 <f50fe4ae-faf0-6e03-b87e-45ca8c53960d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f50fe4ae-faf0-6e03-b87e-45ca8c53960d@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 09:57:46AM +0200, David Hildenbrand wrote:
> >  /* register memory section under specified node if it spans that node */
> > +struct rmsun_args {
> > +	int nid;
> > +	enum memplug_context context;
> > +};

Uhmf, that is a not so descriptive name.

> Instead of handling this in register_mem_sect_under_node(), I
> think it would be better two have two separate
> register_mem_sect_under_node() implementations.
> 
> static int register_mem_sect_under_node_hotplug(struct memory_block *mem_blk,
> 						void *arg)
> {
> 	const int nid = *(int *)arg;
> 	int ret;
> 
> 	/* Hotplugged memory has no holes and belongs to a single node. */
> 	mem_blk->nid = nid;
> 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
> 				       &mem_blk->dev.kobj,
> 				       kobject_name(&mem_blk->dev.kobj));
> 	if (ret)
> 		returnr et;
> 	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
> 					&node_devices[nid]->dev.kobj,
> 					kobject_name(&node_devices[nid]->dev.kobj));
> 
> }
> 
> Cleaner, right? :) No unnecessary checks.

I tend to agree here, I like more a simplistic version for hotplug.

> One could argue if link_mem_section_hotplug() would be better than passing around the context.

I am not sure if I would duplicate the code there.
We could just pass the pointer of the function we want to call to
link_mem_sections? either register_mem_sect_under_node_hotplug or
register_mem_sect_under_node_early?
Would not that be clean and clear enough?

-- 
Oscar Salvador
SUSE L3
