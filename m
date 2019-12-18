Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2CE1257CD
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 00:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLRXbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 18:31:36 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39754 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfLRXbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 18:31:36 -0500
Received: by mail-oi1-f195.google.com with SMTP id a67so2129254oib.6
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 15:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fUytKbh3fxwQeY78Sh0bP3Ypu5vGalHc1spY/K/2hYw=;
        b=aADuHTHVDgDJIjYoRrFQtvCtQgjeTd6MHEuYXKaMBoChVpakmW017w1NLtNmg/nZ4l
         H5v1X8hB8CMByDOWpfXPWHofB+iJSW9nDapGGfjLokjZE5hOW31GOpyjEraT6a1DZeal
         W8GRIKnqG1PnBIys7m7zgJ0N6urSMEDsbWhgefJGgzaKP2bVaW181BgoAPKVD3VlNpRh
         V/S9GeauYsL1CSHx6ZScqAWAPCiRrRdVqfD8wGeoepbfxNi3EZSoK8QPz2hpkJEffPiC
         FMAz8yU4Zkloy5zq2XEwBj4Ht0LLW3Wc8GNqBQuwiFisiPGIeWod2EcIsTsENymsc+97
         NtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fUytKbh3fxwQeY78Sh0bP3Ypu5vGalHc1spY/K/2hYw=;
        b=swuGS4FYKYX4U1lVmckZ1vwv5F+hl62pUASmQaS0uhBAr2BDJ67ON04QRiytS0mHiP
         rV2p5j+99IjWRw3G3ijiQMjT6EYQ641KQhoaH1nWwFpnJF14lnTp/XoEGrPdZ5kg5mqs
         EGrLA8Bku8XIIoGSZQiMuMA08L7Dbkz3Vejbrh2DHaH1/2wrc07Z99qZT42ULUjdnnKw
         u6jQkeid76u+C0NnXt45MwbITDsAK2ZYSXEwIT5J8/4Hv2QqUFFq+pZTXC4e6zplmYr5
         rHsyI+sSvUys2Poky4ADPphFZX1PbVWqr/coz3qDxoF8FndQK4SgMmg457+ISSy1tmRl
         DyZQ==
X-Gm-Message-State: APjAAAW4NlvfzcImJVgQK6e2i8RFBbT8B+WqxZMpszYKlFvp9jhXI5b+
        jzEdAt7YU8qicjEqMijICA6CTT2kdbXwIbzL+Vz3i0o4QpM=
X-Google-Smtp-Source: APXvYqzEXrvpAjwiv2G/9Vv+SQnMlU3rni98xmIEIgWEgRhXsiBl5svGAoocWfD5bq9Vmw3xbgHM/CcuxdesXarEq8Q=
X-Received: by 2002:aca:4850:: with SMTP id v77mr1569292oia.70.1576711894829;
 Wed, 18 Dec 2019 15:31:34 -0800 (PST)
MIME-Version: 1.0
References: <20191211231758.22263-1-jsnitsel@redhat.com> <20191211235455.24424-1-jsnitsel@redhat.com>
 <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
 <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
 <20191217020022.knh7uxt4pn77wk5m@cantor> <CAPcyv4iepQup4bwMuWzq6r5gdx83hgYckUWFF7yF=rszjz3dtQ@mail.gmail.com>
 <5d0763334def7d7ae1e7cf931ef9b14184dce238.camel@linux.intel.com>
 <20191217171844.huqlj5csr262zkkk@cantor> <37f4ed0d6145dbe1e8724a5d05d0da82b593bf9c.camel@linux.intel.com>
In-Reply-To: <37f4ed0d6145dbe1e8724a5d05d0da82b593bf9c.camel@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 18 Dec 2019 15:31:23 -0800
Message-ID: <CAPcyv4h8sK+geVvBb1534V9CgdvOnkpPeStV3B8Q1Qdve3is0A@mail.gmail.com>
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of tpm_tis_core_init
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 3:07 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, 2019-12-17 at 10:18 -0700, Jerry Snitselaar wrote:
> > On Tue Dec 17 19, Jarkko Sakkinen wrote:
> > > On Mon, 2019-12-16 at 18:14 -0800, Dan Williams wrote:
> > > > On Mon, Dec 16, 2019 at 6:00 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
> > > > > On Mon Dec 16 19, Dan Williams wrote:
> > > > > > On Mon, Dec 16, 2019 at 4:59 PM Jarkko Sakkinen
> > > > > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > > > > On Wed, 2019-12-11 at 16:54 -0700, Jerry Snitselaar wrote:
> > > > > > > > Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
> > > > > > > > issuing commands to the tpm during initialization, just reserve the
> > > > > > > > chip after wait_startup, and release it when we are ready to call
> > > > > > > > tpm_chip_register.
> > > > > > > >
> > > > > > > > Cc: Christian Bundy <christianbundy@fraction.io>
> > > > > > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > > > > > Cc: Peter Huewe <peterhuewe@gmx.de>
> > > > > > > > Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > > > > > > Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > Cc: linux-integrity@vger.kernel.org
> > > > > > > > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> > > > > > > > Fixes: 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")
> > > > > > > > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > > > > > >
> > > > > > > I pushed to my master with minor tweaks and added my tags.
> > > > > > >
> > > > > > > Please check before I put it to linux-next.
> > > > > >
> > > > > > I don't see it yet here:
> > > > > >
> > > > > > http://git.infradead.org/users/jjs/linux-tpmdd.git/shortlog/refs/heads/master
> > > > > >
> > > > > > However, I wanted to make sure you captured that this does *not* fix
> > > > > > the interrupt issue. I.e. make sure you remove the "Fixes:
> > > > > > 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")"
> > > > > > tag.
> > > > > >
> > > > > > With that said, are you going to include the revert of:
> > > > > >
> > > > > > 1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
> > > > >
> > > > > Dan, with the above reverted do you still get the screaming interrupt?
> > > >
> > > > Yes, the screaming interrupt goes away, although it is replaced by
> > > > these messages when the driver starts:
> > > >
> > > > [    3.725131] tpm_tis IFX0740:00: 2.0 TPM (device-id 0x1B, rev-id 16)
> > > > [    3.725358] tpm tpm0: tpm_try_transmit: send(): error -5
> > > > [    3.725359] tpm tpm0: [Firmware Bug]: TPM interrupt not working,
> > > > polling instead
> > > >
> > > > If the choice is "error message + polled-mode" vs "pinning a cpu with
> > > > interrupts" I'd accept the former, but wanted Jarkko with his
> > > > maintainer hat to weigh in.
> > > >
> > > > Is there a simple sanity check I can run to see if the TPM is still
> > > > operational in this state?
> > >
> > > What about T490S?
> > >
> > > /Jarkko
> > >
> >
> > Hi Jarkko, I'm waiting to hear back from the t490s user, but I imagine
> > it still has the problem as well.
> >
> > Christian, were you able to try this patch and verify it still
> > resolves the issue you were having with the kernel failing to get the
> > timeouts and durations from the tpm?
>
> Including those reverts would be a bogus change at this point.

I'm failing to see how you arrived at that conclusion.

> The fix that I already applied obviously fixes an issue even if
> it does not fix all the issues.

These patches take a usable system and make it unusable:

1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
5b359c7c4372 tpm_tis_core: Turn on the TPM before probing IRQ's

...they need to be reverted, or the regression needs to be fixed, but
asserting that you fixed something else unrelated does not help.
