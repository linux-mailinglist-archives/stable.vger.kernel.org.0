Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F12686A2
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 09:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgINH6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 03:58:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbgINH6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 03:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=h0bhWmLoKea/AEkiRgES+kLKRF0/G4ce6BkBcXGTyOU=;
        b=fsM8BjFQGiem/r9UyRQYNdP1VM/r6oU07TRpw/BA3oCiGM+s0uzzYenAx2QWUw8GQnaNUI
        r2+sWR0mvlbX2BQFnTH2konL3DzIKuBhDh/3ipy9Z+OBf3anDTUCyA0WQ+OJxsluovmwmJ
        aUUOUXgwIVsAwIrsiG5bl1wKjgyYXZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-arPjDkUzON-8Ur0-CD1VTA-1; Mon, 14 Sep 2020 03:57:55 -0400
X-MC-Unique: arPjDkUzON-8Ur0-CD1VTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DCF785C706;
        Mon, 14 Sep 2020 07:57:52 +0000 (UTC)
Received: from [10.36.114.162] (ovpn-114-162.ams2.redhat.com [10.36.114.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBB3F7B7B6;
        Mon, 14 Sep 2020 07:57:47 +0000 (UTC)
Subject: Re: [PATCH 2/3] mm: don't rely on system state to detect hot-plug
 operations
To:     Laurent Dufour <ldufour@linux.ibm.com>, akpm@linux-foundation.org,
        Oscar Salvador <osalvador@suse.de>, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
References: <20200911134831.53258-1-ldufour@linux.ibm.com>
 <20200911134831.53258-3-ldufour@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <f50fe4ae-faf0-6e03-b87e-45ca8c53960d@redhat.com>
Date:   Mon, 14 Sep 2020 09:57:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200911134831.53258-3-ldufour@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11.09.20 15:48, Laurent Dufour wrote:
> In register_mem_sect_under_node() the system_state’s value is checked to
> detect whether the operation the call is made during boot time or during an
> hot-plug operation. Unfortunately, that check against SYSTEM_BOOTING is
> wrong because regular memory is registered at SYSTEM_SCHEDULING state. In
> addition memory hot-plug operation can be triggered at this system state
> too by the ACPI. So checking against the system state is not enough.
> 
> The consequence is that on system with interleaved node's ranges like this:
>  Early memory node ranges
>    node   1: [mem 0x0000000000000000-0x000000011fffffff]
>    node   2: [mem 0x0000000120000000-0x000000014fffffff]
>    node   1: [mem 0x0000000150000000-0x00000001ffffffff]
>    node   0: [mem 0x0000000200000000-0x000000048fffffff]
>    node   2: [mem 0x0000000490000000-0x00000007ffffffff]
> 
> This can be seen on PowerPC LPAR after multiple memory hot-plug and
> hot-unplug operations are done. At the next reboot the node's memory ranges
> can be interleaved and since the call to link_mem_sections() is made in
> topology_init() while the system is in the SYSTEM_SCHEDULING state, the
> node's id is not checked, and the sections registered to multiple nodes:
> 
> $ ls -l /sys/devices/system/memory/memory21/node*
> total 0
> lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
> lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2
> 
> In that case, the system is able to boot but if later one of theses memory
> block is hot-unplugged and then hot-plugged, the sysfs inconsistency is
> detected and triggered a BUG_ON():
> 
> ------------[ cut here ]------------
> kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
> Oops: Exception in kernel mode, sig: 5 [#1]
> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
> CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
> NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
> REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
> MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
> CFAR: c000000000846d20 IRQMASK: 0
> GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
> GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
> GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
> GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
> GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
> GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
> GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
> GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
> NIP [c000000000403f34] add_memory_resource+0x244/0x340
> LR [c000000000403f2c] add_memory_resource+0x23c/0x340
> Call Trace:
> [c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
> [c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
> [c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
> [c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
> [c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
> [c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
> [c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
> [c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
> [c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
> [c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
> [c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
> [c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
> [c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
> Instruction dump:
> 48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
> 78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
> ---[ end trace 562fd6c109cd0fb2 ]---
> 
> This patch addresses the root cause by not relying on the system_state
> value to detect whether the call is due to a hot-plug operation. An extra
> parameter is needed in register_mem_sect_under_node() detailing whether the
> operation is due to a hot-plug operation.
> 
> Fixes: 4fbce633910e ("mm/memory_hotplug.c: make register_mem_sect_under_node() a callback of walk_memory_range()")
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: David Hildenbrand <david@redhat.com>
> ---
>  drivers/base/node.c  | 21 ++++++++++++++++-----
>  include/linux/node.h |  9 ++++++---
>  mm/memory_hotplug.c  |  3 ++-
>  3 files changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 508b80f6329b..862516c5a5ae 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -762,14 +762,19 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
>  }
>  
>  /* register memory section under specified node if it spans that node */
> +struct rmsun_args {
> +	int nid;
> +	enum memplug_context context;
> +};
>  static int register_mem_sect_under_node(struct memory_block *mem_blk,
> -					 void *arg)
> +					void *args)
>  {

Instead of handling this in register_mem_sect_under_node(), I
think it would be better two have two separate
register_mem_sect_under_node() implementations.

static int register_mem_sect_under_node_hotplug(struct memory_block *mem_blk,
						void *arg)
{
	const int nid = *(int *)arg;
	int ret;

	/* Hotplugged memory has no holes and belongs to a single node. */
	mem_blk->nid = nid;
	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
				       &mem_blk->dev.kobj,
				       kobject_name(&mem_blk->dev.kobj));
	if (ret)
		returnr et;
	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
					&node_devices[nid]->dev.kobj,
					kobject_name(&node_devices[nid]->dev.kobj));

}

Cleaner, right? :) No unnecessary checks.

One could argue if link_mem_section_hotplug() would be better than passing around the context.

-- 
Thanks,

David / dhildenb

