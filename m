Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634682645AF
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgIJMFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 08:05:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:42522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730396AbgIJME1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 08:04:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66909AD52;
        Thu, 10 Sep 2020 12:04:06 +0000 (UTC)
Date:   Thu, 10 Sep 2020 14:03:48 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org,
        David Hildenbrand <david@redhat.com>, rafael@kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20200910120343.GA6635@linux>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 10, 2020 at 01:35:32PM +0200, Laurent Dufour wrote:
 
> That points has been raised by David, quoting him here:
> 
> > IIRC, ACPI can hotadd memory while SCHEDULING, this patch would break that.
> > 
> > Ccing Oscar, I think he mentioned recently that this is the case with ACPI.
> 
> Oscar told that he need to investigate further on that.

I think my reply got lost.

We can see acpi hotplugs during SYSTEM_SCHEDULING:

$QEMU -enable-kvm -machine pc -smp 4,sockets=4,cores=1,threads=1 -cpu host -monitor pty \
        -m size=$MEM,slots=255,maxmem=4294967296k  \
        -numa node,nodeid=0,cpus=0-3,mem=512 -numa node,nodeid=1,mem=512 \
        -object memory-backend-ram,id=memdimm0,size=134217728 -device pc-dimm,node=0,memdev=memdimm0,id=dimm0,slot=0 \
        -object memory-backend-ram,id=memdimm1,size=134217728 -device pc-dimm,node=0,memdev=memdimm1,id=dimm1,slot=1 \
        -object memory-backend-ram,id=memdimm2,size=134217728 -device pc-dimm,node=0,memdev=memdimm2,id=dimm2,slot=2 \
        -object memory-backend-ram,id=memdimm3,size=134217728 -device pc-dimm,node=0,memdev=memdimm3,id=dimm3,slot=3 \
        -object memory-backend-ram,id=memdimm4,size=134217728 -device pc-dimm,node=1,memdev=memdimm4,id=dimm4,slot=4 \
        -object memory-backend-ram,id=memdimm5,size=134217728 -device pc-dimm,node=1,memdev=memdimm5,id=dimm5,slot=5 \
        -object memory-backend-ram,id=memdimm6,size=134217728 -device pc-dimm,node=1,memdev=memdimm6,id=dimm6,slot=6 \

kernel: [    0.753643] __add_memory: nid: 0 start: 0100000000 - 0108000000 (size: 134217728)
kernel: [    0.756950] register_mem_sect_under_node: system_state= 1

kernel: [    0.760811]  register_mem_sect_under_node+0x4f/0x230
kernel: [    0.760811]  walk_memory_blocks+0x80/0xc0
kernel: [    0.760811]  link_mem_sections+0x32/0x40
kernel: [    0.760811]  add_memory_resource+0x148/0x250
kernel: [    0.760811]  __add_memory+0x5b/0x90
kernel: [    0.760811]  acpi_memory_device_add+0x130/0x300
kernel: [    0.760811]  acpi_bus_attach+0x13c/0x1c0
kernel: [    0.760811]  acpi_bus_attach+0x60/0x1c0
kernel: [    0.760811]  acpi_bus_scan+0x33/0x70
kernel: [    0.760811]  acpi_scan_init+0xea/0x21b
kernel: [    0.760811]  acpi_init+0x2f1/0x33c
kernel: [    0.760811]  do_one_initcall+0x46/0x1f4



-- 
Oscar Salvador
SUSE L3
