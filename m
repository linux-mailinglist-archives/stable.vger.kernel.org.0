Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3766BCB
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 13:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfGLLua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 07:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbfGLLu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 07:50:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E36262083B;
        Fri, 12 Jul 2019 11:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562932228;
        bh=42baEJPVtM089DTZJ3nIWptGajt2KFGbKS6aBI9md/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CF5H+JtZg/HMdb7xrrmep3HWhTu9gUnCjrOoP1iq5Jw3QKSBNzRHSPiBXDbkdyoHK
         U03FtLANPvVynLKYd65w2sjvQUzb/d5o9n8YMa//jStkmHHAa4aF6AF+wXpxN1te9p
         PoagLFR1XRISzvyW52Zb5z3pZiJJTfM/OVmgWHeI=
Date:   Fri, 12 Jul 2019 13:50:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, "# 4.0+" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Huewe <peterhuewe@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
 operations
Message-ID: <20190712115025.GA8221@kroah.com>
References: <20190711162919.23813-1-dianders@chromium.org>
 <20190711163915.GD25807@ziepe.ca>
 <20190711170437.GA7544@kroah.com>
 <20190711171726.GE25807@ziepe.ca>
 <20190711172630.GA11371@kroah.com>
 <CAD=FV=U0ue_4FyS7MO+iaKQ5gr0PhuLZaTV1adPY3ZtNhKTmHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=U0ue_4FyS7MO+iaKQ5gr0PhuLZaTV1adPY3ZtNhKTmHA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 10:28:01AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Thu, Jul 11, 2019 at 10:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jul 11, 2019 at 02:17:26PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Jul 11, 2019 at 07:04:37PM +0200, Greg KH wrote:
> > > > On Thu, Jul 11, 2019 at 01:39:15PM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Jul 11, 2019 at 09:29:19AM -0700, Douglas Anderson wrote:
> > > > > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > > >
> > > > > > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream.
> > > > > >
> > > > > > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > > > > > future TPM operations. TPM 1.2 behavior was different, future TPM
> > > > > > operations weren't disabled, causing rare issues. This patch ensures
> > > > > > that future TPM operations are disabled.
> > > > > >
> > > > > > Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > > > [dianders: resolved merge conflicts with mainline]
> > > > > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > > > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > > This is the backport of the patch referenced above to 4.19 as was done
> > > > > > in Chrome OS.  See <https://crrev.com/c/1495114> for details.  It
> > > > > > presumably applies to some older kernels.  NOTE that the problem
> > > > > > itself has existed for a long time, but continuing to backport this
> > > > > > exact solution to super old kernels is out of scope for me.  For those
> > > > > > truly interested feel free to reference the past discussion [1].
> > > > > >
> > > > > > Reason for backport: mainline has commit a3fbfae82b4c ("tpm: take TPM
> > > > > > chip power gating out of tpm_transmit()") and commit 719b7d81f204
> > > > > > ("tpm: introduce tpm_chip_start() and tpm_chip_stop()") and it didn't
> > > > > > seem like a good idea to backport 17 patches to avoid the conflict.
> > > > >
> > > > > Careful with this, you can't backport this to any kernels that don't
> > > > > have the sysfs ops locking changes or they will crash in sysfs code.
> > > >
> > > > And what commit added that?
> > >
> > > commit 2677ca98ae377517930c183248221f69f771c921
> > > Author: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > Date:   Sun Nov 4 11:38:27 2018 +0200
> > >
> > >     tpm: use tpm_try_get_ops() in tpm-sysfs.c.
> > >
> > >     Use tpm_try_get_ops() in tpm-sysfs.c so that we can consider moving
> > >     other decorations (locking, localities, power management for example)
> > >     inside it. This direction can be of course taken only after other call
> > >     sites for tpm_transmit() have been treated in the same way.
> > >
> > > The last sentence suggests there are other patches needed too though..
> >
> > So 5.1.  So does this original patch need to go into the 5.2 and 5.1
> > kernels?
> 
> The patch ("Fix TPM 1.2 Shutdown sequence to prevent future TPM
> operations")?  It's already done.  It just got merge conflicts when
> going back to 4.19 which is why I sent the backport.

But the sysfs comment means I should not apply this backport then?

Totally confused by this long thread, sorry.

What am I supposed to do for the stable trees here?

thanks,

greg k-h
