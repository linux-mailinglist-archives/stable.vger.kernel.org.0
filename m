Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A68D1AD258
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 23:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgDPVzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 17:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728646AbgDPVzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 17:55:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9387C061A0C;
        Thu, 16 Apr 2020 14:55:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k1so438573wrx.4;
        Thu, 16 Apr 2020 14:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rAFWRmCauzapDqY6zF6wYDHpb+eX5UR9B/4Z3NEvnTc=;
        b=CNfYTVuKIBIp6tZgQC803INlAGosjrnkwkNgVhBDqENWuNDr9mf4jy8DRNAGzy1rLJ
         s6pUD8o0PoziHcCdGenejLs5ji4NtbucA0Eace9Ru1Fr9SgytsHeMpwstkZukWu3VNws
         Wrm4g8cDoc17wSb5J+ItL0tQfL2a/x+0x8gLW3LHYaZ1A4MQTCTzF8jRu5DPCtdVFVfF
         TmejhNxo9ziq/n0Jh3ZxzqMbhy2kDutTBe2wDY7zwk+cslfkmD02o6j9mdUzadthe5dB
         lp37SHR8mi1NfGEro4U4JG+EMIL/yuNPE/d9EJDLGOIMlG3TcdZ4/2wxIm2Pxj7FCfa9
         hA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rAFWRmCauzapDqY6zF6wYDHpb+eX5UR9B/4Z3NEvnTc=;
        b=EL/9HOhHsgb3kJHL57n9LWK6igU0pHdtXuMHDwJyldXH57Fwc+2bHcFpjhDDzKE/U8
         t7ub32pG/I7LXia9iJJZy2c9y8YAanRp1r8ptqBx5anfTbXlvRO7BMu/bdVjp+cHriXY
         VrL8w9uUobBm31P0T/Vulmzb2MZdLoLXfxElPSh/IrsxnGXbDTzEkVXUsMJSZz5M5kGB
         nZnXA27EAvx8B7ebol6ghv/Mg2POTgclj3d6xUAT7/W2Si4b6Gc0S2hFHhib3Svkd8eE
         Chj1eQG2A6xJKbHFnmKscUhojqBJk9rdew6INUKpheSqwI3XWf+/9GCBxMAj6EA2HwXb
         3MtA==
X-Gm-Message-State: AGi0PubwXqgTdTsdueD2y4u5FEkIiB6o8HsTwGs+oCxEuBSs+PbOZu1g
        AwWlHD7lWmOcB5ARXljL7EfhvuUjDi6+tnxsLcY=
X-Google-Smtp-Source: APiQypKBG9g3I0G49ErAhZ5RFh0i026vsX5S8R4TJ6e0ibQ5yL9ar7nTPz5H115z+Cbfywn0ifljaq0XdjHCtbp/kxo=
X-Received: by 2002:adf:f146:: with SMTP id y6mr361227wro.132.1587074102376;
 Thu, 16 Apr 2020 14:55:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200407213058.62870-1-hdegoede@redhat.com> <CAKErNvqM9ax8RB+Hm0e70a_uk_Ok3KfSQDmy0q9jKFaAQM3Fsg@mail.gmail.com>
 <b876973e-71f4-1dbc-1b41-138f81511685@redhat.com>
In-Reply-To: <b876973e-71f4-1dbc-1b41-138f81511685@redhat.com>
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Fri, 17 Apr 2020 00:54:36 +0300
Message-ID: <CAKErNvqqHAVAkETsSjneSpaPNwoaHh1F=4XKS8F+ZBPp0gR0YQ@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: intel_int0002_vgpio: Only bind to the
 INT0002 dev when using s2idle
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 3+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 4:24 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 4/8/20 2:11 PM, Maxim Mikityanskiy wrote:
> > On Wed, Apr 8, 2020 at 12:31 AM Hans de Goede <hdegoede@redhat.com> wro=
te:
> >>
> >> Commit 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implemen=
t
> >> irq_set_wake on Bay Trail") stopped passing irq_set_wake requests on t=
o
> >> the parents IRQ because this was breaking suspend (causing immediate
> >> wakeups) on an Asus E202SA.
> >>
> >> This workaround for this issue is mostly fine, on most Cherry Trail
> >> devices where we need the INT0002 device for wakeups by e.g. USB kbds,
> >> the parent IRQ is shared with the ACPI SCI and that is marked as wakeu=
p
> >> anyways.
> >>
> >> But not on all devices, specifically on a Medion Akoya E1239T there is
> >> no SCI at all, and because the irq_set_wake request is not passed on t=
o
> >> the parent IRQ, wake up by the builtin USB kbd does not work here.
> >>
> >> So the workaround for the Asus E202SA immediate wake problem is causin=
g
> >> problems elsewhere; and in hindsight it is not the correct fix,
> >> the Asus E202SA uses Airmont CPU cores, but this does not mean it is a
> >> Cherry Trail based device, Brasswell uses Airmont CPU cores too and th=
is
> >> actually is a Braswell device.
> >>
> >> Most (all?) Braswell devices use classic S3 mode suspend rather then
> >> s2idle suspend and in this case directly dealing with PME events as
> >> the INT0002 driver does likely is not the best idea, so that this is
> >> causing issues is not surprising.
> >>
> >> Replace the workaround of not passing irq_set_wake requests on to the
> >> parents IRQ, by not binding to the INT0002 device when s2idle is not u=
sed.
> >> This fixes USB kbd wakeups not working on some Cherry Trail devices,
> >> while still avoiding mucking with the wakeup flags on the Asus E202SA
> >> (and other Brasswell devices).
> >
> > I tested this patch over kernel 5.6.2 on Asus E202SA and didn't notice
> > any regressions. Wakeup by opening lid, by pressing a button on
> > keyboard, by USB keyboard =E2=80=94 all seem to work fine. So, if appro=
priate:
> >
> > Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
>
> Thank you for testing this.
>
> > I have a question though. After your patch this driver will basically
> > be a no-op on my laptop. Does it mean I don't even need it in the
> > first place? What about the IRQ storm this driver is meant to deal
> > with =E2=80=94 does it never happen on Braswell? What are the reproduct=
ion
> > steps to verify my hardware is not affected? I have that INT0002
> > device, so I'm worried it may cause issues if not bound to the driver.
>
> I do not expect Braswell platforms to suffer from the IRQ storm
> issue. That was something which I hit on a Cherry Trail based device.
>
> To test this, try waking up the device from suspend by an USB attached
> keyboard (this may not work, in that case wake it some other way).
>
> After this do:
>
> cat /proc/interrupts | grep " 9-fasteoi"
>
> This should output something like this:
>
> [root@localhost ~]# cat /proc/interrupts | grep " 9-fasteoi"
>     9:          0          0          0          0   IO-APIC    9-fasteoi=
   acpi
>
> Repeat this a couple of times, of the numbers after the 9:
> increase (very) rapidly you have an interrupt storm. Likely
> they will either be fully unchanged or change very slowly.

Thanks a lot for the instructions. After a wakeup by USB keyboard, the
counter increased by a few hundred (compared to the value before
suspend), but there was no further growth, so it looks I'm safe.
(Tested with your patch, of course.)

> Note if nothing is output then IRQ 9 is not used on your
> model, then the INT0002 device cannot cause an interrupt storm.
>
> Regards,
>
> Hans
>
>
>
> >
> >> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> >> Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
> >> Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implemen=
t irq_set_wake on Bay Trail")
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >> ---
> >>   drivers/platform/x86/intel_int0002_vgpio.c | 18 +++++-------------
> >>   1 file changed, 5 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/plat=
form/x86/intel_int0002_vgpio.c
> >> index 55f088f535e2..e8bec72d3823 100644
> >> --- a/drivers/platform/x86/intel_int0002_vgpio.c
> >> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
> >> @@ -143,21 +143,9 @@ static struct irq_chip int0002_byt_irqchip =3D {
> >>          .irq_set_wake           =3D int0002_irq_set_wake,
> >>   };
> >>
> >> -static struct irq_chip int0002_cht_irqchip =3D {
> >> -       .name                   =3D DRV_NAME,
> >> -       .irq_ack                =3D int0002_irq_ack,
> >> -       .irq_mask               =3D int0002_irq_mask,
> >> -       .irq_unmask             =3D int0002_irq_unmask,
> >> -       /*
> >> -        * No set_wake, on CHT the IRQ is typically shared with the AC=
PI SCI
> >> -        * and we don't want to mess with the ACPI SCI irq settings.
> >> -        */
> >> -       .flags                  =3D IRQCHIP_SKIP_SET_WAKE,
> >> -};
> >> -
> >>   static const struct x86_cpu_id int0002_cpu_ids[] =3D {
> >>          INTEL_CPU_FAM6(ATOM_SILVERMONT, int0002_byt_irqchip),   /* Va=
lleyview, Bay Trail  */
> >> -       INTEL_CPU_FAM6(ATOM_AIRMONT, int0002_cht_irqchip),      /* Bra=
swell, Cherry Trail */
> >> +       INTEL_CPU_FAM6(ATOM_AIRMONT, int0002_byt_irqchip),      /* Bra=
swell, Cherry Trail */
> >>          {}
> >>   };
> >>
> >> @@ -181,6 +169,10 @@ static int int0002_probe(struct platform_device *=
pdev)
> >>          if (!cpu_id)
> >>                  return -ENODEV;
> >>
> >> +       /* We only need to directly deal with PMEs when using s2idle *=
/
> >> +       if (!pm_suspend_default_s2idle())
> >> +               return -ENODEV;
> >> +
> >>          irq =3D platform_get_irq(pdev, 0);
> >>          if (irq < 0)
> >>                  return irq;
> >> --
> >> 2.26.0
> >>
> >
>
