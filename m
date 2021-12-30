Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C858F4818D7
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 04:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbhL3DJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 22:09:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:50521 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhL3DJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Dec 2021 22:09:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640833757; x=1672369757;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=tZZPHf2DyOK7p1G3x3mXivjDw99X+Vp50x10gR49ETg=;
  b=NEUoU+YpHGQLmjw0B4D0Ar3KloLrfHZ8CgY4/TEbRKmhDcv+2z4NIiZE
   SYGNO9X6oiTj4AfmGphBTFEObVI7pz6Z2teM+Q5bZ0w0jCxVPtDU0sspo
   0Cz68yVPeb6btosLB82OpOJJhyA+w6+O6NaJ0qtU/rVyMWx+ZOiDQ+RHp
   tUBYBkJY7PQFZkhrUz50NAShZE9PDyDI/IkGpixATao883wCanWgbdu9t
   +LqnGckF1QG/CS0nVvBeSQaGu5PtN2rb6xTJMpyt881t6BT6ii7fpd2CE
   CjCqF+TpivH9+GxclItiN7w123tT+aggaO5XvqgGXWDA5XyTW006m4IMC
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="241408063"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="241408063"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 19:09:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="524229955"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 29 Dec 2021 19:09:14 -0800
Cc:     baolu.lu@linux.intel.com, "Rafael J . Wysocki" <rafael@kernel.org>,
        Kay Sievers <kay.sievers@novell.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] driver core: Fix driver_sysfs_remove() order in
 really_probe()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20211229045159.1731943-1-baolu.lu@linux.intel.com>
 <YcwyyXuqJ3QVevYW@kroah.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <5d844360-60f1-731a-257f-ec6b0c6b1c4b@linux.intel.com>
Date:   Thu, 30 Dec 2021 11:08:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YcwyyXuqJ3QVevYW@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 12/29/21 6:04 PM, Greg Kroah-Hartman wrote:
> On Wed, Dec 29, 2021 at 12:51:59PM +0800, Lu Baolu wrote:
>> The driver_sysfs_remove() should always be called after successful
>> driver_sysfs_add(). Otherwise, NULL pointers will be passed to the
>> sysfs_remove_link(), where it is decoded as searching sysfs root.
> 
> What null pointer is being sent to sysfs_remove_link()?  For which link?

Oh, my fault. Thank you for pointing this out.

The device and driver sysfs nodes have already been created, so there's
no null pointers. The out-of-order call of driver_sysfs_remove() just
tries to remove some nonexistent nodes under the device and driver sysfs
nodes. It is allowed by the sysfs layer.

> 
> How are you triggering this failure path and how was it tested?

I hacked the a driver to return failure in dma_configure() callback. I
didn't see any failure. But I mistakenly thought that
driver_sysfs_remove() could possibly delete some sysfs entries by
mistake. That's not true. Sorry for the noise.

> 
>>
>> Fixes: 1901fb2604fbc ("Driver core: fix "driver" symlink timing")
>> Cc: stable@vger.kernel.org

This patch only improves the readability of really_probe() and it does
not fix any bugs. I will remove above tags and resent a version if you
think this improvement is valuable.

>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/base/dd.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
>> index 68ea1f949daa..9eaaff2f556c 100644
>> --- a/drivers/base/dd.c
>> +++ b/drivers/base/dd.c
>> @@ -577,14 +577,14 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>>   	if (dev->bus->dma_configure) {
>>   		ret = dev->bus->dma_configure(dev);
>>   		if (ret)
>> -			goto probe_failed;
>> +			goto pinctrl_bind_failed;
> 
> Why not call the notifier chain here?  Did you verify that this change
> still works properly?

The BUS_NOTIFY_DRIVER_NOT_BOUND event is listened in two places in the
tree.

$ git grep BUS_NOTIFY_DRIVER_NOT_BOUND -- :^drivers/base/dd.c :^include
drivers/acpi/acpi_lpss.c:       case BUS_NOTIFY_DRIVER_NOT_BOUND:
drivers/base/power/clock_ops.c: case BUS_NOTIFY_DRIVER_NOT_BOUND:

The usage pattern is setting up something in BUS_NOTIFY_BIND_DRIVER and
doing the cleanup in BUS_NOTIFY_DRIVER_NOT_BOUND or
BUS_NOTIFY_UNBIND_DRIVER. The right order of these events should be

  [failure case]
  - BUS_NOTIFY_BIND_DRIVER: driver is about to be bound
  - BUS_NOTIFY_DRIVER_NOT_BOUND: driver failed to be bound

or

  [successful case]
  - BUS_NOTIFY_BIND_DRIVER: driver is about to be bound
  - BUS_NOTIFY_BOUND_DRIVER: driver bound to device
  - BUS_NOTIFY_UNBIND_DRIVER: driver is about to be unbound
  - BUS_NOTIFY_UNBOUND_DRIVER: driver is unbound from the device

Without above change, when dma_configure() returns failure, the listener 
could get a BUS_NOTIFY_DRIVER_NOT_BOUND without BUS_NOTIFY_BIND_DRIVER.

Please guide me if my understanding is wrong.

> 
> thanks,
> 
> greg k-h
> 

Best regards,
baolu
