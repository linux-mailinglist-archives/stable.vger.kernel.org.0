Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EB6110654
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 22:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfLCVMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 16:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfLCVMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 16:12:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C602080F;
        Tue,  3 Dec 2019 21:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575407552;
        bh=Qpgj28s8o35Ah6jwCsKRrwH4hvrw6YEO9zGWvkrMYDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R9wdBCNYmcrP20ZhdJ6gFm+npxrCSTnfWgtne3myflTyvHfU4YVQLl+04BvpGlIAc
         5yXnylqxFhQlP4PW+B++hid6pYXulhnfoOgqRFTD5HCF9olCXhp1mJGwSOi0rsI8Uv
         WQgBGlSw1Xjp50EjP0YL9Yqcb47wtjML7pbZo21s=
Date:   Tue, 3 Dec 2019 22:12:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: [PATCH for-4.4-stable] ath10k: restore QCA9880-AR1A (v1)
 detection
Message-ID: <20191203211230.GA3268839@kroah.com>
References: <2379623.yQyDp7EeDN@debian64>
 <20191202184248.GB734264@kroah.com>
 <CAAd0S9ApFEC7AqiPEiZzpdVymgZDNLSiYe0aLq6hsAydVpzGNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAd0S9ApFEC7AqiPEiZzpdVymgZDNLSiYe0aLq6hsAydVpzGNw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 09:47:38PM +0100, Christian Lamparter wrote:
> On Mon, Dec 2, 2019 at 7:42 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Nov 29, 2019 at 09:53:50PM +0100, Christian Lamparter wrote:
> > > commit f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 upstream
> > > ---
> > > >From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
> > > From: Christian Lamparter <chunkeey@gmail.com>
> > > Date: Mon, 25 Mar 2019 13:50:19 +0100
> > > Subject: [PATCH 4.4] ath10k: restore QCA9880-AR1A (v1) detection
> > > To: linux-wireless@vger.kernel.org,
> > >     ath10k@lists.infradead.org
> > > Cc: Kalle Valo <kvalo@codeaurora.org>
> > >
> > > This patch restores the old behavior that read
> > > the chip_id on the QCA988x before resetting the
> > > chip. This needs to be done in this order since
> > > the unsupported QCA988x AR1A chips fall off the
> > > bus when resetted. Otherwise the next MMIO Op
> > > after the reset causes a BUS ERROR and panic.
> > >
> > > Cc: stable@vger.kernel.org # 4.4
> > > Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
> > > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> > > ---
> > >  drivers/net/wireless/ath/ath10k/pci.c | 36 +++++++++++++++++++--------
> > >  1 file changed, 25 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> > > --- a/drivers/net/wireless/ath/ath10k/pci.c   2019-09-08 00:07:21.374565470 +0200
> > > +++ b/drivers/net/wireless/ath/ath10k/pci.c   2019-09-08 00:17:15.365912133 +0200
> > > @@ -2988,12 +2988,13 @@ static int ath10k_pci_probe(struct pci_d
> > >       struct ath10k_pci *ar_pci;
> > >       enum ath10k_hw_rev hw_rev;
> > >       u32 chip_id;
> > > -     bool pci_ps;
> > > +     bool pci_ps, is_qca988x = false;
> > >
> > >       switch (pci_dev->device) {
> > >       case QCA988X_2_0_DEVICE_ID:
> > >               hw_rev = ATH10K_HW_QCA988X;
> > >               pci_ps = false;
> > > +             is_qca988x = true;
> > >               break;
> > >       case QCA6164_2_1_DEVICE_ID:
> > >       case QCA6174_2_1_DEVICE_ID:
> > > @@ -3087,6 +3088,19 @@ static int ath10k_pci_probe(struct pci_d
> > >               goto err_deinit_irq;
> > >       }
> > >
> > > +     /* Read CHIP_ID before reset to catch QCA9880-AR1A v1 devices that
> > > +      * fall off the bus during chip_reset. These chips have the same pci
> > > +      * device id as the QCA9880 BR4A or 2R4E. So that's why the check.
> > > +      */
> > > +     if (is_qca988x) {
> > > +             chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
> > > +             if (chip_id != 0xffffffff) {
> > > +                     if (!ath10k_pci_chip_is_supported(pdev->device,
> > > +                                                       chip_id))
> > > +                             goto err_unsupported;
> > > +             }
> > > +     }
> > > +
> > >       ret = ath10k_pci_chip_reset(ar);
> > >       if (ret) {
> > >               ath10k_err(ar, "failed to reset chip: %d\n", ret);
> > > @@ -3099,11 +3113,8 @@ static int ath10k_pci_probe(struct pci_d
> > >               goto err_free_irq;
> > >       }
> > >
> > > -     if (!ath10k_pci_chip_is_supported(pdev->device, chip_id)) {
> > > -             ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
> > > -                        pdev->device, chip_id);
> > > -             goto err_free_irq;
> > > -     }
> > > +     if (!ath10k_pci_chip_is_supported(pdev->device, chip_id))
> > > +             goto err_unsupported;
> > >
> > >       ret = ath10k_core_register(ar, chip_id);
> > >       if (ret) {
> > > @@ -3113,6 +3124,10 @@ static int ath10k_pci_probe(struct pci_d
> > >
> > >       return 0;
> > >
> > > +err_unsupported:
> > > +     ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
> > > +                pdev->device, bus_params.chip_id);
> >
> > Backports are great, but as I mentioned before, this breaks the build,
> > so we can't take it:
> >
> > drivers/net/wireless/ath/ath10k/pci.c: In function ‘ath10k_pci_probe’:
> > drivers/net/wireless/ath/ath10k/pci.c:3129:20: error: ‘bus_params’ undeclared (first use in this function); did you mean ‘key_params’?
> >  3129 |      pdev->device, bus_params.chip_id);
> >       |                    ^~~~~~~~~~
> >       |                    key_params
> >
> Ok, I see. That "bus_params." there has to go so just "chip_id" remains.
> 
> But, I'm sorry that I caused this havoc.
> For a little bit of background: Getting the QCA9880-AR1A and the board
> it works back, will
> take until next year. Since this card either doesn't fit (it's
> oversized mini-pcie) or flat-out
> doesn't work (it crashes the vast majority of x86/AMD64 system during post).
> So doing tests with the hardware involves going through custom OpenWrt-builds.
> 
> > Please fix this up and resend backports again.
> I guess, I can do that. Question is, given the bug has been around
> since 2015 and the
> response for this patch has been negative (even from those who have
> crashes from it).
> I'm thinking that I'll rather drop this and take the time off by doing
> something else for
> a while.

That's fine, if someone has noticed this, then they just can use a new
kernel version.

thanks,

greg k-h
