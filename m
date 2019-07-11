Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76ABA65E84
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 19:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfGKR2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 13:28:15 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46751 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGKR2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 13:28:15 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so14207994iol.13
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 10:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlOTOKurwzR/la0b/iCejRsNnafnIihAt0zVt5OFE78=;
        b=BaihPN4bmFQ12DBMpDILNYZZCzVbZNCbYwaQW9drSZFi/rNxK3SO3tOShcsqGOQmbW
         SnfGbaFZbEXJ8Ih/5JxO+dNJu7aqvSVUTy/ZUHoOwXj8K6/QjdZT0dzc9W1qMESvbIwf
         9vVQ+4PsFvbopH7FtMIVmop3gj6s2tpQSPjEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vlOTOKurwzR/la0b/iCejRsNnafnIihAt0zVt5OFE78=;
        b=U97OJ2OKDW0brkKK5YGzJD+zAw+hhoG1teUt8gu8cDEN+GvFOZqCATm9O7bzfxwzfU
         yAZVvP9IQqPySUiXXq6hjzM5sowmHqjNmQVYJ0Nr0AFw76aoPsbG3DS+ivE2hRq/BA7h
         16zqU7cKF+9nKCh/BbbYfZTUhfeMVbAjWYPNOablBQZFgTPxyBMS2I9rEKWAmYirBSvQ
         qe550y5LlmbYq8JfmoTbr7VHCC4mQE3AqS+s6YhRELUUn90nZBGWRpOJ91VKtZYu8iHL
         WsT0DwXCaDLMvC6IlZ3lVH/w/P/w38ceZT7KuZJtLlt2AH0rMwAkhZJuAgFzTy07Bgf3
         j+qg==
X-Gm-Message-State: APjAAAX2pSc41dG6b0wDylTp7YomFdo/tKH6UAn/MAUbtI76amLFk4oL
        1ujsE7fkPDLk9/85mB1kfO+JDlvcOrU=
X-Google-Smtp-Source: APXvYqwbgNgtVgsHKbv9uz5KTxJj/pzLy4f/mgDAwVj7ajvyDM8/PJBD4hXcl7aS8Ou/bCQloNWDSQ==
X-Received: by 2002:a5d:8a06:: with SMTP id w6mr5739867iod.267.1562866094450;
        Thu, 11 Jul 2019 10:28:14 -0700 (PDT)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com. [209.85.166.41])
        by smtp.gmail.com with ESMTPSA id s10sm16044058iod.46.2019.07.11.10.28.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 10:28:13 -0700 (PDT)
Received: by mail-io1-f41.google.com with SMTP id h6so14261294iom.7
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 10:28:13 -0700 (PDT)
X-Received: by 2002:a6b:5103:: with SMTP id f3mr1553212iob.142.1562866093394;
 Thu, 11 Jul 2019 10:28:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190711162919.23813-1-dianders@chromium.org> <20190711163915.GD25807@ziepe.ca>
 <20190711170437.GA7544@kroah.com> <20190711171726.GE25807@ziepe.ca> <20190711172630.GA11371@kroah.com>
In-Reply-To: <20190711172630.GA11371@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 11 Jul 2019 10:28:01 -0700
X-Gmail-Original-Message-ID: <CAD=FV=U0ue_4FyS7MO+iaKQ5gr0PhuLZaTV1adPY3ZtNhKTmHA@mail.gmail.com>
Message-ID: <CAD=FV=U0ue_4FyS7MO+iaKQ5gr0PhuLZaTV1adPY3ZtNhKTmHA@mail.gmail.com>
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

On Thu, Jul 11, 2019 at 10:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jul 11, 2019 at 02:17:26PM -0300, Jason Gunthorpe wrote:
> > On Thu, Jul 11, 2019 at 07:04:37PM +0200, Greg KH wrote:
> > > On Thu, Jul 11, 2019 at 01:39:15PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Jul 11, 2019 at 09:29:19AM -0700, Douglas Anderson wrote:
> > > > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > >
> > > > > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream.
> > > > >
> > > > > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > > > > future TPM operations. TPM 1.2 behavior was different, future TPM
> > > > > operations weren't disabled, causing rare issues. This patch ensures
> > > > > that future TPM operations are disabled.
> > > > >
> > > > > Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > > [dianders: resolved merge conflicts with mainline]
> > > > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > This is the backport of the patch referenced above to 4.19 as was done
> > > > > in Chrome OS.  See <https://crrev.com/c/1495114> for details.  It
> > > > > presumably applies to some older kernels.  NOTE that the problem
> > > > > itself has existed for a long time, but continuing to backport this
> > > > > exact solution to super old kernels is out of scope for me.  For those
> > > > > truly interested feel free to reference the past discussion [1].
> > > > >
> > > > > Reason for backport: mainline has commit a3fbfae82b4c ("tpm: take TPM
> > > > > chip power gating out of tpm_transmit()") and commit 719b7d81f204
> > > > > ("tpm: introduce tpm_chip_start() and tpm_chip_stop()") and it didn't
> > > > > seem like a good idea to backport 17 patches to avoid the conflict.
> > > >
> > > > Careful with this, you can't backport this to any kernels that don't
> > > > have the sysfs ops locking changes or they will crash in sysfs code.
> > >
> > > And what commit added that?
> >
> > commit 2677ca98ae377517930c183248221f69f771c921
> > Author: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Date:   Sun Nov 4 11:38:27 2018 +0200
> >
> >     tpm: use tpm_try_get_ops() in tpm-sysfs.c.
> >
> >     Use tpm_try_get_ops() in tpm-sysfs.c so that we can consider moving
> >     other decorations (locking, localities, power management for example)
> >     inside it. This direction can be of course taken only after other call
> >     sites for tpm_transmit() have been treated in the same way.
> >
> > The last sentence suggests there are other patches needed too though..
>
> So 5.1.  So does this original patch need to go into the 5.2 and 5.1
> kernels?

The patch ("Fix TPM 1.2 Shutdown sequence to prevent future TPM
operations")?  It's already done.  It just got merge conflicts when
going back to 4.19 which is why I sent the backport.

-Doug
