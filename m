Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A17865E54
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 19:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfGKRRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 13:17:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42003 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbfGKRR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 13:17:28 -0400
Received: by mail-qk1-f196.google.com with SMTP id 201so4201788qkm.9
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 10:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C75eicHkBhF3H060oUVZiaMORLab85O9oP+plB/1SFE=;
        b=FcYe/LWCgLEzWB9nBCdGUxJEKcPFSeCpHDXSlel6FWEmF+Om+RIjyN0ZWXVZELg3cm
         ef6+U42m619KiZ+OunkBeVTM2PILcXRmSxzPMBIuTEc3cyEORTiZGy+s9f/+eyAleBpn
         U/OCw2arBS+ME+dBuqvFkgxUf98j6ukrEiiyk1WUFhFn9H7HwUM7RB9SBDUDgCD2gnwR
         B3z54IvZS2XfH436dVJD5FFQtq/JqfzkDLkPjXB63cM/iKuTuOfUjGhNXiqILUVaXka1
         kbSfbhaKtu8Gr3IHNWMP+1iHCvqqzz9JHhxYVKtO1Gar6g3IQCw5fIwIcGduvJ0L3nOI
         0L9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C75eicHkBhF3H060oUVZiaMORLab85O9oP+plB/1SFE=;
        b=W0ECGKkcL1YWZB1g7dQf/9x25Bv0q8HTPe6xbm11VpKAT6o272ir5gemAJwgnCqZSc
         z0uSX8dTE3C0vfxhATKurxtrsZtshaW27PWpoJjgz2k3eF590x0XZ6/HqoNWJesbDzJW
         MhJDRx5iKJ2t6v8h/aKF2WZsYHtwSntPb49ejOFrYVswV4NrKtcZLm+ftLKlmzVVmp0m
         FKvh+ynelX0v7gyUUqP5keNtHVhoYYRuJTVqr6upAjAoDXE0JNy39UmnU1KlNGbqEwzu
         KQtP8RY3SBTDR/WPMkNRDxQalWVRXDSCe0rl0wP4RZsuO4lliEykqn1VO67SdFaLi1bJ
         17lA==
X-Gm-Message-State: APjAAAU9BEFZ/V3K2QEkcdEyMTLv0UZZovF5vQPvi4rApmu9JDrpFWuX
        3VOw5MIUoKjBP9XXDVvlIUiYUg==
X-Google-Smtp-Source: APXvYqyVGKc+6eq2tBDktM5QPBnKGoI5P69B77SrqyEjdtGwmVj7ges8Ckocww5m9i+WPD8ws9aoLA==
X-Received: by 2002:ae9:eb87:: with SMTP id b129mr2639891qkg.453.1562865447396;
        Thu, 11 Jul 2019 10:17:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id g2sm2261334qkf.32.2019.07.11.10.17.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jul 2019 10:17:26 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hlchC-00086W-Aj; Thu, 11 Jul 2019 14:17:26 -0300
Date:   Thu, 11 Jul 2019 14:17:26 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Douglas Anderson <dianders@chromium.org>, stable@vger.kernel.org,
        groeck@chromium.org, sukhomlinov@google.com,
        jarkko.sakkinen@linux.intel.com, Arnd Bergmann <arnd@arndb.de>,
        Peter Huewe <peterhuewe@gmx.de>, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
 operations
Message-ID: <20190711171726.GE25807@ziepe.ca>
References: <20190711162919.23813-1-dianders@chromium.org>
 <20190711163915.GD25807@ziepe.ca>
 <20190711170437.GA7544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711170437.GA7544@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 07:04:37PM +0200, Greg KH wrote:
> On Thu, Jul 11, 2019 at 01:39:15PM -0300, Jason Gunthorpe wrote:
> > On Thu, Jul 11, 2019 at 09:29:19AM -0700, Douglas Anderson wrote:
> > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > 
> > > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream.
> > > 
> > > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > > future TPM operations. TPM 1.2 behavior was different, future TPM
> > > operations weren't disabled, causing rare issues. This patch ensures
> > > that future TPM operations are disabled.
> > > 
> > > Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > [dianders: resolved merge conflicts with mainline]
> > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > This is the backport of the patch referenced above to 4.19 as was done
> > > in Chrome OS.  See <https://crrev.com/c/1495114> for details.  It
> > > presumably applies to some older kernels.  NOTE that the problem
> > > itself has existed for a long time, but continuing to backport this
> > > exact solution to super old kernels is out of scope for me.  For those
> > > truly interested feel free to reference the past discussion [1].
> > > 
> > > Reason for backport: mainline has commit a3fbfae82b4c ("tpm: take TPM
> > > chip power gating out of tpm_transmit()") and commit 719b7d81f204
> > > ("tpm: introduce tpm_chip_start() and tpm_chip_stop()") and it didn't
> > > seem like a good idea to backport 17 patches to avoid the conflict.
> > 
> > Careful with this, you can't backport this to any kernels that don't
> > have the sysfs ops locking changes or they will crash in sysfs code.
> 
> And what commit added that?

commit 2677ca98ae377517930c183248221f69f771c921
Author: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Date:   Sun Nov 4 11:38:27 2018 +0200

    tpm: use tpm_try_get_ops() in tpm-sysfs.c.
    
    Use tpm_try_get_ops() in tpm-sysfs.c so that we can consider moving
    other decorations (locking, localities, power management for example)
    inside it. This direction can be of course taken only after other call
    sites for tpm_transmit() have been treated in the same way.

The last sentence suggests there are other patches needed too though..

Jason
