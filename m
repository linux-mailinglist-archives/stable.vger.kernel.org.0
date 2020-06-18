Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DBA1FDE8D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbgFRBeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:34:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732760AbgFRBeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 21:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592444049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEhlovaSoKdmjBdKhncpqjOrfXJ8xJY0QnFOM08sVmA=;
        b=Oo794d+JOaaPPa6cZvkLlDasUbSRuQLWDBIA50POD1QAbHqyNEH3l6q16xH06j3dAYIk1I
        PavNWahldAS537zJu8lwbwXwdeLhWD5tD8Dmk/F6Jbfm0YerZic613b9IACpiQ6iMrPHqF
        19yZk+1vhaEKkyVZKI/NlBfBzpSoFts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-5NhhAunyNueHcJ4qmsSIdA-1; Wed, 17 Jun 2020 21:34:07 -0400
X-MC-Unique: 5NhhAunyNueHcJ4qmsSIdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8969C1005512;
        Thu, 18 Jun 2020 01:34:05 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22DCB5C1D6;
        Thu, 18 Jun 2020 01:34:05 +0000 (UTC)
Date:   Wed, 17 Jun 2020 19:34:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qian Cai <cai@lca.pw>, kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 64/80] vfio/pci: fix memory leaks of eventfd
 ctx
Message-ID: <20200617193404.715afb64@x1.home>
In-Reply-To: <20200618012819.609778-64-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
        <20200618012819.609778-64-sashal@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Jun 2020 21:28:03 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Qian Cai <cai@lca.pw>
> 
> [ Upstream commit 1518ac272e789cae8c555d69951b032a275b7602 ]
> 
> Finished a qemu-kvm (-device vfio-pci,host=0001:01:00.0) triggers a few
> memory leaks after a while because vfio_pci_set_ctx_trigger_single()
> calls eventfd_ctx_fdget() without the matching eventfd_ctx_put() later.
> Fix it by calling eventfd_ctx_put() for those memory in
> vfio_pci_release() before vfio_device_release().
> 
> unreferenced object 0xebff008981cc2b00 (size 128):
>   comm "qemu-kvm", pid 4043, jiffies 4294994816 (age 9796.310s)
>   hex dump (first 32 bytes):
>     01 00 00 00 6b 6b 6b 6b 00 00 00 00 ad 4e ad de  ....kkkk.....N..
>     ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
>   backtrace:
>     [<00000000917e8f8d>] slab_post_alloc_hook+0x74/0x9c
>     [<00000000df0f2aa2>] kmem_cache_alloc_trace+0x2b4/0x3d4
>     [<000000005fcec025>] do_eventfd+0x54/0x1ac
>     [<0000000082791a69>] __arm64_sys_eventfd2+0x34/0x44
>     [<00000000b819758c>] do_el0_svc+0x128/0x1dc
>     [<00000000b244e810>] el0_sync_handler+0xd0/0x268
>     [<00000000d495ef94>] el0_sync+0x164/0x180
> unreferenced object 0x29ff008981cc4180 (size 128):
>   comm "qemu-kvm", pid 4043, jiffies 4294994818 (age 9796.290s)
>   hex dump (first 32 bytes):
>     01 00 00 00 6b 6b 6b 6b 00 00 00 00 ad 4e ad de  ....kkkk.....N..
>     ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
>   backtrace:
>     [<00000000917e8f8d>] slab_post_alloc_hook+0x74/0x9c
>     [<00000000df0f2aa2>] kmem_cache_alloc_trace+0x2b4/0x3d4
>     [<000000005fcec025>] do_eventfd+0x54/0x1ac
>     [<0000000082791a69>] __arm64_sys_eventfd2+0x34/0x44
>     [<00000000b819758c>] do_el0_svc+0x128/0x1dc
>     [<00000000b244e810>] el0_sync_handler+0xd0/0x268
>     [<00000000d495ef94>] el0_sync+0x164/0x180
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/vfio/pci/vfio_pci.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index c94167d87178..9d8715abbec1 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -390,6 +390,10 @@ static void vfio_pci_release(void *device_data)
>  	if (!(--vdev->refcnt)) {
>  		vfio_spapr_pci_eeh_release(vdev->pdev);
>  		vfio_pci_disable(vdev);
> +		if (vdev->err_trigger)
> +			eventfd_ctx_put(vdev->err_trigger);
> +		if (vdev->req_trigger)
> +			eventfd_ctx_put(vdev->req_trigger);
>  	}
>  
>  	mutex_unlock(&driver_lock);

This has a fix pending, I'd suggest not picking it on its own:

https://lore.kernel.org/kvm/20200616085052.sahrunsesjyjeyf2@beryllium.lan/
https://lore.kernel.org/kvm/159234276956.31057.6902954364435481688.stgit@gimli.home/

Thanks,
Alex

