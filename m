Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7954170FD
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 13:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbhIXLls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 07:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244321AbhIXLlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 07:41:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D17B60F3A;
        Fri, 24 Sep 2021 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632483614;
        bh=U9aS5K/IyRoueg05i1FbrwWdjKbIDOwphKq3cblgnCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n2uXgsbtQVwxAFdtxZEOKcqnlPNaO2iKEdETCo8iA2FEEft0f5Zkih4jYQVwrUtmc
         4ODCWECQAQH4mswHXXrUwA4r89+EzTpi18OPHTJIgesdfKL1my6FcSfWiBEkXo4GHc
         n22mgc2VfEnxnbWCYpJOi4aB9+RHcFAp1TW0up5ww6wJ3GRB3Bo+6UJGq/PpSUXGXC
         8IJIGaPixRc7t77SyksWH4EfeFXsOSV3fhYkScY3L+EpEgL28tfW5A6XKdwwdQ/fZI
         SrFj4lljfBJe3EuyXIzzx4wHhrOO5jDqeuBkKZcX557yu5Z+gWnFvBW066wOmXbzoS
         wZaewpBVm6yvw==
Date:   Fri, 24 Sep 2021 07:40:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Maxwell Beck <max@ryt.one>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.14 10/25] ACPI: PM: s2idle: Run both AMD and
 Microsoft methods if both are supported
Message-ID: <YU25HdD95AhXgiH2@sashalap>
References: <20210913223339.435347-1-sashal@kernel.org>
 <20210913223339.435347-10-sashal@kernel.org>
 <SA0PR12MB451092FB36EAFACFCD928212E2A19@SA0PR12MB4510.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <SA0PR12MB451092FB36EAFACFCD928212E2A19@SA0PR12MB4510.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 02:57:26PM +0000, Limonciello, Mario wrote:
>[Public]
>
>> -----Original Message-----
>> From: Sasha Levin <sashal@kernel.org>
>> Sent: Monday, September 13, 2021 17:33
>> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
>> Cc: Limonciello, Mario <Mario.Limonciello@amd.com>; Maxwell Beck
>> <max@ryt.one>; Rafael J . Wysocki <rafael.j.wysocki@intel.com>; Sasha Levin
>> <sashal@kernel.org>; linux-acpi@vger.kernel.org
>> Subject: [PATCH AUTOSEL 5.14 10/25] ACPI: PM: s2idle: Run both AMD and
>> Microsoft methods if both are supported
>>
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> [ Upstream commit fa209644a7124b3f4cf811ced55daef49ae39ac6 ]
>>
>> It was reported that on "HP ENVY x360" that power LED does not come
>> back, certain keys like brightness controls do not work, and the fan
>> never spins up, even under load on 5.14 final.
>>
>> In analysis of the SSDT it's clear that the Microsoft UUID doesn't
>> provide functional support, but rather the AMD UUID should be
>> supporting this system.
>>
>> Because this is a gap in the expected logic, we checked back with
>> internal team.  The conclusion was that on Windows AMD uPEP *does*
>> run even when Microsoft UUID present, but most OEM systems have
>> adopted value of "0x3" for supported functions and hence nothing
>> runs.
>>
>> Henceforth add support for running both Microsoft and AMD methods.
>> This approach will also allow the same logic on Intel systems if
>> desired at a future time as well by pulling the evaluation of
>> `lps0_dsm_func_mask_microsoft` out of the `if` block for
>> `acpi_s2idle_vendor_amd`.
>>
>> Link:
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.fr
>> eedesktop.org%2Fdrm%2Famd%2Fuploads%2F9fbcd7ec3a385cc6949c9bacf45d
>> c41b%2Facpi-
>> f.20.bin&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Ce1f8dfc3d
>> bfb45fc44ef08d97706917f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C
>> 0%7C637671692363481559%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjA
>> wMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sda
>> ta=wP0oz8OMnby9PA4MFrbY1ZAT%2FKv1jctTyXl%2BDteNHqY%3D&amp;reserv
>> ed=0
>> BugLink:
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.fr
>> eedesktop.org%2Fdrm%2Famd%2F-
>> %2Fissues%2F1691&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7
>> Ce1f8dfc3dbfb45fc44ef08d97706917f%7C3dd8961fe4884e608e11a82d994e183
>> d%7C0%7C0%7C637671692363481559%7CUnknown%7CTWFpbGZsb3d8eyJWIj
>> oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C100
>> 0&amp;sdata=MVhVz%2BYBTdwgvkkSRRFsL5QdfDLPgTzoMBjD4dsFfMA%3D&a
>> mp;reserved=0
>> Reported-by: Maxwell Beck <max@ryt.one>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> [ rjw: Edits of the new comments ]
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/acpi/x86/s2idle.c | 67 +++++++++++++++++++++++----------------
>>  1 file changed, 39 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
>> index 3a308461246a..bd92b549fd5a 100644
>> --- a/drivers/acpi/x86/s2idle.c
>> +++ b/drivers/acpi/x86/s2idle.c
>> @@ -449,25 +449,30 @@ int acpi_s2idle_prepare_late(void)
>>  	if (pm_debug_messages_on)
>>  		lpi_check_constraints();
>>
>> -	if (lps0_dsm_func_mask_microsoft > 0) {
>> +	/* Screen off */
>> +	if (lps0_dsm_func_mask > 0)
>> +		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
>> +					ACPI_LPS0_SCREEN_OFF_AMD :
>> +					ACPI_LPS0_SCREEN_OFF,
>> +					lps0_dsm_func_mask, lps0_dsm_guid);
>> +
>> +	if (lps0_dsm_func_mask_microsoft > 0)
>>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF,
>>  				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_ENTRY,
>> -				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>> +
>> +	/* LPS0 entry */
>> +	if (lps0_dsm_func_mask > 0)
>> +		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
>> +					ACPI_LPS0_ENTRY_AMD :
>> +					ACPI_LPS0_ENTRY,
>> +					lps0_dsm_func_mask, lps0_dsm_guid);
>> +	if (lps0_dsm_func_mask_microsoft > 0) {
>>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY,
>>  				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>> -	} else if (acpi_s2idle_vendor_amd()) {
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF_AMD,
>> -				lps0_dsm_func_mask, lps0_dsm_guid);
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY_AMD,
>> -				lps0_dsm_func_mask, lps0_dsm_guid);
>> -	} else {
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF,
>> -				lps0_dsm_func_mask, lps0_dsm_guid);
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY,
>> -				lps0_dsm_func_mask, lps0_dsm_guid);
>> +		/* modern standby entry */
>> +		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_ENTRY,
>> +				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>>  	}
>> -
>>  	return 0;
>>  }
>>
>> @@ -476,24 +481,30 @@ void acpi_s2idle_restore_early(void)
>>  	if (!lps0_device_handle || sleep_no_lps0)
>>  		return;
>>
>> -	if (lps0_dsm_func_mask_microsoft > 0) {
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT,
>> -				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>> +	/* Modern standby exit */
>> +	if (lps0_dsm_func_mask_microsoft > 0)
>>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_EXIT,
>>  				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON,
>> -				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>> -	} else if (acpi_s2idle_vendor_amd()) {
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_AMD,
>> -				lps0_dsm_func_mask, lps0_dsm_guid);
>> -		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON_AMD,
>> -				lps0_dsm_func_mask, lps0_dsm_guid);
>> -	} else {
>> +
>> +	/* LPS0 exit */
>> +	if (lps0_dsm_func_mask > 0)
>> +		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
>> +					ACPI_LPS0_EXIT_AMD :
>> +					ACPI_LPS0_EXIT,
>> +					lps0_dsm_func_mask, lps0_dsm_guid);
>> +	if (lps0_dsm_func_mask_microsoft > 0)
>>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT,
>> -				lps0_dsm_func_mask, lps0_dsm_guid);
>> +				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>> +
>> +	/* Screen on */
>> +	if (lps0_dsm_func_mask_microsoft > 0)
>>  		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON,
>> -				lps0_dsm_func_mask, lps0_dsm_guid);
>> -	}
>> +				lps0_dsm_func_mask_microsoft,
>> lps0_dsm_guid_microsoft);
>> +	if (lps0_dsm_func_mask > 0)
>> +		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
>> +					ACPI_LPS0_SCREEN_ON_AMD :
>> +					ACPI_LPS0_SCREEN_ON,
>> +					lps0_dsm_func_mask, lps0_dsm_guid);
>>  }
>>
>>  static const struct platform_s2idle_ops acpi_s2idle_ops_lps0 = {
>> --
>> 2.30.2
>
>I noticed this didn't get picked up automatically for 5.14.6, so as the submitter of the
>original patch here is an explicit:
>
>Acked-by: Mario Limonciello <mario.limonciello@amd.com>

Oh it did now, AUTOSEL just has a lengthier review process.
Thanks!

-- 
Thanks,
Sasha
