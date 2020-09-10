Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E537C265348
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 23:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgIJVbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 17:31:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730916AbgIJNvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 09:51:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BA407B04F;
        Thu, 10 Sep 2020 13:51:22 +0000 (UTC)
Date:   Thu, 10 Sep 2020 15:51:06 +0200
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
Message-ID: <20200910135106.GI28354@dhcp22.suse.cz>
References: <20200909105914.GF7348@dhcp22.suse.cz>
 <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
 <20200910072331.GB28354@dhcp22.suse.cz>
 <31cfdf35-618f-6f56-ef16-0d999682ad02@linux.ibm.com>
 <20200910111246.GE28354@dhcp22.suse.cz>
 <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
 <20200910120343.GA6635@linux>
 <20200910124755.GG28354@dhcp22.suse.cz>
 <20200910124847.GH28354@dhcp22.suse.cz>
 <20200910133854.GA8713@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910133854.GA8713@linux>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 10-09-20 15:39:00, Oscar Salvador wrote:
> On Thu, Sep 10, 2020 at 02:48:47PM +0200, Michal Hocko wrote:
> > > Is there any actual usecase for a configuration like this? What is the
> > > point to statically define additional memory like this when the same can
> > > be achieved on the same command line?
> 
> Well, for qemu I am not sure, but if David is right, it seems you can face
> the same if you reboot a vm with hotplugged memory.

OK, thanks for the clarification. I was not aware of the reboot.

> Moreover, it seems that the problem we spotted with [1], it was a VM running on
> Promox (KVM).
> The Hypervisor probably said at boot time "Ey, I do have these ACPI devices, care
> to enable them now"?
> 
> As always, there are all sorts of configurations/scenarios out there in the wild.
> 
> > Forgot to ask one more thing. Who is going to online that memory when
> > userspace is not running yet?
> 
> Depends, if you have CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE set or you specify
> memhp_default_online_type=[online,online_*], memory will get onlined right
> after hot-adding stage:
> 
>         /* online pages if requested */
>         if (memhp_default_online_type != MMOP_OFFLINE)
>                 walk_memory_blocks(start, size, NULL, online_memory_block);
> 
> If not, systemd-udev will do the magic once the system is up.

Does that imply that we need udev to scan all existing devices and
reprobe them?
-- 
Michal Hocko
SUSE Labs
