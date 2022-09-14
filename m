Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E56E5B8FDF
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 23:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiINVEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 17:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiINVEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 17:04:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 468FEDFEE;
        Wed, 14 Sep 2022 14:04:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7121D1576;
        Wed, 14 Sep 2022 14:04:40 -0700 (PDT)
Received: from [10.57.18.118] (unknown [10.57.18.118])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B48C83F73B;
        Wed, 14 Sep 2022 14:04:32 -0700 (PDT)
Message-ID: <22464516-0235-dddf-09e4-6f4580b04869@arm.com>
Date:   Wed, 14 Sep 2022 22:04:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/2] iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and
 ivrs_acpihid options
Content-Language: en-GB
To:     Kim Phillips <kim.phillips@amd.com>, iommu@lists.linux.dev,
        joro@8bytes.org
Cc:     suravee.suthikulpanit@amd.com, vasant.hegde@amd.com,
        Mike Day <michael.day@amd.com>, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
References: <20220914190330.60779-1-kim.phillips@amd.com>
 <20220914190330.60779-2-kim.phillips@amd.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220914190330.60779-2-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-09-14 20:03, Kim Phillips wrote:
> Currently, these options cause the following libkmod error:
> 
> libkmod: ERROR ../libkmod/libkmod-config.c:489 kcmdline_parse_result: \
> 	Ignoring bad option on kernel command line while parsing module \
> 	name: 'ivrs_xxxx[XX:XX'
> 
> Fix by introducing a new parameter format for these options and
> throw a warning for the deprecated format.
> 
> Users are still allowed to omit the PCI Segment if zero.
> 
> Adding a Link: to the reason why we're modding the syntax parsing
> in the driver and not in libkmod.
> 
> Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-modules/20200310082308.14318-2-lucas.demarchi@intel.com/
> Reported-by: Kim Phillips <kim.phillips@amd.com>
> Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>   .../admin-guide/kernel-parameters.txt         | 27 +++++--
>   drivers/iommu/amd/init.c                      | 79 +++++++++++++------
>   2 files changed, 76 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index d7f30902fda0..23666104ab9b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2294,7 +2294,13 @@
>   			Provide an override to the IOAPIC-ID<->DEVICE-ID
>   			mapping provided in the IVRS ACPI table.
>   			By default, PCI segment is 0, and can be omitted.
> -			For example:

I wonder if it might be helpful to cross-reference the "pci=" option and 
spell out the general "<id>@<pci_dev>" format?

> +
> +			For example, to map IOAPIC-ID decimal 10 to
> +			PCI segment 0x1 and PCI device 00:14.0,
> +			write the parameter as:
> +				ivrs_ioapic=10@0001:00:14.0
> +
> +			Deprecated formats:
>   			* To map IOAPIC-ID decimal 10 to PCI device 00:14.0
>   			  write the parameter as:
>   				ivrs_ioapic[10]=00:14.0

...then we could just say that there's also a deprecated 
"ivrs_ioapic[<id>]=<pci_dev>" form. But then maybe it's hard to 
concisely express that the [] are literal here rather than denoting an 
optional value like everywhere else, Hmm...

Anyway, my underlying thought here is that providing an equally detailed 
example of what people shouldn't use as of what they should seems 
somewhat at odds with the message that they shouldn't be using it.

> @@ -2306,7 +2312,13 @@
>   			Provide an override to the HPET-ID<->DEVICE-ID
>   			mapping provided in the IVRS ACPI table.
>   			By default, PCI segment is 0, and can be omitted.
> -			For example:
> +
> +			For example, to map HPET-ID decimal 10 to
> +			PCI segment 0x1 and PCI device 00:14.0,
> +			write the parameter as:
> +				ivrs_ioapic=10@0001:00:14.0
> +
> +			Deprecated formats:
>   			* To map HPET-ID decimal 0 to PCI device 00:14.0
>   			  write the parameter as:
>   				ivrs_hpet[0]=00:14.0
> @@ -2317,15 +2329,20 @@
>   	ivrs_acpihid	[HW,X86-64]
>   			Provide an override to the ACPI-HID:UID<->DEVICE-ID
>   			mapping provided in the IVRS ACPI table.
> +			By default, PCI segment is 0, and can be omitted.
>   
>   			For example, to map UART-HID:UID AMD0020:0 to
>   			PCI segment 0x1 and PCI device ID 00:14.5,
>   			write the parameter as:
> -				ivrs_acpihid[0001:00:14.5]=AMD0020:0
> +				ivrs_acpihid=AMD0020:0@0001:00:14.5
>   
> -			By default, PCI segment is 0, and can be omitted.
> -			For example, PCI device 00:14.5 write the parameter as:
> +			Deprecated formats:
> +			* To map UART-HID:UID AMD0020:0 to PCI segment is 0,
> +			  PCI device ID 00:14.5, write the parameter as:
>   				ivrs_acpihid[00:14.5]=AMD0020:0
> +			* To map UART-HID:UID AMD0020:0 to PCI segment 0x1 and
> +			  PCI device ID 00:14.5, write the parameter as:
> +				ivrs_acpihid[0001:00:14.5]=AMD0020:0
>   
>   	js=		[HW,JOY] Analog joystick
>   			See Documentation/input/joydev/joystick.rst.
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index ef0e1a4b5a11..13c6b581549c 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3385,18 +3385,24 @@ static int __init parse_amd_iommu_options(char *str)
>   static int __init parse_ivrs_ioapic(char *str)
>   {
>   	u32 seg = 0, bus, dev, fn;
> -	int ret, id, i;
> +	int id, i;
>   	u32 devid;
>   
> -	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
> -	if (ret != 4) {
> -		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
> -		if (ret != 5) {
> -			pr_err("Invalid command line: ivrs_ioapic%s\n", str);
> -			return 1;
> -		}
> +	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
> +	    sscanf(str, "=", &id, &seg, &bus, &dev, &fn) == 5)
> +		goto found;
> +
> +	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
> +	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
> +		pr_warn("Deprecated option : ivrs_ioapic%s\n", str);

 From a user PoV this message seems unfairly confusing, since it's not 
actually the option that's deprecated, it's the format of the value of 
the option...

> +		pr_warn("Please see kernel parameters document and update the option.\n");

...and having messages split across multiple lines that get interleaved 
with other output, and are twice as wordy to be unhelpful than to simply 
say what was expected, is even less pleasant.

I'd suggest:

		pr_warn("ivrs_ioapic%s option format deprecated; use 
ivrs_ioapic=%d@%04x:%02x:%02x.%d instead\n",
			str, id, seg, bus, dev, fn);

which is concise* and consistent with how other deprecated IOMMU options 
are reported; It's not like we didn't understand what was passed, so we 
may as well make it as easy as copy-paste for the user to do what we're 
asking. Similarly for the others below.

Thanks,
Robin.


*Yes, it's a fairly long line. Screens are wide these days.

> +		goto found;
>   	}
>   
> +	pr_err("Invalid command line: ivrs_ioapic%s\n", str);
> +	return 1;
> +
> +found:
>   	if (early_ioapic_map_size == EARLY_MAP_SIZE) {
>   		pr_err("Early IOAPIC map overflow - ignoring ivrs_ioapic%s\n",
>   			str);
> @@ -3417,18 +3423,24 @@ static int __init parse_ivrs_ioapic(char *str)
>   static int __init parse_ivrs_hpet(char *str)
>   {
>   	u32 seg = 0, bus, dev, fn;
> -	int ret, id, i;
> +	int id, i;
>   	u32 devid;
>   
> -	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
> -	if (ret != 4) {
> -		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
> -		if (ret != 5) {
> -			pr_err("Invalid command line: ivrs_hpet%s\n", str);
> -			return 1;
> -		}
> +	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
> +	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
> +		goto found;
> +
> +	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
> +	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
> +		pr_warn("Deprecated option : ivrs_hpet%s\n", str);
> +		pr_warn("Please see kernel parameters document and update the option.\n");
> +		goto found;
>   	}
>   
> +	pr_err("Invalid command line: ivrs_hpet%s\n", str);
> +	return 1;
> +
> +found:
>   	if (early_hpet_map_size == EARLY_MAP_SIZE) {
>   		pr_err("Early HPET map overflow - ignoring ivrs_hpet%s\n",
>   			str);
> @@ -3449,19 +3461,36 @@ static int __init parse_ivrs_hpet(char *str)
>   static int __init parse_ivrs_acpihid(char *str)
>   {
>   	u32 seg = 0, bus, dev, fn;
> -	char *hid, *uid, *p;
> +	char *hid, *uid, *p, *addr;
>   	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
> -	int ret, i;
> -
> -	ret = sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid);
> -	if (ret != 4) {
> -		ret = sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid);
> -		if (ret != 5) {
> -			pr_err("Invalid command line: ivrs_acpihid(%s)\n", str);
> -			return 1;
> +	int i;
> +
> +	addr = strchr(str, '@');
> +	if (!addr) {
> +		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
> +		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
> +			pr_warn("Deprecated option: ivrs_acpihid%s\n", str);
> +			pr_warn("Please see kernel parameters document and update the option.\n");
> +			goto found;
>   		}
> +		goto not_found;
>   	}
>   
> +	/* We have the '@', make it the terminator to get just the acpiid */
> +	*addr++ = 0;
> +
> +	if (sscanf(str, "=%s", acpiid) != 1)
> +		goto not_found;
> +
> +	if (sscanf(addr, "%x:%x.%x", &bus, &dev, &fn) == 3 ||
> +	    sscanf(addr, "%x:%x:%x.%x", &seg, &bus, &dev, &fn) == 4)
> +		goto found;
> +
> +not_found:
> +	pr_err("Invalid command line: ivrs_acpihid%s\n", str);
> +	return 1;
> +
> +found:
>   	p = acpiid;
>   	hid = strsep(&p, ":");
>   	uid = p;
