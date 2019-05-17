Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7475921171
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfEQAsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfEQAsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 20:48:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB89F206BF;
        Fri, 17 May 2019 00:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558054120;
        bh=Bh4sfda+E8BY9RjFU4YjSI90o4GcRzZdYl20OSj+Thw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S2ZoV2hBR4DLT1yQgkmth5yeUf/ewcJYJmCaZw5pIQdEfkHokywO+H8m7Ht3Jvsdn
         jQwA7BxJF0VXhJbH30/QDYORJmXvpTFVazZ8yha7LgKHUOabXAyyW70xK32go3fBHf
         /CZIy0X72eJpwugUvQjPD/MB0P1kUj5aRnOnReLM=
Date:   Thu, 16 May 2019 20:48:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] PCI: hv: Add hv_pci_remove_slots() when
 we unload the driver" failed to apply to 4.14-stable tree
Message-ID: <20190517004838.GX11972@sasha-vm>
References: <155790931816178@kroah.com>
 <PU1P153MB01696C8539CBD25904792049BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <PU1P153MB01696C8539CBD25904792049BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 11:19:40PM +0000, Dexuan Cui wrote:
>> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
>> Sent: Wednesday, May 15, 2019 1:35 AM
>> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
>> Kelley <mikelley@microsoft.com>; Stephen Hemminger
>> <sthemmin@microsoft.com>
>> Cc: stable@vger.kernel.org
>> Subject: FAILED: patch "[PATCH] PCI: hv: Add hv_pci_remove_slots() when we
>> unload the driver" failed to apply to 4.14-stable tree
>>
>>
>> The patch below does not apply to the 4.14-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From 15becc2b56c6eda3d9bf5ae993bafd5661c1fad1 Mon Sep 17 00:00:00
>> 2001
>> From: Dexuan Cui <decui@microsoft.com>
>> Date: Mon, 4 Mar 2019 21:34:48 +0000
>> Subject: [PATCH] PCI: hv: Add hv_pci_remove_slots() when we unload the
>> driver
>>
>> When we unload the pci-hyperv host controller driver, the host does not
>> send us a PCI_EJECT message.
>>
>> In this case we also need to make sure the sysfs PCI slot directory is
>> removed, otherwise a command on a slot file eg:
>>
>> "cat /sys/bus/pci/slots/2/address"
>>
>> will trigger a
>>
>> "BUG: unable to handle kernel paging request"
>>
>> and, if we unload/reload the driver several times we would end up with
>> stale slot entries in PCI slot directories in /sys/bus/pci/slots/
>>
>> root@localhost:~# ls -rtl  /sys/bus/pci/slots/
>> total 0
>> drwxr-xr-x 2 root root 0 Feb  7 10:49 2
>> drwxr-xr-x 2 root root 0 Feb  7 10:49 2-1
>> drwxr-xr-x 2 root root 0 Feb  7 10:51 2-2
>>
>> Add the missing code to remove the PCI slot and fix the current
>> behaviour.
>>
>> Fixes: a15f2c08c708 ("PCI: hv: support reporting serial number as slot
>> information")
>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>> [lorenzo.pieralisi@arm.com: reformatted the log]
>> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Reviewed-by: Stephen Hemminger <sthemmin@microsoft.com>
>> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>> Cc: stable@vger.kernel.org
>>
>> diff --git a/drivers/pci/controller/pci-hyperv.c
>> b/drivers/pci/controller/pci-hyperv.c
>> index 30f16b882746..b489412e3502 100644
>> --- a/drivers/pci/controller/pci-hyperv.c
>> +++ b/drivers/pci/controller/pci-hyperv.c
>> @@ -1486,6 +1486,21 @@ static void hv_pci_assign_slots(struct
>> hv_pcibus_device *hbus)
>>  	}
>>  }
>>
>> +/*
>> + * Remove entries in sysfs pci slot directory.
>> + */
>> +static void hv_pci_remove_slots(struct hv_pcibus_device *hbus)
>> +{
>> +	struct hv_pci_dev *hpdev;
>> +
>> +	list_for_each_entry(hpdev, &hbus->children, list_entry) {
>> +		if (!hpdev->pci_slot)
>> +			continue;
>> +		pci_destroy_slot(hpdev->pci_slot);
>> +		hpdev->pci_slot = NULL;
>> +	}
>> +}
>> +
>>  /**
>>   * create_root_hv_pci_bus() - Expose a new root PCI bus
>>   * @hbus:	Root PCI bus, as understood by this driver
>> @@ -2680,6 +2695,7 @@ static int hv_pci_remove(struct hv_device *hdev)
>>  		pci_lock_rescan_remove();
>>  		pci_stop_root_bus(hbus->pci_bus);
>>  		pci_remove_root_bus(hbus->pci_bus);
>> +		hv_pci_remove_slots(hbus);
>>  		pci_unlock_rescan_remove();
>>  		hbus->state = hv_pcibus_removed;
>>  	}
>
>Hi,
>I backported the patch for linux-4.14.y.
>
>Please use the attached patch, which is [PATCH 2/3]
>
>Thanks,
>-- Dexuan

Queued for 4.14, thank you.

--
Thanks,
Sasha
