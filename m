Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB95925AC56
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 15:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgIBNur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 09:50:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:43138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgIBNuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 09:50:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BB1DFB609;
        Wed,  2 Sep 2020 13:50:20 +0000 (UTC)
Date:   Wed, 2 Sep 2020 15:50:18 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     David Hildenbrand <dhildenb@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
Message-ID: <20200902135018.GF4617@dhcp22.suse.cz>
References: <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz>
 <A8A8D5FE-86C3-40B4-919C-5FF2A134F366@redhat.com>
 <CA+CK2bAebg4PALh3_-49MXGJ-FNP3hE98wHZd5uEC-q7wG6Vmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bAebg4PALh3_-49MXGJ-FNP3hE98wHZd5uEC-q7wG6Vmg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 02-09-20 08:42:13, Pavel Tatashin wrote:
> > > Am 02.09.2020 um 11:53 schrieb Vlastimil Babka <vbabka@suse.cz>:
> > >
> > > ﻿On 8/28/20 6:47 PM, Pavel Tatashin wrote:
> > >> There appears to be another problem that is related to the
> > >> cgroup_mutex -> mem_hotplug_lock deadlock described above.
> > >>
> > >> In the original deadlock that I described, the workaround is to
> > >> replace crash dump from piping to Linux traditional save to files
> > >> method. However, after trying this workaround, I still observed
> > >> hardware watchdog resets during machine  shutdown.
> > >>
> > >> The new problem occurs for the following reason: upon shutdown systemd
> > >> calls a service that hot-removes memory, and if hot-removing fails for
> > >
> > > Why is that hotremove even needed if we're shutting down? Are there any
> > > (virtualization?) platforms where it makes some difference over plain
> > > shutdown/restart?
> >
> > If all it‘s doing is offlining random memory that sounds unnecessary and dangerous. Any pointers to this service so we can figure out what it‘s doing and why? (Arch? Hypervisor?)
> 
> Hi David,
> 
> This is how we are using it at Microsoft: there is  a very large
> number of small memory machines (8G each) with low downtime
> requirements (reboot must be under a second). There is also a large
> state ~2G of memory that we need to transfer during reboot, otherwise
> it is very expensive to recreate the state. We have 2G of system
> memory memory reserved as a pmem in the device tree, and use it to
> pass information across reboots. Once the information is not needed we
> hot-add that memory and use it during runtime, before shutdown we
> hot-remove the 2G, save the program state on it, and do the reboot.

I still do not get it. So what does guarantee that the memory is
offlineable in the first place? Also what is the difference between
offlining and simply shutting the system down so that the memory is not
used in the first place. In other words what kind of difference
hotremove makes?
-- 
Michal Hocko
SUSE Labs
