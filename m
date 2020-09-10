Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA4B264836
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 16:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgIJOqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 10:46:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:53474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731195AbgIJOkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 10:40:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 747A6B333;
        Thu, 10 Sep 2020 14:40:34 +0000 (UTC)
Date:   Thu, 10 Sep 2020 16:40:18 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Oscar Salvador <osalvador@suse.de>
Cc:     Laurent Dufour <ldufour@linux.ibm.com>, akpm@linux-foundation.org,
        David Hildenbrand <david@redhat.com>, rafael@kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20200910144018.GK28354@dhcp22.suse.cz>
References: <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
 <20200910072331.GB28354@dhcp22.suse.cz>
 <31cfdf35-618f-6f56-ef16-0d999682ad02@linux.ibm.com>
 <20200910111246.GE28354@dhcp22.suse.cz>
 <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
 <20200910120343.GA6635@linux>
 <20200910124755.GG28354@dhcp22.suse.cz>
 <20200910124847.GH28354@dhcp22.suse.cz>
 <20200910133854.GA8713@linux>
 <20200910135106.GI28354@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910135106.GI28354@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 10-09-20 15:51:07, Michal Hocko wrote:
> On Thu 10-09-20 15:39:00, Oscar Salvador wrote:
> > On Thu, Sep 10, 2020 at 02:48:47PM +0200, Michal Hocko wrote:
[...]
> > > Forgot to ask one more thing. Who is going to online that memory when
> > > userspace is not running yet?
> > 
> > Depends, if you have CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE set or you specify
> > memhp_default_online_type=[online,online_*], memory will get onlined right
> > after hot-adding stage:
> > 
> >         /* online pages if requested */
> >         if (memhp_default_online_type != MMOP_OFFLINE)
> >                 walk_memory_blocks(start, size, NULL, online_memory_block);
> > 
> > If not, systemd-udev will do the magic once the system is up.
> 
> Does that imply that we need udev to scan all existing devices and
> reprobe them?

I've checked the sysfs side of things and it seems that the KOBJ_ADD
event gets lost because there are no listeners
(create_memory_block_devices -> .... -> device_register -> ... ->
device_add -> kobject_uevent(&dev->kobj, KOBJ_ADD) ->
kobject_uevent_net_broadcast). So the only way to find out about those
devices once the init is up and something than intercept those events is
to rescan devices.

This is really unfortunate because this solution really doesn't scale
with most usecases which do not do early boot hotplug and this can get
more than interesting on machines like ppc which have gazillions of
memory block devices because they use insanly small blocks and just
imagine a multi TB machine how that scales. Sigh...
-- 
Michal Hocko
SUSE Labs
