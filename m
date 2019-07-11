Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBAA65E21
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 19:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfGKREl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 13:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbfGKREl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 13:04:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A67932084B;
        Thu, 11 Jul 2019 17:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562864680;
        bh=ZtQbjTKSuG5miBFoKtVBUh9w0F5SVtSPWCsiPg1i9Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GeFU5ITLxBKdmriot8FGzOsfEBIvdDqkmvEqLn63s1pW2FnpQGlQ0qEnhSPcurbc7
         cFUwxVR8BFQ+AQBjr3ZTITnWKw3bNnoWsZ2xJUxOsmg//p7SOder5U6hq7WC2D6zlU
         IIPMtd5MzVGC+UPI+46EJrH/6armNOEcFbsj84v0=
Date:   Thu, 11 Jul 2019 19:04:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Douglas Anderson <dianders@chromium.org>, stable@vger.kernel.org,
        groeck@chromium.org, sukhomlinov@google.com,
        jarkko.sakkinen@linux.intel.com, Arnd Bergmann <arnd@arndb.de>,
        Peter Huewe <peterhuewe@gmx.de>, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
 operations
Message-ID: <20190711170437.GA7544@kroah.com>
References: <20190711162919.23813-1-dianders@chromium.org>
 <20190711163915.GD25807@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711163915.GD25807@ziepe.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 01:39:15PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 11, 2019 at 09:29:19AM -0700, Douglas Anderson wrote:
> > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > 
> > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream.
> > 
> > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > future TPM operations. TPM 1.2 behavior was different, future TPM
> > operations weren't disabled, causing rare issues. This patch ensures
> > that future TPM operations are disabled.
> > 
> > Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> > [dianders: resolved merge conflicts with mainline]
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > This is the backport of the patch referenced above to 4.19 as was done
> > in Chrome OS.  See <https://crrev.com/c/1495114> for details.  It
> > presumably applies to some older kernels.  NOTE that the problem
> > itself has existed for a long time, but continuing to backport this
> > exact solution to super old kernels is out of scope for me.  For those
> > truly interested feel free to reference the past discussion [1].
> > 
> > Reason for backport: mainline has commit a3fbfae82b4c ("tpm: take TPM
> > chip power gating out of tpm_transmit()") and commit 719b7d81f204
> > ("tpm: introduce tpm_chip_start() and tpm_chip_stop()") and it didn't
> > seem like a good idea to backport 17 patches to avoid the conflict.
> 
> Careful with this, you can't backport this to any kernels that don't
> have the sysfs ops locking changes or they will crash in sysfs code.

And what commit added that?

thanks,

greg k-h
