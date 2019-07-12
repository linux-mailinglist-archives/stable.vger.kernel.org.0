Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C55671D3
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 17:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfGLPAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 11:00:32 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43868 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfGLPAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 11:00:31 -0400
Received: by mail-io1-f68.google.com with SMTP id k20so20913951ios.10
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 08:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ruDKR2WCuNJ8pZ4dZ78285EBDLCUM687NPIbMme+Zc=;
        b=oYcAIdwNFzlN2wVuvt4l+koisE4DeidlMfdlUNIyLbc/G4iBkqJBanjSAwLfSFD/GL
         Psdgp+cPejucuLGKOa2ErG7h7GEWhcbrfwfJkXKYWAbM326VgNJdG8dklOSllUnmvpcG
         z640kegEODmBmSpJhSioeTrZ3V93kR8fijaKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ruDKR2WCuNJ8pZ4dZ78285EBDLCUM687NPIbMme+Zc=;
        b=r7hAw1Ia63AgDl3sqsG635WEqCRZAFcIeChm730G0Ajhp5VuuBf5B5ykBXqamgHFve
         tcPzxCUWuqotuH0Y13RUGIw6pd+1xPk7IE8lqHWEi8UkNLEE7TE4993gbe4u4Iq2OrO4
         zvz1MFdlTf4QEOUXsZXAgJzkoMiJmgLFKMcVWQ+u6acDN7JrJYPP4mQBZwM6x07Hv2I5
         C54YLuQO6yaj+i2IUNU5EbhxImGo0xJhJ61vuV0LzP/bIEvtgJQ53U67lGqizUL/dZQ1
         idRc4A7j8eemAa+Slr+eD+v0ugKfqFVuR/upkw4aW/xhNjSe0cN/eWuenLDCV1XZR4aB
         Sx0w==
X-Gm-Message-State: APjAAAXbjsgWvB9S1motijIMJCIHlo9y+bkj1ezaqgey9+waN5asUf3T
        I5xCfdl6vT4yz8kjzdgUED6J3bMfXCU=
X-Google-Smtp-Source: APXvYqxWTFye7CYbHoIYjHNwaKAOGHlmamRddNg6eOaYGQVVkiFokWfnNrGwLLoupkcL+PYc59/9sw==
X-Received: by 2002:a6b:ea0f:: with SMTP id m15mr11661928ioc.300.1562943630343;
        Fri, 12 Jul 2019 08:00:30 -0700 (PDT)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com. [209.85.166.46])
        by smtp.gmail.com with ESMTPSA id r5sm7823296iom.42.2019.07.12.08.00.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 08:00:28 -0700 (PDT)
Received: by mail-io1-f46.google.com with SMTP id j5so16742279ioj.8
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 08:00:28 -0700 (PDT)
X-Received: by 2002:a02:c6a9:: with SMTP id o9mr12337396jan.90.1562943627679;
 Fri, 12 Jul 2019 08:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190711162919.23813-1-dianders@chromium.org> <20190711163915.GD25807@ziepe.ca>
 <20190711170437.GA7544@kroah.com> <20190711171726.GE25807@ziepe.ca>
 <20190711172630.GA11371@kroah.com> <CAD=FV=U0ue_4FyS7MO+iaKQ5gr0PhuLZaTV1adPY3ZtNhKTmHA@mail.gmail.com>
 <20190712115025.GA8221@kroah.com>
In-Reply-To: <20190712115025.GA8221@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 12 Jul 2019 08:00:12 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UBOWHrEFQRhxsnK-PmVkFjcvnEruuy0sYHh0p-Qnk8pA@mail.gmail.com>
Message-ID: <CAD=FV=UBOWHrEFQRhxsnK-PmVkFjcvnEruuy0sYHh0p-Qnk8pA@mail.gmail.com>
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, "# 4.0+" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Huewe <peterhuewe@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Jul 12, 2019 at 4:50 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jul 11, 2019 at 10:28:01AM -0700, Doug Anderson wrote:
> > Hi,
> >
> > On Thu, Jul 11, 2019 at 10:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Jul 11, 2019 at 02:17:26PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Jul 11, 2019 at 07:04:37PM +0200, Greg KH wrote:
> > > > > On Thu, Jul 11, 2019 at 01:39:15PM -0300, Jason Gunthorpe wrote:
> > > > > > On Thu, Jul 11, 2019 at 09:29:19AM -0700, Douglas Anderson wrote:
> > > > > > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > > > >
> > > > > > > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream.
> > > > > > >
> > > > > > > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > > > > > > future TPM operations. TPM 1.2 behavior was different, future TPM
> > > > > > > operations weren't disabled, causing rare issues. This patch ensures
> > > > > > > that future TPM operations are disabled.
> > > > > > >
> > > > > > > Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > > > > [dianders: resolved merge conflicts with mainline]
> > > > > > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > > > > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > > > This is the backport of the patch referenced above to 4.19 as was done
> > > > > > > in Chrome OS.  See <https://crrev.com/c/1495114> for details.  It
> > > > > > > presumably applies to some older kernels.  NOTE that the problem
> > > > > > > itself has existed for a long time, but continuing to backport this
> > > > > > > exact solution to super old kernels is out of scope for me.  For those
> > > > > > > truly interested feel free to reference the past discussion [1].
> > > > > > >
> > > > > > > Reason for backport: mainline has commit a3fbfae82b4c ("tpm: take TPM
> > > > > > > chip power gating out of tpm_transmit()") and commit 719b7d81f204
> > > > > > > ("tpm: introduce tpm_chip_start() and tpm_chip_stop()") and it didn't
> > > > > > > seem like a good idea to backport 17 patches to avoid the conflict.
> > > > > >
> > > > > > Careful with this, you can't backport this to any kernels that don't
> > > > > > have the sysfs ops locking changes or they will crash in sysfs code.
> > > > >
> > > > > And what commit added that?
> > > >
> > > > commit 2677ca98ae377517930c183248221f69f771c921
> > > > Author: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > Date:   Sun Nov 4 11:38:27 2018 +0200
> > > >
> > > >     tpm: use tpm_try_get_ops() in tpm-sysfs.c.
> > > >
> > > >     Use tpm_try_get_ops() in tpm-sysfs.c so that we can consider moving
> > > >     other decorations (locking, localities, power management for example)
> > > >     inside it. This direction can be of course taken only after other call
> > > >     sites for tpm_transmit() have been treated in the same way.
> > > >
> > > > The last sentence suggests there are other patches needed too though..
> > >
> > > So 5.1.  So does this original patch need to go into the 5.2 and 5.1
> > > kernels?
> >
> > The patch ("Fix TPM 1.2 Shutdown sequence to prevent future TPM
> > operations")?  It's already done.  It just got merge conflicts when
> > going back to 4.19 which is why I sent the backport.
>
> But the sysfs comment means I should not apply this backport then?
>
> Totally confused by this long thread, sorry.
>
> What am I supposed to do for the stable trees here?

I think the answer is to drop my backport for now and Jarkko says
he'll take a fresh look at it in 2 weeks when he's back from his
leave.  Thus my understanding:

* On mainline: fixed

* On 5.2 / 5.1: you've already got this picked to stable.  Good

* On 4.14 / 4.19: Jarkko will look at in 2 weeks.

* On 4.9 and older: I'd propose skipping unless someone is known to
need a solution here.

-Doug
