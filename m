Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF9A258A3C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 10:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgIAITn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 04:19:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:35392 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgIAITl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 04:19:41 -0400
IronPort-SDR: X0Wvf8wimY16R7gC3xoraD0NCRagIrDGhSXWOh9R82X85SnbPcAzs4vDYm5++Wujbsz35uN/FZ
 iYTQ4FcM8vdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="241939710"
X-IronPort-AV: E=Sophos;i="5.76,378,1592895600"; 
   d="scan'208";a="241939710"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2020 01:19:41 -0700
IronPort-SDR: NXpBjrSeVHMCMdhfGfBLnvrMfuYNHl07U+ch2qk3t5MKV/eKLEdVe1unBu2xHER7rKfcFkPfOC
 dHadQhR6MNaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,378,1592895600"; 
   d="scan'208";a="338498788"
Received: from mylly.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Sep 2020 01:19:38 -0700
Subject: Re: [PATCH 1/2] i2c: i801: Fix runtime PM
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jean Delvare <jdelvare@suse.de>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180627212340.GA161569@bhelgaas-glaptop.roam.corp.google.com>
 <20200828162640.GA2160001@bjorn-Precision-5520>
 <20200831151159.GA11707@gmail.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <e40561b7-9b85-4f9d-48d5-7dc11bfb873c@linux.intel.com>
Date:   Tue, 1 Sep 2020 11:19:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831151159.GA11707@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/31/20 6:15 PM, Vaibhav Gupta wrote:
> On Fri, Aug 28, 2020 at 11:26:40AM -0500, Bjorn Helgaas wrote:
>> [+cc Vaibhav]
>>
>> On Wed, Jun 27, 2018 at 04:23:40PM -0500, Bjorn Helgaas wrote:
>>> [+cc Rafael, linux-pm, linux-kernel]
>>>
>>> On Wed, Jun 27, 2018 at 10:15:50PM +0200, Jean Delvare wrote:
>>>> Hi Jarkko,
>>>>
>>>> On Tue, 26 Jun 2018 17:39:12 +0300, Jarkko Nikula wrote:
>>>>> Commit 9c8088c7988 ("i2c: i801: Don't restore config registers on
>>>>> runtime PM") nullified the runtime PM suspend/resume callback pointers
>>>>> while keeping the runtime PM enabled. This causes that device stays in
>>>>> D0 power state and sysfs /sys/bus/pci/devices/.../power/runtime_status
>>>>> shows "error" when runtime PM framework attempts to autosuspend the
>>>>> device.
>>>>>
>>>>> This is due PCI bus runtime PM which checks for driver runtime PM
>>>>> callbacks and returns with -ENOSYS if they are not set. Fix this by
>>>>> having a shared dummy runtime PM callback that returns with success.
>>>>>
>>>>> Fixes: a9c8088c7988 ("i2c: i801: Don't restore config registers on runtime PM")
>>>>
>>>> I don't want to sound like I'm trying to decline all responsibility for
>>>> a regression I caused, but frankly, if just using SIMPLE_DEV_PM_OPS()
>>>> breaks runtime PM, then it's the PM model which is broken, not the
>>>> i2c-i801 driver.
>>>>
>>>> I will boldly claim that the PCI bus runtime code is simply wrong in
>>>> returning -ENOSYS in the absence of runtime PM callbacks, and it should
>>>> be changed to return 0 instead. Or whoever receives that -ENOSYS should
>>>> not treat it as an error - whatever makes more sense.
>>>>
>>>> Having to add dummy functions in every PCI driver that doesn't need to
>>>> do anything special for runtime PM sounds plain stupid. It should be
>>>> pretty obvious that a whole lot of drivers are going to use
>>>> SIMPLE_DEV_PM_OPS() because it exists and seems to do what they want,
>>>> and all of them will be bugged because the PCI core is doing something
>>>> silly and unexpected.
>>>>
>>>> So please let's fix it at the PCI subsystem core level. Adding Bjorn
>>>> and the linux-pci list to Cc.
>>>
>>> Thanks Jean.  What you describe does sound broken.  I think the PM
>>> guys (cc'd) will have a better idea of how to deal with this.
>>
>> Did we ever get anywhere with this?  It seems like the thread petered
>> out.
> This does seems worrying. I remember, few days earlier you pointed out a driver
> i2c-nvidia-gpuc.c. In the code, gpu_i2c_suspend() is an empty-body function. And
> comment mentioned that empty stub is necessary for runtime_pm to work.
> 
> And this driver also uses UNIVERSAL_DEV_PM_OPS.
> 
This was fixed by c5eb1190074c ("PCI / PM: Allow runtime PM without 
callback functions"). So no need for empty runtime PM callbacks anymore.

-- 
Jarkko
