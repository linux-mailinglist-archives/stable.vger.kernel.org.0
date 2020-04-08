Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21FA1A1D78
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 10:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgDHIfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 04:35:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:48032 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgDHIfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 04:35:44 -0400
IronPort-SDR: ohh2LO+BpiwmXk7d55LS1lNHrn0I51vRhNLnC83vSGzvjTHBc5/gXsaNDNgX9wK09EdEMpd6hq
 Zv2x3qRY2YqQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 01:35:44 -0700
IronPort-SDR: Ml5DwRvM0E1lUUriB6givKMJG0Sz//u+lzX89FuDmYI8RV+C0WndlN6uP0xJk8K0i8kT+o3Lw7
 17+9QPPaBbEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="451528793"
Received: from mylly.fi.intel.com (HELO [10.237.72.51]) ([10.237.72.51])
  by fmsmga005.fm.intel.com with ESMTP; 08 Apr 2020 01:35:42 -0700
Subject: Re: [PATCH] i2c: designware: platdrv: Remove DPM_FLAG_SMART_SUSPEND
 flag on BYT and CHT
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
References: <20200407181116.61066-1-hdegoede@redhat.com>
 <CAJZ5v0g2vvCHssUS4QG3UccH-wFNueo_zbAzdVMdHfVwrtyMWg@mail.gmail.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <7eb3c66d-e5ae-6186-d7b4-15f49a131c91@linux.intel.com>
Date:   Wed, 8 Apr 2020 11:35:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0g2vvCHssUS4QG3UccH-wFNueo_zbAzdVMdHfVwrtyMWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/7/20 10:30 PM, Rafael J. Wysocki wrote:
> On Tue, Apr 7, 2020 at 8:11 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> We already set DPM_FLAG_SMART_PREPARE, so we completely skip all
>> callbacks (other then prepare) where possible, quoting from
>> dw_i2c_plat_prepare():
>>
>>          /*
>>           * If the ACPI companion device object is present for this device, it
>>           * may be accessed during suspend and resume of other devices via I2C
>>           * operation regions, so tell the PM core and middle layers to avoid
>>           * skipping system suspend/resume callbacks for it in that case.
>>           */
>>          return !has_acpi_companion(dev);
>>
>> Also setting the DPM_FLAG_SMART_SUSPEND will cause acpi_subsys_suspend()
>> to leave the controller runtime-suspended even if dw_i2c_plat_prepare()
>> returned 0.
>>
>> Leaving the controller runtime-suspended normally, when the I2C controller
>> is suspended during the suspend_late phase, is not an issue because
>> the pm_runtime_get_sync() done by i2c_dw_xfer() will (runtime-)resume it.
>>
>> But for dw I2C controllers on Bay- and Cherry-Trail devices acpi_lpss.c
>> leaves the controller alive until the suspend_noirq phase, because it may
>> be used by the _PS3 ACPI methods of PCI devices and PCI devices are left
>> powered on until the suspend_noirq phase.
>>
>> Between the suspend_late and resume_early phases runtime-pm is disabled.
>> So for any ACPI I2C OPRegion accesses done after the suspend_late phase,
>> the pm_runtime_get_sync() done by i2c_dw_xfer() is a no-op and the
>> controller is left runtime-suspended.
>>
>> i2c_dw_xfer() has a check to catch this condition (rather then waiting
>> for the I2C transfer to timeout because the controller is suspended).
>> acpi_subsys_suspend() leaving the controller runtime-suspended in
>> combination with an ACPI I2C OPRegion access done after the suspend_late
>> phase triggers this check, leading to the following error being logged
>> on a Bay Trail based Lenovo Thinkpad 8 tablet:
>>
>> [   93.275882] i2c_designware 80860F41:00: Transfer while suspended
>> [   93.275993] WARNING: CPU: 0 PID: 412 at drivers/i2c/busses/i2c-designware-master.c:429 i2c_dw_xfer+0x239/0x280
>> ...
>> [   93.276252] Workqueue: kacpi_notify acpi_os_execute_deferred
>> [   93.276267] RIP: 0010:i2c_dw_xfer+0x239/0x280
>> ...
>> [   93.276340] Call Trace:
>> [   93.276366]  __i2c_transfer+0x121/0x520
>> [   93.276379]  i2c_transfer+0x4c/0x100
>> [   93.276392]  i2c_acpi_space_handler+0x219/0x510
>> [   93.276408]  ? up+0x40/0x60
>> [   93.276419]  ? i2c_acpi_notify+0x130/0x130
>> [   93.276433]  acpi_ev_address_space_dispatch+0x1e1/0x252
>> ...
>>
>> So since on BYT and CHT platforms we want ACPI I2c OPRegion accesses
>> to work until the suspend_noirq phase, we need the controller to be
>> runtime-resumed during the suspend phase if it is runtime-suspended
>> suspended at that time. This means that we must not set the
>> DPM_FLAG_SMART_SUSPEND on these platforms.
>>
>> On BYT and CHT we already have a special ACCESS_NO_IRQ_SUSPEND flag
>> to make sure the controller stays functional until the suspend_noirq
>> phase. This commit makes the driver not set the DPM_FLAG_SMART_SUSPEND
>> flag when that flag is set.
> 
> OK
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
