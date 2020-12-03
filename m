Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC612CE31C
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 00:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388142AbgLCXu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 18:50:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388180AbgLCXu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 18:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607039339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2PLhlAnoOsX/pwTCtmcWSJg6wOqgMga2gkoIQHGoBg=;
        b=Nd9N6NXcue80zbLu1Nqf2Mj+DwzOiCH2DmDzLViXo/luSHwkN12OeeaH4Kx262y15iy9SO
        8nV2I/sfmtyQoMwxkxy6UgCscgDQFXi02i01ctL1A6oGxDcHGetCuMX3FdahbMUeHsvwCu
        DPtiwIELwiOcay2OqeFtasyv4myuM3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-rNmOTHbUNfuBpzE4t0YOvg-1; Thu, 03 Dec 2020 18:48:56 -0500
X-MC-Unique: rNmOTHbUNfuBpzE4t0YOvg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6192C10766BA;
        Thu,  3 Dec 2020 23:48:54 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 490AF1A8A0;
        Thu,  3 Dec 2020 23:48:52 +0000 (UTC)
Date:   Thu, 3 Dec 2020 16:48:52 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org,
        Leonardo Augusto =?UTF-8?B?R3VpbWFyw6Nlcw==?= Garcia 
        <lagarcia@br.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
        kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH kernel v2] vfio/pci/nvlink2: Do not attempt NPU2 setup
 on POWER8NVL NPU
Message-ID: <20201203164852.46d5f7c0@w520.home>
In-Reply-To: <20201122073950.15684-1-aik@ozlabs.ru>
References: <20201122073950.15684-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 22 Nov 2020 18:39:50 +1100
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> We execute certain NPU2 setup code (such as mapping an LPID to a device
> in NPU2) unconditionally if an Nvlink bridge is detected. However this
> cannot succeed on POWER8NVL machines as the init helpers return an error
> other than ENODEV which means the device is there is and setup failed so
> vfio_pci_enable() fails and pass through is not possible.
> 
> This changes the two NPU2 related init helpers to return -ENODEV if
> there is no "memory-region" device tree property as this is
> the distinction between NPU and NPU2.
> 
> Tested on
> - POWER9 pvr=004e1201, Ubuntu 19.04 host, Ubuntu 18.04 vm,
>   NVIDIA GV100 10de:1db1 driver 418.39
> - POWER8 pvr=004c0100, RHEL 7.6 host, Ubuntu 16.10 vm,
>   NVIDIA P100 10de:15f9 driver 396.47
> 
> Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
> Cc: stable@vger.kernel.org # 5.0
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> Changes:
> v2:
> * updated commit log with tested configs and replaced P8+ with POWER8NVL for clarity
> ---
>  drivers/vfio/pci/vfio_pci_nvlink2.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Thanks, applies to vfio next branch for v5.11.

Alex


> 
> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> index 65c61710c0e9..9adcf6a8f888 100644
> --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> @@ -231,7 +231,7 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
>  		return -EINVAL;
>  
>  	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
> -		return -EINVAL;
> +		return -ENODEV;
>  
>  	mem_node = of_find_node_by_phandle(mem_phandle);
>  	if (!mem_node)
> @@ -393,7 +393,7 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
>  	int ret;
>  	struct vfio_pci_npu2_data *data;
>  	struct device_node *nvlink_dn;
> -	u32 nvlink_index = 0;
> +	u32 nvlink_index = 0, mem_phandle = 0;
>  	struct pci_dev *npdev = vdev->pdev;
>  	struct device_node *npu_node = pci_device_to_OF_node(npdev);
>  	struct pci_controller *hose = pci_bus_to_host(npdev->bus);
> @@ -408,6 +408,9 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
>  	if (!pnv_pci_get_gpu_dev(vdev->pdev))
>  		return -ENODEV;
>  
> +	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
> +		return -ENODEV;
> +
>  	/*
>  	 * NPU2 normally has 8 ATSD registers (for concurrency) and 6 links
>  	 * so we can allocate one register per link, using nvlink index as

