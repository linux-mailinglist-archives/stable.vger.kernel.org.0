Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7403C367213
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 19:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245008AbhDURzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 13:55:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:33909 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243789AbhDURzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 13:55:00 -0400
IronPort-SDR: uCCXmVgpPRXiUFehm+aeZWawIS+MNKChXNXFxnGke9QzkSn1makgDophfRyaGDJDbwfYeMnr3m
 TlT6CjGVqx3g==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="195857008"
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="195857008"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 10:54:26 -0700
IronPort-SDR: G89qDqo2oHdvPA03l8fUHO7SiY2xJCah0aGHRtlGk9HU+B1ZW8qYKJBfNM+WKZwrM+F61wmSQM
 QwcnZD6yHYvA==
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="427609738"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.153.90]) ([10.249.153.90])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 10:54:25 -0700
Subject: Re: [PATCH 041/190] Revert "ACPI: sysfs: Fix reference count leak in
 acpi_sysfs_add_hotplug_profile()"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, "3 . 10+" <stable@vger.kernel.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-42-gregkh@linuxfoundation.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <c7451c62-69fe-bd8f-f90c-5574cf70b60c@intel.com>
Date:   Wed, 21 Apr 2021 19:54:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421130105.1226686-42-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/21/2021 2:58 PM, Greg Kroah-Hartman wrote:
> This reverts commit 6e6c25283dff866308c87b49434c7dbad4774cc0.
>
> Commits from @umn.edu addresses have been found to be submitted in "bad
> faith" to try to test the kernel community's ability to review "known
> malicious" changes.  The result of these submissions can be found in a
> paper published at the 42nd IEEE Symposium on Security and Privacy
> entitled, "Open Source Insecurity: Stealthily Introducing
> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> of Minnesota) and Kangjie Lu (University of Minnesota).
>
> Because of this, all submissions from this group must be reverted from
> the kernel tree and will need to be re-reviewed again to determine if
> they actually are a valid fix.  Until that work is complete, remove this
> change to ensure that no problems are being introduced into the
> codebase.
>
> Cc: Qiushi Wu <wu000273@umn.edu>
> Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


> ---
>   drivers/acpi/sysfs.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
> index 8baf7644a0d0..842bf63b91e9 100644
> --- a/drivers/acpi/sysfs.c
> +++ b/drivers/acpi/sysfs.c
> @@ -986,10 +986,8 @@ void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
>   
>   	error = kobject_init_and_add(&hotplug->kobj,
>   		&acpi_hotplug_profile_ktype, hotplug_kobj, "%s", name);
> -	if (error) {
> -		kobject_put(&hotplug->kobj);
> +	if (error)
>   		goto err_out;
> -	}
>   
>   	kobject_uevent(&hotplug->kobj, KOBJ_ADD);
>   	return;


