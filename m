Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2F4451724
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 23:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352515AbhKOWIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 17:08:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:54975 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351129AbhKOWGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 17:06:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="233482665"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="233482665"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 14:03:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="645038416"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 15 Nov 2021 14:03:35 -0800
To:     Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        chris.chiu@canonical.com, Mathias Nyman <mathias.nyman@intel.com>
References: <42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com>
 <YYJRRg8QDBfy2PP7@kroah.com>
 <9e1abe71-d903-f227-38ae-a854ab9e5baf@redhat.com>
 <5c95597b-289b-ea1c-4770-8be9e8511ae0@ti.com>
 <20211103145919.GC1521906@rowland.harvard.edu>
 <3cfc755c-7559-306c-bec4-ae87052fc7c0@linux.intel.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: 5.14.14+ USB regression caused by "usb: core: hcd: Add support
 for deferring roothub registration" series
Message-ID: <5158300e-946e-a0e8-e341-c569ed398dec@linux.intel.com>
Date:   Tue, 16 Nov 2021 00:05:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3cfc755c-7559-306c-bec4-ae87052fc7c0@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4.11.2021 1.54, Mathias Nyman wrote:
> On 3.11.2021 16.59, Alan Stern wrote:
>> On Wed, Nov 03, 2021 at 08:14:35PM +0530, Kishon Vijay Abraham I wrote:
>>> + Alan, Chris, Mathias, linux-usb
>>>
>>> Hi Hans,
>>>
>>> On 03/11/21 6:18 pm, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 11/3/21 10:07, Greg Kroah-Hartman wrote:
>>>>> On Wed, Nov 03, 2021 at 10:02:52AM +0100, Hans de Goede wrote:
>>>>>> Hi Greg,
>>>>>>
>>>>>> We (Fedora) have been receiving multiple reports about USB devices stopping
>>>>>> working starting with 5.14.14 .
>>>>>>
>>>>>> An Arch Linux user has found that reverting the first 2 patches from this series:
>>>>>> https://lore.kernel.org/all/20210909064200.16216-1-kishon@ti.com/
>>>>>>
>>>>>> Fixes things (the 3th patch is just some mostly unrelated refactoring/cleanup).
>>>>>>
>>>>>> See here for the Arch-linux discussion surrounding this:
>>>>>> https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956
>>>>>>
>>>>>> And here are 2 Fedora bug reports of Fedora users being unable to use their
>>>>>> machines due their mouse + kbd not working:
>>>>>>
>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=2019542
>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=2019576
>>>>>>
>>>>>> Can we get this patch-series reverted from the 5.14.y releases please ?
>>>>>
>>>>> Sure,
>>>>
>>>> Thanks.
>>>>
>>>>> but can you also submit patches to get into 5.15.y and 5.16-rc1
>>>>> that revert these changes as they should still be an issue there, right?
>>>>
>>>> Yes I assume this is still an issue there too, but I was hoping that
>>>> Kishon can take a look and maybe actually fix things, since just
>>>> reverting presumably regresses whatever these patches were addressing.
>>>>
>>>> We've aprox 1-3 weeks before distros like Arch and Linux will switch
>>>> to 5.15.y kernels.  So we have some time to come up with a fix
>>>> there, where as for 5.14.y this is hitting users now.
>>>
>>> Is the issue with PCIe USB devices or platform USB device? Is it specific to
>>> super speed devices or high speed device?
>>
>> Look at the bug reports.  They are on standard PCs (so PCIe controllers) 
>> and some of them involve full speed (mouse and keyboard) devices.  
>> Although it looks like the problem has little to do with the device and 
>> a lot to do with the controller.
>>
>> Is there a good way to get more information about what is going wrong?  
>> For example, by enabling tracepoints in the xhci-hcd driver?
>>
>> Alan Stern
>>
> 
> To enable xhci traces and dynamic debug at boot please add:
> "usbcore.dyndbg=+p xhci_hcd.dyndbg=+p trace_event=xhci-hcd trace_buf_size=80M"
> to the kernel cmdline before booting.
> (info added to https://bugzilla.redhat.com/show_bug.cgi?id=2019788 as well)
> 
> Symptoms look similar to an old race issue where two usb devices were reset at the same time.
> xHC HW can't handle this, and to prevent it the hcd->address0_mutex was added.
> 
> for details see: 
> https://lkml.org/lkml/2016/2/8/312
> 
> -Mathias
> 

Looks like it really is an issue with address0_mutex in hub.c not preventing
two xhci slots from entering default state at the same time during retry.

Seems extending the mutex across retries resolved this, details:
https://bugzilla.redhat.com/show_bug.cgi?id=2019788

I'll post that patch here on linux-usb for review shortly

-Mathias
