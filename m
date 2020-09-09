Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF45262EBA
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 14:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgIIMve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 08:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730239AbgIIMhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 08:37:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C8421941;
        Wed,  9 Sep 2020 12:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599654987;
        bh=MyTxeMGJ0aUch6xrrUFEzK1mWKVG/hL4CJaX7/Slcb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C19O5ED9pwEGaBq3WjWQS4SEZ5Lwz/9O2+IjIPFpWqNr+we1f2lRLe54jer5JqlNM
         0eSNjuQLOcEhFYhT4ftwMDXBld7PGwh/f/JVfvv+XZE6TQig928vZxQqqZDRZPZQsc
         zPOFUH1l4t7YyS3kNcaMlIRHQgbQ9Wd+oQufliok=
Date:   Wed, 9 Sep 2020 14:36:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Laurent Dufour <ldufour@linux.ibm.com>,
        Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org,
        Oscar Salvador <osalvador@suse.de>, rafael@kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20200909123637.GA671204@kroah.com>
References: <5cbd92e1-c00a-4253-0119-c872bfa0f2bc@redhat.com>
 <20200908170835.85440-1-ldufour@linux.ibm.com>
 <20200909074011.GD7348@dhcp22.suse.cz>
 <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
 <20200909090953.GE7348@dhcp22.suse.cz>
 <4cdb54be-1a92-4ba4-6fee-3b415f3468a9@linux.ibm.com>
 <9ad553f2-ebbf-cae5-5570-f60d2c965c41@redhat.com>
 <20200909123001.GA670250@kroah.com>
 <e3ea2aab-70d5-0da4-7e72-c02051854497@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3ea2aab-70d5-0da4-7e72-c02051854497@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 02:32:57PM +0200, David Hildenbrand wrote:
> On 09.09.20 14:30, Greg Kroah-Hartman wrote:
> > On Wed, Sep 09, 2020 at 11:24:24AM +0200, David Hildenbrand wrote:
> >>>> I am not sure an enum is going to make the existing situation less
> >>>> messy. Sure we somehow have to distinguish boot init and runtime hotplug
> >>>> because they have different constrains. I am arguing that a) we should
> >>>> have a consistent way to check for those and b) we shouldn't blow up
> >>>> easily just because sysfs infrastructure has failed to initialize.
> >>>
> >>> For the point a, using the enum allows to know in register_mem_sect_under_node() 
> >>> if the link operation is due to a hotplug operation or done at boot time.
> >>>
> >>> For the point b, one option would be ignore the link error in the case the link 
> >>> is already existing, but that BUG_ON() had the benefit to highlight the root issue.
> >>>
> >>
> >> WARN_ON_ONCE() would be preferred  - not crash the system but still
> >> highlight the issue.
> > 
> > Many many systems now run with 'panic on warn' enabled, so that wouldn't
> > change much :(
> > 
> > If you can warn, you can properly just print an error message and
> > recover from the problem.
> 
> Maybe VM_WARN_ON_ONCE() then to detect this during testing?

If you all use that, sure.

> (we basically turned WARN_ON_ONCE() useless with 'panic on warn' getting
> used in production - behaves like BUG_ON and BUG_ON is frowned upon)

Yes we have, but in the end, it's good, those things should be fixed and
not accessable by anything a user can trigger.

thanks,

greg k-h
