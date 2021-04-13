Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3278A35D485
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 02:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbhDMAyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 20:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDMAyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 20:54:10 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC5EC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 17:53:50 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id y2so11496601qtw.13
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 17:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7+G5ztQszCN2u7CMf/hH/Cu7szVvqC9NSfVBk6tQ/jQ=;
        b=ne0SSryQdxdO331TAMynBGaxD4dsUab9TbnfkgWxdvJo8HhaZKo49Hp/OnOb4FL0Rp
         owbtd0Ft56cU3Q51Re7I4pYhmpnIHiOCfQPuS4Nrc4cPgaOzEPsn45yN2+k4CYAAVBMB
         hxS4WL66W0OIl/XbB/vo0csowdBLxwsWHlPYXj2uFJUuBB1DqB/qmt4NE+3+uqAro1Ce
         NgWwouEPART/vPZxNJzB71EMaPWBzeHeovU6/qsl+1ivHRau1pOAzPT1DVjgmoXyegPk
         ZqLaqIE0XxPC2wy5IpPqhCLwxxndheOHDlMRlt5tC1x6Y1SO2KFMUG7IzXya+z+8upmF
         IbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7+G5ztQszCN2u7CMf/hH/Cu7szVvqC9NSfVBk6tQ/jQ=;
        b=Sgkbjb+24o6ibCeQx+CPIsoNOBJHAJhM3e02nuOqrha8uN3NC4/DLIku4mP00+6hzW
         UbtLURg4pZAbu2FBMCB3vWkdnkkAZ4FpX34JDzq0Cv+P1YtgbeuybmRrlJhBEUfnSfbk
         CE8QX9ymeiO3fW0tkrMEOWLAphMGccMXmcvLsV5DA9QbYKoC+f4FnoURZ/7H3M1Xohs5
         8CR25m2tnhthbymjMNi0pVNtibVDcph2CX4vEYIigoOfx8x3GmsnkPyomp6J2C7oliXC
         HDZNO6zd1RvH/2rs8TXX+bvoZJeGovp5CChCyACTmhPNKlt/wiUuIqDjYZDLHzFrX1Ix
         jfKw==
X-Gm-Message-State: AOAM531ccqtRyPWWjqzkbNgU1mya+Qma7KtzOq1/g8etlL7CFtqQOOV9
        oJlz/etZRfs2MJ1pNqas6p5K/gQdELPuA7fLkr/4vPXUem7Jzg==
X-Google-Smtp-Source: ABdhPJw1lrRzj9tsypZ8YqAMY91dodrQenT0xfmw5E3znDxT93l6yAvi1fAE+VFLLUlzh/1n6L4fqpt53SYuTtW0+C8=
X-Received: by 2002:a05:622a:c4:: with SMTP id p4mr27807435qtw.240.1618275230060;
 Mon, 12 Apr 2021 17:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <161821396263.48361.2796709239866588652.stgit@jupiter>
In-Reply-To: <161821396263.48361.2796709239866588652.stgit@jupiter>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Tue, 13 Apr 2021 10:53:39 +1000
Message-ID: <CAOSf1CG3oYCnWx+gV3VgYzkQJTvVEeMGDyKjMAQRdH8w23C2QA@mail.gmail.com>
Subject: Re: [PATCH v2] powerpc/eeh: Fix EEH handling for hugepages in ioremap space.
To:     Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc:     linuxppc-dev <linuxppc-dev@ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 5:52 PM Mahesh Salgaonkar <mahesh@linux.ibm.com> wrote:
>
> During the EEH MMIO error checking, the current implementation fails to map
> the (virtual) MMIO address back to the pci device on radix with hugepage
> mappings for I/O. This results into failure to dispatch EEH event with no
> recovery even when EEH capability has been enabled on the device.
>
> eeh_check_failure(token)                # token = virtual MMIO address
>   addr = eeh_token_to_phys(token);
>   edev = eeh_addr_cache_get_dev(addr);
>   if (!edev)
>         return 0;
>   eeh_dev_check_failure(edev);  <= Dispatch the EEH event
>
> In case of hugepage mappings, eeh_token_to_phys() has a bug in virt -> phys
> translation that results in wrong physical address, which is then passed to
> eeh_addr_cache_get_dev() to match it against cached pci I/O address ranges
> to get to a PCI device. Hence, it fails to find a match and the EEH event
> never gets dispatched leaving the device in failed state.
>
> The commit 33439620680be ("powerpc/eeh: Handle hugepages in ioremap space")
> introduced following logic to translate virt to phys for hugepage mappings:
>
> eeh_token_to_phys():
> +       pa = pte_pfn(*ptep);
> +
> +       /* On radix we can do hugepage mappings for io, so handle that */
> +       if (hugepage_shift) {
> +               pa <<= hugepage_shift;                  <= This is wrong
> +               pa |= token & ((1ul << hugepage_shift) - 1);
> +       }

I think I vaguely remember thinking "is this right?" at the time.
Apparently not!

Reviewed-by: Oliver O'Halloran <oohall@gmail.com>


It would probably be a good idea to add a debugfs interface to help
with testing the address translation. Maybe something like:

echo <mmio addr> > /sys/kernel/debug/powerpc/eeh_addr_check

Then in the kernel:

struct resource *r = lookup_resource(mmio_addr);
void *virt = ioremap_resource(r);
ret = eeh_check_failure(virt);
iounmap(virt)

return ret;

A little tedious, but then you can write a selftest :)

Oliver
