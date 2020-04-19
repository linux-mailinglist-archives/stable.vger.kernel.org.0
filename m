Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20151AF82B
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 09:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgDSHSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 03:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgDSHSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Apr 2020 03:18:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C6F21473;
        Sun, 19 Apr 2020 07:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587280728;
        bh=DR9LEZvTTJhuoWhKKe7yQkTo4M1R/evEF1B0NdROUnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xZ5mIA/cz9h70ZorxU2p0QC1tNgzaCnmdd9/icfBqR3qb8Cj/iJbENXgIHyi/1v/0
         QfEBOghSiMEB9UFIRXp57IZ2/FJGyhhE+S8bQ5DVJvo4E4gx6sy45FSHJyDi/riq11
         demcSQ3VB+VuOXbuDrBRC/o4KSfjdYw1l13KLTd4=
Date:   Sun, 19 Apr 2020 09:18:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Delio Brignoli <dbrignoli@audioscience.com>, stable@vger.kernel.org
Subject: Re: usb: dwc3: gadget: Don't clear flags before transfer ended
Message-ID: <20200419071844.GA3544495@kroah.com>
References: <C9599B63-1C11-4EBC-AFCC-3A4F14830767@audioscience.com>
 <20200418105325.GA2875820@kroah.com>
 <20200418163643.GC1809@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418163643.GC1809@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 18, 2020 at 12:36:43PM -0400, Sasha Levin wrote:
> On Sat, Apr 18, 2020 at 12:53:25PM +0200, Greg KH wrote:
> > On Sat, Apr 18, 2020 at 12:25:16PM +0200, Delio Brignoli wrote:
> > > Please apply the following commit:
> > > 
> > > Commit subject: usb: dwc3: gadget: Don't clear flags before transfer ended
> > > Commit ID: a114c4ca64bd522aec1790c7e5c60c882f699d8f
> > > Apply to: at least 4.19 stable, and 5.4 stable if possible. Note that all kernels from v4.18-rc1 up to 5.7-rc1 are affected.
> > > 
> > > Why apply it:
> > > <https://github.com/torvalds/linux/commit/a114c4ca64bd522aec1790c7e5c60c882f699d8f> fixes <https://github.com/torvalds/linux/commit/6d8a019614f3a7630e0a2c1be4bf1cfc23acf56e>. Without this fix the built-in USB function source/sink test module fails to work with isochronous endpoints [1]. A side-effect of setting dep->flags = DWC3_EP_ENABLED; in dwc3_gadget_ep_cleanup_completed_requests() as part of disabling an ep is that a subsequent attempt to enable the endpoint will skip __dwc3_gadget_ep_enable() effectively leaving the ep disabled.
> > > 
> > > [1] Our gadget driver on TI AM5729 fails to work exactly like the built-in USB function source/sink test module when switching to alternate interface 1 because of the issue described above.
> > > 
> > > TI is currently using 4.19 and 5.4 stable kernels as the basis for their processor SDK kernels for their AM57x SoC and may switch to 5.4 stable at a later time. Thank you.
> > 
> > It does not apply to the 4.19.y kernel tree, can you provide a working
> > backport of it please so that I can apply it?
> 
> I took this as a dependency:
> 
> 	c5353b225df9 ("usb: dwc3: gadget: don't enable interrupt when disabling endpoint")
> 
> And worked around context conflicts caused by:
> 
> 	25abad6a0584 ("usb: dwc3: gadget: return errors from __dwc3_gadget_start_isoc()")
> 	d92021f66063 ("usb: dwc3: Add workaround for isoc start transfer failure")
> 
> And queued a114c4ca64bd for 4.19.

Thanks for doing this!
