Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E16DE4050
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfJXXSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 19:18:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:33007 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfJXXSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 19:18:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 16:18:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="210255295"
Received: from cwschule-mobl.amr.corp.intel.com (HELO [10.254.104.186]) ([10.254.104.186])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 16:18:15 -0700
Subject: Re: [PATCH 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to
 lpss_device_links
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
References: <20191024212936.144648-1-hdegoede@redhat.com>
 <CAJZ5v0jDuvEBob93wgYFuz0q1QyraOtxnbs-xqBOM_87jBnKqw@mail.gmail.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <5c15fd87-414a-41fb-48a2-11c675ed6cfb@linux.intel.com>
Date:   Thu, 24 Oct 2019 18:18:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0jDuvEBob93wgYFuz0q1QyraOtxnbs-xqBOM_87jBnKqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/24/19 4:34 PM, Rafael J. Wysocki wrote:
> On Thu, Oct 24, 2019 at 11:29 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> So far on Bay Trail (BYT) we only have been adding a device_link adding
>> the iGPU (LNXVIDEO) device as consumer for the I2C controller for the
>> PMIC for I2C5, but the PMIC only uses I2C5 on BYT CR (cost reduced) on
>> regular BYT platforms I2C7 is used and we were not adding the device_link
>> sometimes causing resume ordering issues.
>>
>> This commit adds LNXVIDEO -> BYT I2C7 to the lpss_device_links table,
>> fixing this.
>>
>> Cc: stable@vger.kernel.org
> 
> Thanks for these fixes, but it would be kind of nice to have Fixes:
> tags for them too.

Nice, this removes the warnings I saw on Asus T100TA
[   56.015285] i2c_designware 80860F41:00: Transfer while suspended

Thanks Hans! Feel free to take the following tag for your v2.

Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

Maybe an unrelated point, but with this series I now see a new message 
(logged only once):
[   46.888703] ACPI: button: The lid device is not compliant to SW_LID.

Not sure what exactly this is about, but it may be linked to the fact 
that the power button is useless to resume and somehow I have to 
close/reopen the lid to force the device to resume.

if it helps here are the traces for 2 cycles of suspend/resume.

[   34.242313] PM: suspend entry (s2idle)
[   34.246896] Filesystems sync: 0.004 seconds
[   34.247265] Freezing user space processes ... (elapsed 0.001 seconds) 
done.
[   34.249250] OOM killer disabled.
[   34.249253] Freezing remaining freezable tasks ... (elapsed 0.000 
seconds) done.
[   34.250195] printk: Suspending console(s) (use no_console_suspend to 
debug)
[   41.251352] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[   41.252948] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[   41.254530] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[   41.257397] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[   41.586893] OOM killer enabled.
[   41.586898] Restarting tasks ... done.
[   41.625298] video LNXVIDEO:00: Restoring backlight state
[   41.625718] PM: suspend exit
[   45.162584] ax88179_178a 2-1:1.0 enx00051ba24714: ax88179 - Link 
status is: 1
[   45.171220] IPv6: ADDRCONF(NETDEV_CHANGE): enx00051ba24714: link 
becomes ready
[   45.400724] ACPI: button: The lid device is not compliant to SW_LID.
[   58.478184] PM: suspend entry (s2idle)
[   58.528882] Filesystems sync: 0.051 seconds
[   58.529354] Freezing user space processes ... (elapsed 0.004 seconds) 
done.
[   58.533708] OOM killer disabled.
[   58.533712] Freezing remaining freezable tasks ... (elapsed 0.000 
seconds) done.
[   58.534648] printk: Suspending console(s) (use no_console_suspend to 
debug)
[   63.084134] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[   63.085736] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[   63.087337] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[   63.090241] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[   63.420651] OOM killer enabled.
[   63.420656] Restarting tasks ... done.
[   63.458493] video LNXVIDEO:00: Restoring backlight state
[   63.458918] PM: suspend exit
[   66.862343] ax88179_178a 2-1:1.0 enx00051ba24714: ax88179 - Link 
status is: 1
[   66.869564] IPv6: ADDRCONF(NETDEV_CHANGE): enx00051ba24714: link 
becomes ready

