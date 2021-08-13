Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5063EB156
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 09:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbhHMHYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhHMHYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 03:24:18 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CC4C061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 00:23:52 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id h63-20020a9d14450000b02904ce97efee36so11063332oth.7
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 00:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=znhRbv8NcYlT3eDS8D533ikh6xA5L2FrHFf4HCQZwu0=;
        b=DpU+hRvBA0VVkiow2d5h3EE47XKuwk74YlpbxQyIZVwF+VEMimQEDqofGMqvYpDAYe
         TJZMn7rpvGmWKZWD/Kq/t72yrMspD5Vs+X9uS+/IKhCJjJZttF43GR5V/qyYS0IqcziV
         hRAXFWuge0kSkQmmgBpJAtg+sPH1jWoIeZ6lU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=znhRbv8NcYlT3eDS8D533ikh6xA5L2FrHFf4HCQZwu0=;
        b=sXwnDZHbOAyd73Ow5hMKYH8GiCw/dlc02IGlBcdV3CjBLXjCkiZMsllryXHgh1+rv9
         JsCEyZjnOmfqnUvTpjlfemQUxprN4APlD0ozMXqXUY6RmLcQC8tJlTObFMtiGXytp90P
         LKoD3k7qYjECfXSogfEdADJj9exIqCUMFPSL1Pv7LZ6R+mE2EzvXGky4y5xT60y89iBQ
         BIxevoBdgI2Snp4/tl1hrfYJrLhKnoV1BO/HHQ38uFzd4BKcGRB9gIC2jTKt1N3TLvzv
         mBadEufT8wEWOMH/yclODFm5sr/ZDmYIvodOaAiTUQN+nfkMDW1JPOl0DdLNH/tDBnom
         ndpA==
X-Gm-Message-State: AOAM532GfIcPP3axyxsC4myXgkXYJc+XxSFmamEtXwJ/JltAjHppWdsS
        hIpv6BplYZ8zP0x1XV+EayHHJkwynmGFwJ62dVKArQ==
X-Google-Smtp-Source: ABdhPJzIFT7P25yEp7plaLNd9TIZv8MpEnp8fQf4Gdho9oyN4CpBRcyoBdjk1iTMJASDIFHFMEc/zYSMqZZ7p0/F4wA=
X-Received: by 2002:a9d:6b85:: with SMTP id b5mr1007957otq.303.1628839430499;
 Fri, 13 Aug 2021 00:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210812132144.791268-1-kw@linux.com> <20210812161710.GA2479934@bjorn-Precision-5520>
In-Reply-To: <20210812161710.GA2479934@bjorn-Precision-5520>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 13 Aug 2021 09:23:39 +0200
Message-ID: <CAKMK7uFzQphtMmYVyc4=cONQFQDaPpRFAXpCiL1KcDVHN=AVjA@mail.gmail.com>
Subject: Re: [PATCH] PCI/sysfs: Use correct variable for the legacy_mem sysfs object
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 12, 2021 at 6:17 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> [+to Greg, please update sysfs_defferred_iomem_get_mapping-5.15]
>
> On Thu, Aug 12, 2021 at 01:21:44PM +0000, Krzysztof Wilczy=C5=84ski wrote=
:
> > Two legacy PCI sysfs objects "legacy_io" and "legacy_mem" were updated
> > to use an unified address space in the commit 636b21b50152 ("PCI: Revok=
e
> > mappings like devmem").  This allows for revocations to be managed from
> > a single place when drivers want to take over and mmap() a /dev/mem
> > range.
> >
> > Following the update, both of the sysfs objects should leverage the
> > iomem_get_mapping() function to get an appropriate address range, but
> > only the "legacy_io" has been correctly updated - the second attribute
> > seems to be using a wrong variable to pass the iomem_get_mapping()
> > function to.
> >
> > Thus, correct the variable name used so that the "legacy_mem" sysfs
> > object would also correctly call the iomem_get_mapping() function.
> >
> > Fixes: 636b21b50152 ("PCI: Revoke mappings like devmem")
> > Signed-off-by: Krzysztof Wilczy=C5=84ski <kw@linux.com>
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
> Ouch.  This needs to be applied to any -stable trees that contain
> 636b21b50152, which was merged in v5.12.

Ouch indeed. Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

>
> It *also* needs to be applied with the obvious updates to Greg's
> sysfs_defferred_iomem_get_mapping-5.15 branch because it was changed
> by f06aff924f97 ("sysfs: Rename struct bin_attribute member to
> f_mapping") [1]
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git/c=
ommit/?id=3Df06aff924f97
>
> > ---
> >  drivers/pci/pci-sysfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > index 5d63df7c1820..7bbf2673c7f2 100644
> > --- a/drivers/pci/pci-sysfs.c
> > +++ b/drivers/pci/pci-sysfs.c
> > @@ -978,7 +978,7 @@ void pci_create_legacy_files(struct pci_bus *b)
> >       b->legacy_mem->size =3D 1024*1024;
> >       b->legacy_mem->attr.mode =3D 0600;
> >       b->legacy_mem->mmap =3D pci_mmap_legacy_mem;
> > -     b->legacy_io->mapping =3D iomem_get_mapping();
> > +     b->legacy_mem->mapping =3D iomem_get_mapping();
> >       pci_adjust_legacy_attr(b, pci_mmap_mem);
> >       error =3D device_create_bin_file(&b->dev, b->legacy_mem);
> >       if (error)
> > --
> > 2.32.0
> >



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
