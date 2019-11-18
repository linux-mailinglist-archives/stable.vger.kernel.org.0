Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F82CFFF84
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 08:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfKRHbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 02:31:53 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39605 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfKRHbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 02:31:53 -0500
Received: by mail-oi1-f193.google.com with SMTP id v138so14419561oif.6;
        Sun, 17 Nov 2019 23:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Jbto+s277uq5Iyl/VAB/rny899zd+4zTI6NCFD/xNI=;
        b=QCsTrb9JgI9NV8yypNfQApuJL5gYIj21d03yb42rjGjGWC2H/7kyZj7arKSh8A4vBu
         PgLAakVwOe34BodOPTdLsW3ZSFV8wSIR9z3jhurs6yTeBNTWmVD2VF3bSRViD7xE1clg
         3y4VfzlPZBGkWks0TF5bISwQGJJ/sBtn2HA1Wf6mQWGH/5N8P3SYukhBnQldv79WXpNB
         SixZS3BxPNwayjsJzqAxErDWn/Qb8o2KLd3s7p+1kRUXAobQPNTkgQsHOK2gyZBWP74d
         i83/365zqwIlya/+Vm7Rkzdo7AzJ6EHLAiHZlnZf0bS2ABX8YRDimFFNkz8tYlW+7Tlt
         IPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Jbto+s277uq5Iyl/VAB/rny899zd+4zTI6NCFD/xNI=;
        b=KrlWa71eN3JyyvTO4WuZ5n4NHAgf4jFi5d0yfOXldLeZVaV8YZruloaoS+nQ7J2GOZ
         2NNmUucIQ4g9htSiQX5Cz2/VpkVyq/dD29HDMwcdqNthUQP+iKxj32GkPtUhqduQgy6Z
         ODd2SOQYJ5ZkX7me0PTs9zvG+NxoArh9rC3zsXHHb0viBUwLW5IvmcAmy0lIq0LCQSQf
         uTbpt+LPG0WOubnmCTZWi9kgTYZV5r+nR4UCmQI17Hj17+slnStwZ08q1XbKbPW03bDq
         e8SgmFbzVzZGDKtIW+d8awo9EwgTpv427YxaVB/go5z/AD4+YY1vExy0eZ5WJ0h8DFtT
         7sew==
X-Gm-Message-State: APjAAAU/Ca57CrDdLmjBGelvnuOa2rW3P11mqGQ32g/+9vyG+xJYQWht
        493JeF2Zek+90E3OiTd43QhCCLEXqCx3ub5GnLc=
X-Google-Smtp-Source: APXvYqyF6n+wzGprIt4o7gDrVED6fkxbf8xqs5vWFhzqMfqBMsaWYf6oZLeRPA4lpE9GfmJ1FwnzUNrVoOq5yBRkt/A=
X-Received: by 2002:aca:5786:: with SMTP id l128mr19117035oib.53.1574062310353;
 Sun, 17 Nov 2019 23:31:50 -0800 (PST)
MIME-Version: 1.0
References: <1572850664-9861-1-git-send-email-sundeep.lkml@gmail.com> <20191111233756.GA65477@google.com>
In-Reply-To: <20191111233756.GA65477@google.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Mon, 18 Nov 2019 13:01:39 +0530
Message-ID: <CALHRZuqQG3md8j1dcpGtb-yp4ADG3Nnp0A3f_BJPDjr2FFuBMQ@mail.gmail.com>
Subject: Re: [v2 PATCH] PCI: Do not use bus number zero from EA capability
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On Tue, Nov 12, 2019 at 5:08 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Mon, Nov 04, 2019 at 12:27:44PM +0530, sundeep.lkml@gmail.com wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > As per the spec, "Enhanced Allocation (EA) for Memory
> > and I/O Resources" ECN, approved 23 October 2014,
> > sec 6.9.1.2, fixed bus numbers of a bridge must be zero
> > when no function that uses EA is located behind it.
> > Hence assign bus numbers normally instead of assigning
> > zeroes from EA capability. Failing to do this and using
> > zeroes from EA would make the bridges non-functional.
> >
> > Fixes: '2dbce5901179 ("PCI: Assign bus numbers present in
> > EA capability for bridges")'
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Cc: stable@vger.kernel.org    # v5.2+
>
> Applied to pci/resource for v5.5, thanks!
>
> I tweaked it as below so the logic about how to interpret the EA Fixed
> Secondary Bus Number is more localized.  Let me know if that doesn't
> make sense.
>

Looks good. Thanks for applying the patch.

Sundeep

> > ---
> >  drivers/pci/probe.c | 25 +++++++++++++------------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 3d5271a..116b276 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -1090,27 +1090,28 @@ static unsigned int pci_scan_child_bus_extend(struct pci_bus *bus,
> >   * @sub: updated with subordinate bus number from EA
> >   *
> >   * If @dev is a bridge with EA capability, update @sec and @sub with
> > - * fixed bus numbers from the capability and return true.  Otherwise,
> > - * return false.
> > + * fixed bus numbers from the capability. Otherwise @sec and @sub
> > + * will be zeroed.
> >   */
> > -static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
> > +static void pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
> >  {
> >       int ea, offset;
> >       u32 dw;
> >
> > +     *sec = *sub = 0;
> > +
> >       if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
> > -             return false;
> > +             return;
> >
> >       /* find PCI EA capability in list */
> >       ea = pci_find_capability(dev, PCI_CAP_ID_EA);
> >       if (!ea)
> > -             return false;
> > +             return;
> >
> >       offset = ea + PCI_EA_FIRST_ENT;
> >       pci_read_config_dword(dev, offset, &dw);
> >       *sec =  dw & PCI_EA_SEC_BUS_MASK;
> >       *sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
> > -     return true;
> >  }
> >
> >  /*
> > @@ -1146,7 +1147,6 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
> >       u16 bctl;
> >       u8 primary, secondary, subordinate;
> >       int broken = 0;
> > -     bool fixed_buses;
> >       u8 fixed_sec, fixed_sub;
> >       int next_busnr;
> >
> > @@ -1249,11 +1249,12 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
> >               pci_write_config_word(dev, PCI_STATUS, 0xffff);
> >
> >               /* Read bus numbers from EA Capability (if present) */
> > -             fixed_buses = pci_ea_fixed_busnrs(dev, &fixed_sec, &fixed_sub);
> > -             if (fixed_buses)
> > +             pci_ea_fixed_busnrs(dev, &fixed_sec, &fixed_sub);
> > +
> > +             next_busnr = max + 1;
> > +             /* Use secondary bus number in EA */
> > +             if (fixed_sec)
> >                       next_busnr = fixed_sec;
> > -             else
> > -                     next_busnr = max + 1;
> >
> >               /*
> >                * Prevent assigning a bus number that already exists.
> > @@ -1331,7 +1332,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
> >                * If fixed subordinate bus number exists from EA
> >                * capability then use it.
> >                */
> > -             if (fixed_buses)
> > +             if (fixed_sub)
> >                       max = fixed_sub;
> >               pci_bus_update_busn_res_end(child, max);
> >               pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
> > --
> > 2.7.4
> >
>
> commit 25328e0447de ("PCI: Do not use bus number zero from EA capability")
> Author: Subbaraya Sundeep <sbhatta@marvell.com>
> Date:   Mon Nov 4 12:27:44 2019 +0530
>
>     PCI: Do not use bus number zero from EA capability
>
>     As per PCIe r5.0, sec 7.8.5.2, fixed bus numbers of a bridge must be zero
>     when no function that uses EA is located behind it.  Hence, if EA supplies
>     bus numbers of zero, assign bus numbers normally.  A secondary bus can
>     never have a bus number of zero, so setting a bridge's Secondary Bus Number
>     to zero makes downstream devices unreachable.
>
>     [bhelgaas: retain bool return value so "zero is invalid" logic is local]
>     Fixes: 2dbce5901179 ("PCI: Assign bus numbers present in EA capability for bridges")
>     Link: https://lore.kernel.org/r/1572850664-9861-1-git-send-email-sundeep.lkml@gmail.com
>     Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Cc: stable@vger.kernel.org  # v5.2+
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index bdbc8490f962..d3033873395d 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1090,14 +1090,15 @@ static unsigned int pci_scan_child_bus_extend(struct pci_bus *bus,
>   * @sec: updated with secondary bus number from EA
>   * @sub: updated with subordinate bus number from EA
>   *
> - * If @dev is a bridge with EA capability, update @sec and @sub with
> - * fixed bus numbers from the capability and return true.  Otherwise,
> - * return false.
> + * If @dev is a bridge with EA capability that specifies valid secondary
> + * and subordinate bus numbers, return true with the bus numbers in @sec
> + * and @sub.  Otherwise return false.
>   */
>  static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
>  {
>         int ea, offset;
>         u32 dw;
> +       u8 ea_sec, ea_sub;
>
>         if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
>                 return false;
> @@ -1109,8 +1110,13 @@ static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
>
>         offset = ea + PCI_EA_FIRST_ENT;
>         pci_read_config_dword(dev, offset, &dw);
> -       *sec =  dw & PCI_EA_SEC_BUS_MASK;
> -       *sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
> +       ea_sec =  dw & PCI_EA_SEC_BUS_MASK;
> +       ea_sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
> +       if (ea_sec  == 0 || ea_sub < ea_sec)
> +               return false;
> +
> +       *sec = ea_sec;
> +       *sub = ea_sub;
>         return true;
>  }
>
