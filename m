Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F2D35BB58
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 09:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhDLHwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 03:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbhDLHwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 03:52:49 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF6DC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 00:52:32 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id t14so10209490ilu.3
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 00:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DdceCmZ2FH904nfOs2t/mm+fumePewB2yMQTYqW1pUQ=;
        b=Apq4GwRO8+k0lzIl6z+h+uu8KBzvRtqh328zmOmdX9D8WZDYE43EDj6UJ61SmYmvyY
         DJYhKdL1TrcBWmGShxBBKJ+I7QrwnDJwBAqpkbS1gRDWVpqtdWBpMLqDEoOq6CABvLgR
         nVFTAYG5vfrcdyXQR58db52lun1FYbLhQHMtvbVNGdlXijCx+uCmMysT/fsnpIHRa58p
         cG8r8q/KqmIu4yR/+1pLa16Uw4sYVQ+kY7tKpgV6H1l1IXK43TEON0i7oy9fkvwt9pX9
         AxYtvzX5CROT/ew5dySY6+1CdpLia9Ksrs7pLiP1zHg29+6QVRWO+yxNPOTdzqzjtXb+
         i5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DdceCmZ2FH904nfOs2t/mm+fumePewB2yMQTYqW1pUQ=;
        b=sytizIjL3wQEgTU+aae9no0Hzaiyi7jb2PyJ10EM1KfHqlpF03Ghp6j6wdip5qUPsB
         dmqBBdOFSvgGQtXK0KPzdE7IXvxbd6Isw69wyDWh6dQ4B/JZH1NxPrDGp7/p7MOvtamc
         HlqeP2UuW/4aJsrtupG5Zg+Vhj4LqzSJDtGvUxxYUSCo3zQ5oNsDX6UjCWCI/ZtJZAiZ
         YA6z03+JYz8X/Z75v6yuYulERBbshLV6xpg+OsKPUjhOwklExP+1kH/htMo8bUBL3IUm
         kjBkUDKhbtSYLGA/8Y6FWsWXIWLnhFGPdYYa2Mq7fapzuDAtjetmoLTTMv9J+VFZ/lUy
         u5iA==
X-Gm-Message-State: AOAM530/bzppRLljdXFXjmjEB6x7UedvnLfz4MuBHg9bNkS3rFDWBlyc
        /In0cV+cJGpxCvIoSZRh82NZTzjeHR3wZVaiCcE=
X-Google-Smtp-Source: ABdhPJx7/tHGIFdoZNnflfZ2w5YJbwrMyXJroyLcG0K9F4HeVTdf/EskJQeu4mNbgaLq4xasyQncDOldYVAOl+JcSJs=
X-Received: by 2002:a05:6e02:118b:: with SMTP id y11mr8491030ili.163.1618213951540;
 Mon, 12 Apr 2021 00:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210408104622.943843-1-vaibhav@linux.ibm.com>
In-Reply-To: <20210408104622.943843-1-vaibhav@linux.ibm.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Mon, 12 Apr 2021 09:52:20 +0200
Message-ID: <CAM9Jb+j6oVumXQ+zmYbQSvQ3UzLKT3V8XLq1SotVcwVuUwP09A@mail.gmail.com>
Subject: Re: [PATCH v3] libnvdimm/region: Update nvdimm_has_flush() to handle
 explicit 'flush' callbacks
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vaibhav,

> In case a platform doesn't provide explicit flush-hints but provides an
> explicit flush callback, then nvdimm_has_flush() still returns '0'
> indicating that writes do not require flushing. This happens on PPC64
> with patch at [1] applied, where 'deep_flush' of a region was denied
> even though an explicit flush function was provided.
>
> Similar problem is also seen with virtio-pmem where the 'deep_flush'
> sysfs attribute is not visible as in absence of any registered nvdimm,
> 'nd_region->ndr_mappings == 0'.

In case of async flush callback, do we still need "deep_flush" ?

Thanks,
Pankaj
>
> Fix this by updating nvdimm_has_flush() adding a condition to
> nvdimm_has_flush() to test if a 'region->flush' callback is
> assigned. Also remove explicit test for 'nd_region->ndr_mapping' since
> regions may need 'flush' without any explicit mappings as in case of
> virtio-pmem.
>
> References:
> [1] "powerpc/papr_scm: Implement support for H_SCM_FLUSH hcall"
> https://lore.kernel.org/linux-nvdimm/161703936121.36.7260632399582101498.stgit@e1fbed493c87
>
> Cc: <stable@vger.kernel.org>
> Fixes: c5d4355d10d4 ("libnvdimm: nd_region flush callback support")
> Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
> Changelog:
>
> v3:
> * Removed the test for ND_REGION_SYNC to handle case where a
>   synchronous region still wants to expose a deep-flush function.
>   [ Aneesh ]
> * Updated patch title and description from previous patch
>   https://lore.kernel.org/linux-nvdimm/5e64778d-bf48-9f10-7d3d-5e530e5db590@linux.ibm.com
>
> v2:
> * Added the fixes tag and addressed the patch to stable tree [ Aneesh ]
> * Updated patch description to address the virtio-pmem case.
> * Removed test for 'nd_region->ndr_mappings' from beginning of
>   nvdimm_has_flush() to handle the virtio-pmem case.
> ---
>  drivers/nvdimm/region_devs.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index ef23119db574..c4b17bdd527f 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1234,11 +1234,15 @@ int nvdimm_has_flush(struct nd_region *nd_region)
>  {
>         int i;
>
> -       /* no nvdimm or pmem api == flushing capability unknown */
> -       if (nd_region->ndr_mappings == 0
> -                       || !IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
> +       /* no pmem api == flushing capability unknown */
> +       if (!IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
>                 return -ENXIO;
>
> +       /* Test if an explicit flush function is defined */
> +       if (nd_region->flush)
> +               return 1;
> +
> +       /* Test if any flush hints for the region are available */
>         for (i = 0; i < nd_region->ndr_mappings; i++) {
>                 struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>                 struct nvdimm *nvdimm = nd_mapping->nvdimm;
> @@ -1249,8 +1253,8 @@ int nvdimm_has_flush(struct nd_region *nd_region)
>         }
>
>         /*
> -        * The platform defines dimm devices without hints, assume
> -        * platform persistence mechanism like ADR
> +        * The platform defines dimm devices without hints nor explicit flush,
> +        * assume platform persistence mechanism like ADR
>          */
>         return 0;
>  }
> --
> 2.30.2
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
