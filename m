Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9E621168
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfEQAnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfEQAnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 20:43:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6623206BF;
        Fri, 17 May 2019 00:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558053783;
        bh=j33c7ruDGDvYz2vBIkcANRAnfk59kDFq1q4RLQJjbV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qA25r+f0B9FKBpEc/YeJyA6kZn3PIo53cM46cqRgZLco+sqSmnPo6sp0aIdqM5Lj4
         n4gjUtMspbrVa1jjhJORYB/ieH4YCBCCOygknYQzCmtc6j3nLFvdBFzePR9nEV1AbQ
         J2dJbu8wvqzUegbgYqToXzwm+LOJwzUc4pVxr5L4=
Date:   Thu, 16 May 2019 20:43:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
 hv_eject_device_work()" failed to apply to 4.9-stable tree
Message-ID: <20190517004301.GW11972@sasha-vm>
References: <1557909271235151@kroah.com>
 <PU1P153MB0169E1485667016EAE6EDB84BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169E1485667016EAE6EDB84BF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 11:14:31PM +0000, Dexuan Cui wrote:
>> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
>> Sent: Wednesday, May 15, 2019 1:35 AM
>> To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
>> Kelley <mikelley@microsoft.com>; stephen@networkplumber.org
>> Cc: stable@vger.kernel.org
>> Subject: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
>> hv_eject_device_work()" failed to apply to 4.9-stable tree
>>
>>
>> The patch below does not apply to the 4.9-stable tree.
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
>> From 05f151a73ec2b23ffbff706e5203e729a995cdc2 Mon Sep 17 00:00:00
>> 2001
>> From: Dexuan Cui <decui@microsoft.com>
>> Date: Mon, 4 Mar 2019 21:34:48 +0000
>> Subject: [PATCH] PCI: hv: Fix a memory leak in hv_eject_device_work()
>>
>> When a device is created in new_pcichild_device(), hpdev->refs is set
>> to 2 (i.e. the initial value of 1 plus the get_pcichild()).
>>
>> When we hot remove the device from the host, in a Linux VM we first call
>> hv_pci_eject_device(), which increases hpdev->refs by get_pcichild() and
>> then schedules a work of hv_eject_device_work(), so hpdev->refs becomes
>> 3 (let's ignore the paired get/put_pcichild() in other places). But in
>> hv_eject_device_work(), currently we only call put_pcichild() twice,
>> meaning the 'hpdev' struct can't be freed in put_pcichild().
>>
>> Add one put_pcichild() to fix the memory leak.
>>
>> The device can also be removed when we run "rmmod pci-hyperv". On this
>> path (hv_pci_remove() -> hv_pci_bus_exit() -> hv_pci_devices_present()),
>> hpdev->refs is 2, and we do correctly call put_pcichild() twice in
>> pci_devices_present_work().
>>
>> Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft
>> Hyper-V VMs")
>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>> [lorenzo.pieralisi@arm.com: commit log rework]
>> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
>> Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
>> Cc: stable@vger.kernel.org
>>
>> diff --git a/drivers/pci/controller/pci-hyperv.c
>> b/drivers/pci/controller/pci-hyperv.c
>> index 95441a35eceb..30f16b882746 100644
>> --- a/drivers/pci/controller/pci-hyperv.c
>> +++ b/drivers/pci/controller/pci-hyperv.c
>> @@ -1900,6 +1900,9 @@ static void hv_eject_device_work(struct work_struct
>> *work)
>>  			 sizeof(*ejct_pkt), (unsigned long)&ctxt.pkt,
>>  			 VM_PKT_DATA_INBAND, 0);
>>
>> +	/* For the get_pcichild() in hv_pci_eject_device() */
>> +	put_pcichild(hpdev);
>> +	/* For the two refs got in new_pcichild_device() */
>>  	put_pcichild(hpdev);
>>  	put_pcichild(hpdev);
>>  	put_hvpcibus(hpdev->hbus);
>
>Hi,
>I backported the patch for linux-4.9.y. Please use the attached patch.
>
>Thanks,
>-- Dexuan

Queued for 4.9, thanks.

--
Thanks,
Sasha
