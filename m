Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C324817FC
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 13:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfHELRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 07:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbfHELRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 07:17:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A3620856;
        Mon,  5 Aug 2019 11:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565003825;
        bh=JCiN2ISR81s+2Lx+2tbYurR9+DzYblAfJLh6BdGkxrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UGNAi4134dElHNtXnff3/vxvYhB9pmlQfEHL460cRQmeChXMUX01Xa6fKwMNcymHM
         5w1ncMys94VH6IBbL9L91uAZoIyjS1UFmoJQzpHP8q9jbvZYMjUjQ1srFeB7PMCEiQ
         xNoh6h815xI/PVEljHzHiIbAzigwaQR2uVgCy0go=
Date:   Mon, 5 Aug 2019 13:17:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc:     linux-stable <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 2/2] ARC: enable uboot support unconditionally
Message-ID: <20190805111702.GA8189@kroah.com>
References: <20190214150745.18773-1-Eugeniy.Paltsev@synopsys.com>
 <20190214150745.18773-3-Eugeniy.Paltsev@synopsys.com>
 <CY4PR1201MB0120530B12273DDC5B06D823A1C80@CY4PR1201MB0120.namprd12.prod.outlook.com>
 <20190802074053.GE26174@kroah.com>
 <CY4PR1201MB01209C2D14AEE1A81164FE99A1D90@CY4PR1201MB0120.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1201MB01209C2D14AEE1A81164FE99A1D90@CY4PR1201MB0120.namprd12.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 04:25:39PM +0000, Alexey Brodkin wrote:
> Hi Greg,
> 
> > > May we have this one back-ported to linux-4.19.y?
> > >
> > > It was initially applied to Linus' tree during 5.0 development
> > > cycle [1] but was never back-ported.
> > >
> > > Now w/o that patch in KernelCI we see boot failure on ARC HSDK
> > > board [2] as opposed to normally working later kernel versions.
> > >
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=493a2f812446e92bcb1e69a77381b4d39808d730
> > > [2] https://storage.kernelci.org/stable/linux-4.19.y/v4.19.59/arc/hsdk_defconfig/gcc-8/lab-baylibre/boot-hsdk.txt
> > >
> > > Below is that same patch but rebased on linux-4.19 as in its pristine
> > > form it won't apply due to offset of one of hunks.
> > 
> > Why is this patch ok for stable kernel trees?  Are you not removing
> > existing support in 4.19 for a feature that people might be using there?
> > What bug is this fixing that requires this removal?
> 
> This patch removes a Kconfig option in a trade for properly working
> detection of arguments passed from U-Boot.
> 
> Back in the day [3] we had to add that option to get kernel reliably working
> in use-cases w/o U-Boot (those were typically loading kernel image via JTAG).
> But with a couple of fixes applied to linux-4.19.y already we no longer need
> that explicit toggle as we may rely on data passed via dedicated registers
> and thus automatically know if there was U-Boot which passed some info to
> the kernel or there was no U-Boot and we don't need to mess with garbage in
> those registers.
> 
> Main reason is to make vanilla 4.19.y kernels usable on HSDK board in KernelCI
> environment. Now they don't boot, see [2] as in HSDK's defconfig ARC_UBOOT_SUPPORT
> is not set. So we have 2 solutions:
> 
> 1. Add ARC_UBOOT_SUPPORT to arch/arc/configs/hsdk_defconfig
>    But we cannot do it for vanilla kernel because we simply cannot even submit that
>    change to the Linus' tree as that Kconfig option was removed.
>    Which means we cannot back-port it, right :)
> 
> 2. Back-port proposed patch which already exists in the Linus'tree and thus is
>    perfectly back-portable.
> 
> Makes sense?

Ok, it's your arch, you get to deal with the angry users if you have any
:)

now queued up.

greg k-h
