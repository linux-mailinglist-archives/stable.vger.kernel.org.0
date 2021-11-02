Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A979442A8E
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 10:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhKBJnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 05:43:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53752 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKBJnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 05:43:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3BBCD1FD4C;
        Tue,  2 Nov 2021 09:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635846044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X+zeEJxaxigpF0JmA9P/IlwLz0CIgiUc5xKVn036itk=;
        b=dveKC3cJXF4f0Xb1Qi1GbO2mKhgv1Z2hP9wvUK2RysymAHkKS8dHG0e4H8nO30XeMkBBrR
        9Gp6sP3RVMW8puo2lkQF4UfG5kETc+zVQmF9pPnLXRvxdFsMAAd1bSMToobaQ3w6E9VKZ1
        0cMWOnvn9XbFOlE98Q3L18SVsbaR+xQ=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0EBC7A3B81;
        Tue,  2 Nov 2021 09:40:44 +0000 (UTC)
Date:   Tue, 2 Nov 2021 10:40:43 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     David Hildenbrand <david@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYEHm/8FupRZePQq@dhcp22.suse.cz>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 02-11-21 10:04:23, Michal Hocko wrote:
[...]
> > Is there any reason why try_online_node() resides in cpu_up() and not in add_cpu()?
> > I think it would be correct to online node during the CPU hot add to align with
> > memory hot add.
> 
> I am not familiar with cpu hotplug, but this doesn't seem to be anything
> new so how come this became problem only now?

Just looked at the cpu hotplug part. I do not see add_cpu to add much
here. Here is what I can see in the current Linus tree
add_cpu
  device_online() # cpu device - cpu_sys_devices with cpu_subsys bus
    dev->bus->online -> cpu_subsys_online
      cpu_device_up
        cpu_up
	  try_online_node

So we should be bringing up the node during add_cpu. Unless something
fails on the way - e.g. cpu_possible check or something similar.

-- 
Michal Hocko
SUSE Labs
