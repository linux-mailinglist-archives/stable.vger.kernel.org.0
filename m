Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE211679D9
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 10:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgBUJvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 04:51:32 -0500
Received: from foss.arm.com ([217.140.110.172]:35338 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbgBUJvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 04:51:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55EFD31B;
        Fri, 21 Feb 2020 01:51:31 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 069A63F68F;
        Fri, 21 Feb 2020 01:51:29 -0800 (PST)
Date:   Fri, 21 Feb 2020 09:51:27 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 254/344] ACPI/IORT: Fix Number of IDs handling in
 iort_id_map()
Message-ID: <20200221095127.GB29220@e121166-lin.cambridge.arm.com>
References: <20200221072349.335551332@linuxfoundation.org>
 <20200221072412.606392874@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221072412.606392874@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 08:40:53AM +0100, Greg Kroah-Hartman wrote:
> From: Hanjun Guo <guohanjun@huawei.com>
> 
> [ Upstream commit 3c23b83a88d00383e1d498cfa515249aa2fe0238 ]

Hi Greg,

this patch should be dropped from the stable queue, thanks.

Lorenzo

> The IORT specification [0] (Section 3, table 4, page 9) defines the
> 'Number of IDs' as 'The number of IDs in the range minus one'.
> 
> However, the IORT ID mapping function iort_id_map() treats the 'Number
> of IDs' field as if it were the full IDs mapping count, with the
> following check in place to detect out of boundary input IDs:
> 
> InputID >= Input base + Number of IDs
> 
> This check is flawed in that it considers the 'Number of IDs' field as
> the full number of IDs mapping and disregards the 'minus one' from
> the IDs count.
> 
> The correct check in iort_id_map() should be implemented as:
> 
> InputID > Input base + Number of IDs
> 
> this implements the specification correctly but unfortunately it breaks
> existing firmwares that erroneously set the 'Number of IDs' as the full
> IDs mapping count rather than IDs mapping count minus one.
> 
> e.g.
> 
> PCI hostbridge mapping entry 1:
> Input base:  0x1000
> ID Count:    0x100
> Output base: 0x1000
> Output reference: 0xC4  //ITS reference
> 
> PCI hostbridge mapping entry 2:
> Input base:  0x1100
> ID Count:    0x100
> Output base: 0x2000
> Output reference: 0xD4  //ITS reference
> 
> Two mapping entries which the second entry's Input base = the first
> entry's Input base + ID count, so for InputID 0x1100 and with the
> correct InputID check in place in iort_id_map() the kernel would map
> the InputID to ITS 0xC4 not 0xD4 as it would be expected.
> 
> Therefore, to keep supporting existing flawed firmwares, introduce a
> workaround that instructs the kernel to use the old InputID range check
> logic in iort_id_map(), so that we can support both firmwares written
> with the flawed 'Number of IDs' logic and the correct one as defined in
> the specifications.
> 
> [0]: http://infocenter.arm.com/help/topic/com.arm.doc.den0049d/DEN0049D_IO_Remapping_Table.pdf
> 
> Reported-by: Pankaj Bansal <pankaj.bansal@nxp.com>
> Link: https://lore.kernel.org/linux-acpi/20191215203303.29811-1-pankaj.bansal@nxp.com/
> Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Pankaj Bansal <pankaj.bansal@nxp.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/acpi/arm64/iort.c | 57 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
> index 5a7551d060f25..161b609e4cdfb 100644
> --- a/drivers/acpi/arm64/iort.c
> +++ b/drivers/acpi/arm64/iort.c
> @@ -298,6 +298,59 @@ out:
>  	return status;
>  }
>  
> +struct iort_workaround_oem_info {
> +	char oem_id[ACPI_OEM_ID_SIZE + 1];
> +	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE + 1];
> +	u32 oem_revision;
> +};
> +
> +static bool apply_id_count_workaround;
> +
> +static struct iort_workaround_oem_info wa_info[] __initdata = {
> +	{
> +		.oem_id		= "HISI  ",
> +		.oem_table_id	= "HIP07   ",
> +		.oem_revision	= 0,
> +	}, {
> +		.oem_id		= "HISI  ",
> +		.oem_table_id	= "HIP08   ",
> +		.oem_revision	= 0,
> +	}
> +};
> +
> +static void __init
> +iort_check_id_count_workaround(struct acpi_table_header *tbl)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wa_info); i++) {
> +		if (!memcmp(wa_info[i].oem_id, tbl->oem_id, ACPI_OEM_ID_SIZE) &&
> +		    !memcmp(wa_info[i].oem_table_id, tbl->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
> +		    wa_info[i].oem_revision == tbl->oem_revision) {
> +			apply_id_count_workaround = true;
> +			pr_warn(FW_BUG "ID count for ID mapping entry is wrong, applying workaround\n");
> +			break;
> +		}
> +	}
> +}
> +
> +static inline u32 iort_get_map_max(struct acpi_iort_id_mapping *map)
> +{
> +	u32 map_max = map->input_base + map->id_count;
> +
> +	/*
> +	 * The IORT specification revision D (Section 3, table 4, page 9) says
> +	 * Number of IDs = The number of IDs in the range minus one, but the
> +	 * IORT code ignored the "minus one", and some firmware did that too,
> +	 * so apply a workaround here to keep compatible with both the spec
> +	 * compliant and non-spec compliant firmwares.
> +	 */
> +	if (apply_id_count_workaround)
> +		map_max--;
> +
> +	return map_max;
> +}
> +
>  static int iort_id_map(struct acpi_iort_id_mapping *map, u8 type, u32 rid_in,
>  		       u32 *rid_out)
>  {
> @@ -314,8 +367,7 @@ static int iort_id_map(struct acpi_iort_id_mapping *map, u8 type, u32 rid_in,
>  		return -ENXIO;
>  	}
>  
> -	if (rid_in < map->input_base ||
> -	    (rid_in >= map->input_base + map->id_count))
> +	if (rid_in < map->input_base || rid_in > iort_get_map_max(map))
>  		return -ENXIO;
>  
>  	*rid_out = map->output_base + (rid_in - map->input_base);
> @@ -1637,5 +1689,6 @@ void __init acpi_iort_init(void)
>  		return;
>  	}
>  
> +	iort_check_id_count_workaround(iort_table);
>  	iort_init_platform_devices();
>  }
> -- 
> 2.20.1
> 
> 
> 
