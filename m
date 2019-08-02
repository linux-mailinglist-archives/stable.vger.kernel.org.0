Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289267EDB5
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 09:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389683AbfHBHk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 03:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732277AbfHBHk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 03:40:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0212086A;
        Fri,  2 Aug 2019 07:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564731655;
        bh=WdW+h+XGuGqjKwJ5w5plqYCPLFR0EQgahxkRPqpuyZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H3r9ZsyblPP9d/UZ24Yu885Myc5WLnctX0R5hAz3sA4P2qsYWNaLqtNNDvL7rE/cX
         SlD0BLzdzuDTPKncegj4CagRPWVSdfRKwIT95NaaqCu4gk5ahbYghF9vzCrh47n3aD
         EIVAeCNF4jloZPOWQMsi9AJpG8pR/gbNRYUudNWs=
Date:   Fri, 2 Aug 2019 09:40:53 +0200
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
Message-ID: <20190802074053.GE26174@kroah.com>
References: <20190214150745.18773-1-Eugeniy.Paltsev@synopsys.com>
 <20190214150745.18773-3-Eugeniy.Paltsev@synopsys.com>
 <CY4PR1201MB0120530B12273DDC5B06D823A1C80@CY4PR1201MB0120.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1201MB0120530B12273DDC5B06D823A1C80@CY4PR1201MB0120.namprd12.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 08:51:23PM +0000, Alexey Brodkin wrote:
> Hi Greg,
> 
> > -----Original Message-----
> > From: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
> > Sent: Thursday, February 14, 2019 6:08 PM
> > To: linux-snps-arc@lists.infradead.org; Vineet Gupta <vgupta@synopsys.com>
> > Cc: linux-kernel@vger.kernel.org; Alexey Brodkin <abrodkin@synopsys.com>; Corentin Labbe
> > <clabbe@baylibre.com>; khilman@baylibre.com; Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
> > Subject: [PATCH v2 2/2] ARC: enable uboot support unconditionally
> > 
> > After reworking U-boot args handling code and adding paranoid
> > arguments check we can eliminate CONFIG_ARC_UBOOT_SUPPORT and
> > enable uboot support unconditionally.
> > 
> > For JTAG case we can assume that core registers will come up
> > reset value of 0 or in worst case we rely on user passing
> > '-on=clear_regs' to Metaware debugger.
> > 
> > Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
> 
> May we have this one back-ported to linux-4.19.y?
> 
> It was initially applied to Linus' tree during 5.0 development
> cycle [1] but was never back-ported.
> 
> Now w/o that patch in KernelCI we see boot failure on ARC HSDK
> board [2] as opposed to normally working later kernel versions.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=493a2f812446e92bcb1e69a77381b4d39808d730
> [2] https://storage.kernelci.org/stable/linux-4.19.y/v4.19.59/arc/hsdk_defconfig/gcc-8/lab-baylibre/boot-hsdk.txt
> 
> Below is that same patch but rebased on linux-4.19 as in its pristine
> form it won't apply due to offset of one of hunks.

Why is this patch ok for stable kernel trees?  Are you not removing
existing support in 4.19 for a feature that people might be using there?
What bug is this fixing that requires this removal?

thanks,

greg k-h
