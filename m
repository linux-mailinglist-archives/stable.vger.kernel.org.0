Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E661C96B8
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 18:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgEGQnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 12:43:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:35442 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGQnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 12:43:09 -0400
IronPort-SDR: TOzCWlRXve9umestuUJRWiLAxbt/JwHWMvK9N5gndSGEcBe6QIOB/ahiad2XdfGv6yyuPzdaQQ
 9/1+svVfyf+Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 09:43:07 -0700
IronPort-SDR: CiHmnCmP3XUkgB4RURPDa7Bn0OXxk+KACt0xAbpZEi/bg3lN152KAVipouD2fXjh7cwhmsXwNE
 psJmAwc5wLGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="251556357"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.152.102]) ([10.249.152.102])
  by fmsmga008.fm.intel.com with ESMTP; 07 May 2020 09:43:03 -0700
Subject: Re: [PATCH] ACPI: Drop rcu usage for MMIO mappings
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     stable@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Ira Weiny <ira.weiny@intel.com>,
        James Morse <james.morse@arm.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
References: <158880834905.2183490.15616329469420234017.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <bd3963f3-c6d6-f138-331c-9ac065633491@intel.com>
Date:   Thu, 7 May 2020 18:43:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <158880834905.2183490.15616329469420234017.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/7/2020 1:39 AM, Dan Williams wrote:
> Recently a performance problem was reported for a process invoking a
> non-trival ASL program. The method call in this case ends up
> repetitively triggering a call path like:
>
>      acpi_ex_store
>      acpi_ex_store_object_to_node
>      acpi_ex_write_data_to_field
>      acpi_ex_insert_into_field
>      acpi_ex_write_with_update_rule
>      acpi_ex_field_datum_io
>      acpi_ex_access_region
>      acpi_ev_address_space_dispatch
>      acpi_ex_system_memory_space_handler
>      acpi_os_map_cleanup.part.14
>      _synchronize_rcu_expedited.constprop.89
>      schedule
>
> The end result of frequent synchronize_rcu_expedited() invocation is
> tiny sub-millisecond spurts of execution where the scheduler freely
> migrates this apparently sleepy task. The overhead of frequent scheduler
> invocation multiplies the execution time by a factor of 2-3X.
>
> For example, performance improves from 16 minutes to 7 minutes for a
> firmware update procedure across 24 devices.
>
> Perhaps the rcu usage was intended to allow for not taking a sleeping
> lock in the acpi_os_{read,write}_memory() path which ostensibly could be
> called from an APEI NMI error interrupt? Neither rcu_read_lock() nor
> ioremap() are interrupt safe, so add a WARN_ONCE() to validate that rcu
> was not serving as a mechanism to avoid direct calls to ioremap(). Even
> the original implementation had a spin_lock_irqsave(), but that is not
> NMI safe.
>
> APEI itself already has some concept of avoiding ioremap() from
> interrupt context (see erst_exec_move_data()), if the new warning
> triggers it means that APEI either needs more instrumentation like that
> to pre-emptively fail, or more infrastructure to arrange for pre-mapping
> the resources it needs in NMI context.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 620242ae8c3d ("ACPI: Maintain a list of ACPI memory mapped I/O remappings")
> Cc: Len Brown <lenb@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Erik Kaneda <erik.kaneda@intel.com>
> Cc: Myron Stowe <myron.stowe@redhat.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

linux-acpi is kind of relevant for this too, so please CC it.


> ---
>   drivers/acpi/osl.c |  117 +++++++++++++++++++++++++---------------------------
>   1 file changed, 57 insertions(+), 60 deletions(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 762c5d50b8fe..207528c71e9c 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -214,13 +214,13 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
>   	return pa;
>   }
>   
> -/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
>   static struct acpi_ioremap *
>   acpi_map_lookup(acpi_physical_address phys, acpi_size size)
>   {
>   	struct acpi_ioremap *map;
>   
> -	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
> +	lockdep_assert_held(&acpi_ioremap_lock);
> +	list_for_each_entry(map, &acpi_ioremaps, list)
>   		if (map->phys <= phys &&
>   		    phys + size <= map->phys + map->size)
>   			return map;
> @@ -228,7 +228,6 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
>   	return NULL;
>   }
>   
> -/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
>   static void __iomem *
>   acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
>   {
> @@ -263,7 +262,8 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
>   {
>   	struct acpi_ioremap *map;
>   
> -	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
> +	lockdep_assert_held(&acpi_ioremap_lock);
> +	list_for_each_entry(map, &acpi_ioremaps, list)
>   		if (map->virt <= virt &&
>   		    virt + size <= map->virt + map->size)
>   			return map;
> @@ -360,7 +360,7 @@ void __iomem __ref
>   	map->size = pg_sz;
>   	map->refcount = 1;
>   
> -	list_add_tail_rcu(&map->list, &acpi_ioremaps);
> +	list_add_tail(&map->list, &acpi_ioremaps);
>   
>   out:
>   	mutex_unlock(&acpi_ioremap_lock);
> @@ -374,20 +374,13 @@ void *__ref acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
>   }
>   EXPORT_SYMBOL_GPL(acpi_os_map_memory);
>   
> -/* Must be called with mutex_lock(&acpi_ioremap_lock) */
> -static unsigned long acpi_os_drop_map_ref(struct acpi_ioremap *map)
> -{
> -	unsigned long refcount = --map->refcount;
> -
> -	if (!refcount)
> -		list_del_rcu(&map->list);
> -	return refcount;
> -}
> -
> -static void acpi_os_map_cleanup(struct acpi_ioremap *map)
> +static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
>   {
> -	synchronize_rcu_expedited();
> +	lockdep_assert_held(&acpi_ioremap_lock);
> +	if (--map->refcount > 0)
> +		return;
>   	acpi_unmap(map->phys, map->virt);
> +	list_del(&map->list);
>   	kfree(map);
>   }
>   
> @@ -408,7 +401,6 @@ static void acpi_os_map_cleanup(struct acpi_ioremap *map)
>   void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
>   {
>   	struct acpi_ioremap *map;
> -	unsigned long refcount;
>   
>   	if (!acpi_permanent_mmap) {
>   		__acpi_unmap_table(virt, size);
> @@ -422,11 +414,8 @@ void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
>   		WARN(true, PREFIX "%s: bad address %p\n", __func__, virt);
>   		return;
>   	}
> -	refcount = acpi_os_drop_map_ref(map);
> +	acpi_os_drop_map_ref(map);
>   	mutex_unlock(&acpi_ioremap_lock);
> -
> -	if (!refcount)
> -		acpi_os_map_cleanup(map);
>   }
>   EXPORT_SYMBOL_GPL(acpi_os_unmap_iomem);
>   
> @@ -461,7 +450,6 @@ void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
>   {
>   	u64 addr;
>   	struct acpi_ioremap *map;
> -	unsigned long refcount;
>   
>   	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
>   		return;
> @@ -477,11 +465,8 @@ void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
>   		mutex_unlock(&acpi_ioremap_lock);
>   		return;
>   	}
> -	refcount = acpi_os_drop_map_ref(map);
> +	acpi_os_drop_map_ref(map);
>   	mutex_unlock(&acpi_ioremap_lock);
> -
> -	if (!refcount)
> -		acpi_os_map_cleanup(map);
>   }
>   EXPORT_SYMBOL(acpi_os_unmap_generic_address);
>   
> @@ -700,55 +685,71 @@ int acpi_os_read_iomem(void __iomem *virt_addr, u64 *value, u32 width)
>   	return 0;
>   }
>   
> +static void __iomem *acpi_os_rw_map(acpi_physical_address phys_addr,
> +				    unsigned int size, bool *did_fallback)
> +{
> +	void __iomem *virt_addr = NULL;
> +
> +	if (WARN_ONCE(in_interrupt(), "ioremap in interrupt context\n"))
> +		return NULL;
> +
> +	/* Try to use a cached mapping and fallback otherwise */
> +	*did_fallback = false;
> +	mutex_lock(&acpi_ioremap_lock);
> +	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
> +	if (virt_addr)
> +		return virt_addr;
> +	mutex_unlock(&acpi_ioremap_lock);
> +
> +	virt_addr = acpi_os_ioremap(phys_addr, size);
> +	*did_fallback = true;
> +
> +	return virt_addr;
> +}
> +
> +static void acpi_os_rw_unmap(void __iomem *virt_addr, bool did_fallback)
> +{
> +	if (did_fallback) {
> +		/* in the fallback case no lock is held */
> +		iounmap(virt_addr);
> +		return;
> +	}
> +
> +	mutex_unlock(&acpi_ioremap_lock);
> +}
> +
>   acpi_status
>   acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
>   {
> -	void __iomem *virt_addr;
>   	unsigned int size = width / 8;
> -	bool unmap = false;
> +	bool did_fallback = false;
> +	void __iomem *virt_addr;
>   	u64 dummy;
>   	int error;
>   
> -	rcu_read_lock();
> -	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
> -	if (!virt_addr) {
> -		rcu_read_unlock();
> -		virt_addr = acpi_os_ioremap(phys_addr, size);
> -		if (!virt_addr)
> -			return AE_BAD_ADDRESS;
> -		unmap = true;
> -	}
> -
> +	virt_addr = acpi_os_rw_map(phys_addr, size, &did_fallback);
> +	if (!virt_addr)
> +		return AE_BAD_ADDRESS;
>   	if (!value)
>   		value = &dummy;
>   
>   	error = acpi_os_read_iomem(virt_addr, value, width);
>   	BUG_ON(error);
>   
> -	if (unmap)
> -		iounmap(virt_addr);
> -	else
> -		rcu_read_unlock();
> -
> +	acpi_os_rw_unmap(virt_addr, did_fallback);
>   	return AE_OK;
>   }
>   
>   acpi_status
>   acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
>   {
> -	void __iomem *virt_addr;
>   	unsigned int size = width / 8;
> -	bool unmap = false;
> +	bool did_fallback = false;
> +	void __iomem *virt_addr;
>   
> -	rcu_read_lock();
> -	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
> -	if (!virt_addr) {
> -		rcu_read_unlock();
> -		virt_addr = acpi_os_ioremap(phys_addr, size);
> -		if (!virt_addr)
> -			return AE_BAD_ADDRESS;
> -		unmap = true;
> -	}
> +	virt_addr = acpi_os_rw_map(phys_addr, size, &did_fallback);
> +	if (!virt_addr)
> +		return AE_BAD_ADDRESS;
>   
>   	switch (width) {
>   	case 8:
> @@ -767,11 +768,7 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
>   		BUG();
>   	}
>   
> -	if (unmap)
> -		iounmap(virt_addr);
> -	else
> -		rcu_read_unlock();
> -
> +	acpi_os_rw_unmap(virt_addr, did_fallback);
>   	return AE_OK;
>   }
>   
>

