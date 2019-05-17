Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40DD21172
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfEQAs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfEQAs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 20:48:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6789D206BF;
        Fri, 17 May 2019 00:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558054135;
        bh=2vrSa/FuYoEl9xSuzVuOzcf8PlDEfEbVcW4uyGwlPcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DSXIrFZreIMLcMXGNa6qcJrmW96p9/Rqa0YJ+l2f3a09CPm1loZ3y2cfGw0vKjGkn
         rNVN3vyFLmqmEm5R1oxnu9BEpfFR3XGfNmm0eFHEOYSrpwjlUsp9e0ChxW+/HrsDeK
         E2dnGZ+DGndYREf6cgSh42TO1fCCD0IIv2hvCPzU=
Date:   Thu, 16 May 2019 20:48:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] PCI: hv: Add pci_destroy_slot() in"
 failed to apply to 4.14-stable tree
Message-ID: <20190517004854.GY11972@sasha-vm>
References: <155790933699245@kroah.com>
 <PU1P153MB0169997D3F2274F83391D297BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169997D3F2274F83391D297BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 11:20:45PM +0000, Dexuan Cui wrote:
>> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
>> Sent: Wednesday, May 15, 2019 1:36 AM
>> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
>> Kelley <mikelley@microsoft.com>; stephen@networkplumber.org
>> Cc: stable@vger.kernel.org
>> Subject: FAILED: patch "[PATCH] PCI: hv: Add pci_destroy_slot() in" failed to
>> apply to 4.14-stable tree
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
>> From 340d455699400f2c2c0f9b3f703ade3085cdb501 Mon Sep 17 00:00:00
>> 2001
>> From: Dexuan Cui <decui@microsoft.com>
>> Date: Mon, 4 Mar 2019 21:34:49 +0000
>> Subject: [PATCH] PCI: hv: Add pci_destroy_slot() in
>>  pci_devices_present_work(), if necessary
>>
>> When we hot-remove a device, usually the host sends us a PCI_EJECT message,
>> and a PCI_BUS_RELATIONS message with bus_rel->device_count == 0.
>>
>> When we execute the quick hot-add/hot-remove test, the host may not send
>> us the PCI_EJECT message if the guest has not fully finished the
>> initialization by sending the PCI_RESOURCES_ASSIGNED* message to the
>> host, so it's potentially unsafe to only depend on the
>> pci_destroy_slot() in hv_eject_device_work() because the code path
>>
>> create_root_hv_pci_bus()
>>  -> hv_pci_assign_slots()
>>
>> is not called in this case. Note: in this case, the host still sends the
>> guest a PCI_BUS_RELATIONS message with bus_rel->device_count == 0.
>>
>> In the quick hot-add/hot-remove test, we can have such a race before
>> the code path
>>
>> pci_devices_present_work()
>>  -> new_pcichild_device()
>>
>> adds the new device into the hbus->children list, we may have already
>> received the PCI_EJECT message, and since the tasklet handler
>>
>> hv_pci_onchannelcallback()
>>
>> may fail to find the "hpdev" by calling
>>
>> get_pcichild_wslot(hbus, dev_message->wslot.slot)
>>
>> hv_pci_eject_device() is not called; Later, by continuing execution
>>
>> create_root_hv_pci_bus()
>>  -> hv_pci_assign_slots()
>>
>> creates the slot and the PCI_BUS_RELATIONS message with
>> bus_rel->device_count == 0 removes the device from hbus->children, and
>> we end up being unable to remove the slot in
>>
>> hv_pci_remove()
>>  -> hv_pci_remove_slots()
>>
>> Remove the slot in pci_devices_present_work() when the device
>> is removed to address this race.
>>
>> pci_devices_present_work() and hv_eject_device_work() run in the
>> singled-threaded hbus->wq, so there is not a double-remove issue for the
>> slot.
>>
>> We cannot offload hv_pci_eject_device() from hv_pci_onchannelcallback()
>> to the workqueue, because we need the hv_pci_onchannelcallback()
>> synchronously call hv_pci_eject_device() to poll the channel
>> ringbuffer to work around the "hangs in hv_compose_msi_msg()" issue
>> fixed in commit de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in
>> hv_compose_msi_msg()")
>>
>> Fixes: a15f2c08c708 ("PCI: hv: support reporting serial number as slot
>> information")
>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>> [lorenzo.pieralisi@arm.com: rewritten commit log]
>> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
>> Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
>> Cc: stable@vger.kernel.org
>>
>> diff --git a/drivers/pci/controller/pci-hyperv.c
>> b/drivers/pci/controller/pci-hyperv.c
>> index b489412e3502..82acd6155adf 100644
>> --- a/drivers/pci/controller/pci-hyperv.c
>> +++ b/drivers/pci/controller/pci-hyperv.c
>> @@ -1776,6 +1776,10 @@ static void pci_devices_present_work(struct
>> work_struct *work)
>>  		hpdev = list_first_entry(&removed, struct hv_pci_dev,
>>  					 list_entry);
>>  		list_del(&hpdev->list_entry);
>> +
>> +		if (hpdev->pci_slot)
>> +			pci_destroy_slot(hpdev->pci_slot);
>> +
>>  		put_pcichild(hpdev);
>>  	}
>>
>
>Hi,
>I backported the patch for linux-4.14.y.
>
>Please use the attached patch, which is [PATCH 3/3]
>
>Thanks,
>-- Dexuan

Queued for 4.14, thank you.

--
Thanks,
Sasha
