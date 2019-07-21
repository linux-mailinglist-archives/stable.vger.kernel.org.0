Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC666F3DE
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 17:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfGUPJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 11:09:56 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:44605 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGUPJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 11:09:56 -0400
Received: by mail-vs1-f65.google.com with SMTP id v129so24511970vsb.11
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 08:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zG8aLT6lfItM8qaEUsNkWYhVYI1/8Y0nvjYXl2JQXCM=;
        b=eYEhuYE0F2x75ggMSq5yDBTdfPSJrlzSGqpAXkNPpFojFX3etX80ncDj3QfNc4Yemt
         gif6TXFKN6kSO5kxq0MRA2kcG/nCh6xS7Se7Uyn54sIQ+nWxSHJPa7G2vYZZQrylJdxC
         ScZEQYxMFhq0Rdfi4pMbwyEOZ73G6pKTy+10E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zG8aLT6lfItM8qaEUsNkWYhVYI1/8Y0nvjYXl2JQXCM=;
        b=jV0tdq8xMA18LSN4nrMvKajoJFKySQWuuQFvKGeW9iKrbSackcpNPhLCJd0+tYFTkT
         d+6RQnuPviNI9bJzE9AvpxJb+TweQpE2tZ0ienZcHUdXS8swAROV6fcw9DO9i+0lvG7k
         UmQTq72kWrXrDH/Sql6O0jAIUCqyT0gLJdtVvk2DnloFDgVKoT08wy7HBT1FBLJM8aFw
         CqILwa/7ftkH/EldtfPIFiN8y28s5ZsS/It4QdhX94jj7pj1lrB3skHtzAL3mIJr1vxE
         qInfAjvNqHrJKJ0vYkVJzwECwsDV9mz+DoVZB1pwLS0uiwlKxj5jOfFCGKiyZLJymYQy
         FVuQ==
X-Gm-Message-State: APjAAAW4QUtGtxbzdlStUPLlK2D7VVqXa+BlzYWApV4gEVWU/0eGDfXk
        kVr6/pFPoFsaBQ9ATR/YWqjfbDeOSqkCCisasxPMNA==
X-Google-Smtp-Source: APXvYqwWBT1g2Ak7w0GOJATHKbJFWfPf4sOoNmzsLRhF5Mzg7QwePiB9s+WEnWpF5060CDnVikKHW4iTUomQWLL4jyY=
X-Received: by 2002:a67:ebcb:: with SMTP id y11mr29627031vso.138.1563721795520;
 Sun, 21 Jul 2019 08:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190716180940.17828-1-sumit.saxena@broadcom.com>
 <CAL2rwxpc-Ub7ufs1SEEmnNaxtZg2KtY-QAuQnu95kXVPN8Z02Q@mail.gmail.com> <90cdfa16-5fdf-e9a4-4e5d-e4b7651f181b@amd.com>
In-Reply-To: <90cdfa16-5fdf-e9a4-4e5d-e4b7651f181b@amd.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Sun, 21 Jul 2019 20:39:46 +0530
Message-ID: <CAL2rwxq=wVRjPBJqupTvbO8ocWqiaOzDuHpajN3Oi90pBOYsNg@mail.gmail.com>
Subject: Re: [PATCH] PCI: set BAR size bits correctly in Resize BAR control register
To:     "Koenig, Christian" <Christian.Koenig@amd.com>
Cc:     "helgaas@kernel.org" <helgaas@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 21, 2019 at 8:17 PM Koenig, Christian
<Christian.Koenig@amd.com> wrote:
>
> Am 19.07.19 um 19:56 schrieb Sumit Saxena:
> > +Christian Koenig
> >
> > On Tue, Jul 16, 2019 at 3:41 PM Sumit Saxena <sumit.saxena@broadcom.com> wrote:
> >> In Resize BAR control register, bits[8:12] represents size of BAR.
> >> As per PCIe specification, below is encoded values in register bits
> >> to actual BAR size table:
> >>
> >> Bits  BAR size
> >> 0     1 MB
> >> 1     2 MB
> >> 2     4 MB
> >> 3     8 MB
> >> --
> >>
> >> For 1 MB BAR size, BAR size bits should be set to 0 but incorrectly
> >> these bits are set to "1f".
> >> Latest megaraid_sas and mpt3sas adapters which support Resizable BAR
> >> with 1 MB BAR size fails to initialize during system resume from S3 sleep.
> >>
> >> Fix: Correctly set BAR size bits to "0" for 1MB BAR size.
> >>
> >> CC: stable@vger.kernel.org # v4.16+
> >> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203939
> >> Fixes: d3252ace0bc652a1a244455556b6a549f969bf99 ("PCI: Restore resized BAR state on resume")
> >> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> >> ---
> >>   drivers/pci/pci.c | 5 +++--
> >>   1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> >> index 8abc843..b651f32 100644
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -1417,12 +1417,13 @@ static void pci_restore_rebar_state(struct pci_dev *pdev)
> >>
> >>          for (i = 0; i < nbars; i++, pos += 8) {
> >>                  struct resource *res;
> >> -               int bar_idx, size;
> >> +               int bar_idx, size, order;
> >>
> >>                  pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
> >>                  bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
> >>                  res = pdev->resource + bar_idx;
> >> -               size = order_base_2((resource_size(res) >> 20) | 1) - 1;
> >> +               order = order_base_2((resource_size(res) >> 20) | 1);
> >> +               size = order ? order - 1 : 0;
>
> That actually doesn't looks like it is correct or at least it's
> unnecessary complex.
>
> The " >> 20) | 1" seems like a copy & paste error from the code in
> amdgpu where the BAR needs to larger than the VRAM size (which is not a
> power of two).
>
> So just using "size = order_base_2(resource_size(res) >> 20);" should be
> sufficient here.
Agreed, thanks for feedback. I will send simplified version of the
patch using just-
"size = order_base_2(resource_size(res) >> 20);".

Thanks,
Sumit
>
> Regards,
> Christian.
>
> >>                  ctrl &= ~PCI_REBAR_CTRL_BAR_SIZE;
> >>                  ctrl |= size << PCI_REBAR_CTRL_BAR_SHIFT;
> >>                  pci_write_config_dword(pdev, pos + PCI_REBAR_CTRL, ctrl);
> >> --
> >> 1.8.3.1
> >>
>
