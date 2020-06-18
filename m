Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D859F1FF4B2
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgFRO3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgFRO3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 10:29:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C70207E8;
        Thu, 18 Jun 2020 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592490584;
        bh=3OO4kEs57sfNjzQq7iy84oQLGMRCkyvOCnFELjitwc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yOGTyQZOeF3MreSMzsPgPbZLSkqgahgCBlwYFNIo1+IfNVR/j5HUQf3D6q9UUwZ2F
         TaWa3A6AdQE8H12eN+fJiEi6BldZIt4aGEPbVbjNGD/odz8DK5A3IdjJNw/5mRhRl6
         4v2SZZtTzg3QkOEU+dUmO6UV4hAKfnbjrLZyNLvo=
Date:   Thu, 18 Jun 2020 10:29:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qian Cai <cai@lca.pw>, kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 280/388] vfio/pci: fix memory leaks of
 eventfd ctx
Message-ID: <20200618142943.GS1931@sasha-vm>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-280-sashal@kernel.org>
 <20200617192501.2310afe6@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200617192501.2310afe6@x1.home>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 07:25:01PM -0600, Alex Williamson wrote:
>On Wed, 17 Jun 2020 21:06:17 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Qian Cai <cai@lca.pw>
>>
>> [ Upstream commit 1518ac272e789cae8c555d69951b032a275b7602 ]
>>
>> Finished a qemu-kvm (-device vfio-pci,host=0001:01:00.0) triggers a few
>> memory leaks after a while because vfio_pci_set_ctx_trigger_single()
>> calls eventfd_ctx_fdget() without the matching eventfd_ctx_put() later.
>> Fix it by calling eventfd_ctx_put() for those memory in
>> vfio_pci_release() before vfio_device_release().
>>
>> unreferenced object 0xebff008981cc2b00 (size 128):
>>   comm "qemu-kvm", pid 4043, jiffies 4294994816 (age 9796.310s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 6b 6b 6b 6b 00 00 00 00 ad 4e ad de  ....kkkk.....N..
>>     ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
>>   backtrace:
>>     [<00000000917e8f8d>] slab_post_alloc_hook+0x74/0x9c
>>     [<00000000df0f2aa2>] kmem_cache_alloc_trace+0x2b4/0x3d4
>>     [<000000005fcec025>] do_eventfd+0x54/0x1ac
>>     [<0000000082791a69>] __arm64_sys_eventfd2+0x34/0x44
>>     [<00000000b819758c>] do_el0_svc+0x128/0x1dc
>>     [<00000000b244e810>] el0_sync_handler+0xd0/0x268
>>     [<00000000d495ef94>] el0_sync+0x164/0x180
>> unreferenced object 0x29ff008981cc4180 (size 128):
>>   comm "qemu-kvm", pid 4043, jiffies 4294994818 (age 9796.290s)
>>   hex dump (first 32 bytes):
>>     01 00 00 00 6b 6b 6b 6b 00 00 00 00 ad 4e ad de  ....kkkk.....N..
>>     ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
>>   backtrace:
>>     [<00000000917e8f8d>] slab_post_alloc_hook+0x74/0x9c
>>     [<00000000df0f2aa2>] kmem_cache_alloc_trace+0x2b4/0x3d4
>>     [<000000005fcec025>] do_eventfd+0x54/0x1ac
>>     [<0000000082791a69>] __arm64_sys_eventfd2+0x34/0x44
>>     [<00000000b819758c>] do_el0_svc+0x128/0x1dc
>>     [<00000000b244e810>] el0_sync_handler+0xd0/0x268
>>     [<00000000d495ef94>] el0_sync+0x164/0x180
>>
>> Signed-off-by: Qian Cai <cai@lca.pw>
>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/vfio/pci/vfio_pci.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index 6c6b37b5c04e..080e6608f297 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -519,6 +519,10 @@ static void vfio_pci_release(void *device_data)
>>  		vfio_pci_vf_token_user_add(vdev, -1);
>>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>>  		vfio_pci_disable(vdev);
>> +		if (vdev->err_trigger)
>> +			eventfd_ctx_put(vdev->err_trigger);
>> +		if (vdev->req_trigger)
>> +			eventfd_ctx_put(vdev->req_trigger);
>>  	}
>>
>>  	mutex_unlock(&vdev->reflck->lock);
>
>
>This has a fix pending, I'd suggest not picking it on its own:
>
>https://lore.kernel.org/kvm/20200616085052.sahrunsesjyjeyf2@beryllium.lan/
>https://lore.kernel.org/kvm/159234276956.31057.6902954364435481688.stgit@gimli.home/

Thanks! I'll hold off on this until the fix is in too.

-- 
Thanks,
Sasha
