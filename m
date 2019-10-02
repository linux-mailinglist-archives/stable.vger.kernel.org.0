Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F015C8DE9
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 18:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfJBQJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 12:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfJBQJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 12:09:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2640F21D81;
        Wed,  2 Oct 2019 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570032596;
        bh=qqbcqGXc5C/kil7EDQLVNG0WxVmn4bKkQ5z1qtVBH2Q=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=I6Tr4280cvka5hVIZcRHW0xfbBZqsZG1Qv4fWPzJErLIMSTdtN3sg09PYTobRNTpJ
         uG6Ux1/2OcAQhPgBjPo13j/m+qtZuksaJp3rF9M61F61UV7lLU5vAWPlIpDyH463+L
         X2AihfONiDEc+WCDM+0WeEW51joqoGyaHdZ39OJY=
Date:   Wed, 2 Oct 2019 18:09:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-stabley@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "open list:TPM DEVICE DRIVER" <linux-integrity@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tpm: Fix TPM 1.2 Shutdown sequence to prevent future
 TPM operations
Message-ID: <20191002160954.GA1754224@kroah.com>
References: <20191002131445.7793-1-jarkko.sakkinen@linux.intel.com>
 <20191002131445.7793-4-jarkko.sakkinen@linux.intel.com>
 <20191002135758.GA1738718@kroah.com>
 <20191002151751.GP17454@sasha-vm>
 <20191002153123.wcguist4okoxckis@cantor>
 <20191002154204.me4lzgx2l4r6zkpy@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002154204.me4lzgx2l4r6zkpy@cantor>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 08:42:04AM -0700, Jerry Snitselaar wrote:
> On Wed Oct 02 19, Jerry Snitselaar wrote:
> > On Wed Oct 02 19, Sasha Levin wrote:
> > > On Wed, Oct 02, 2019 at 03:57:58PM +0200, Greg KH wrote:
> > > > On Wed, Oct 02, 2019 at 04:14:44PM +0300, Jarkko Sakkinen wrote:
> > > > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > > 
> > > > > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
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
> > > > > ---
> > > > > drivers/char/tpm/tpm-chip.c | 5 +++--
> > > > > 1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > What kernel version(s) is this for?
> > > 
> > > It would go to 4.19, we've recently reverted an incorrect backport of
> > > this patch.
> > > 
> > > Jarkko, why is this patch 3/3? We haven't seen the first two on the
> > > mailing list, do we need anything besides this patch?
> > > 
> > > --
> > > Thanks,
> > > Sasha
> > 
> > It looks like there was a problem mailing the earlier patchset, and patches 1 and 2
> > weren't cc'd to stable, but patch 3 was.
> 
> Is linux-stabley@vger.kernel.org a valid address?
> 

Heh, no :)
