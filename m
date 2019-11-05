Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF83F0325
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 17:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390156AbfKEQiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 11:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390060AbfKEQiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 11:38:12 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77D1121882;
        Tue,  5 Nov 2019 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572971892;
        bh=FsuIW2q/xmpl397EpGtrbS7IJKE334NMMAWrozxk8es=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8/yvp4hsE3rcUEh5Oj64OJlncnVrOoHSVNmAS0hVnKpojN2W7HLvmebkISFOpF0Y
         8jlcspFFdwUWoYR8Baer1L8g/PjtzByhZVa3r78E81vXBU6t8Z0lE//k7aUw4d3nRC
         iAIaCN+qKwkd/rCNDlsSgjciFRgjkzUYDBsDGtU4=
Date:   Tue, 5 Nov 2019 17:38:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.19 114/149] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
Message-ID: <20191105163805.GB2760793@kroah.com>
References: <Pine.LNX.4.44L0.1911051007140.1678-100000@iolanthe.rowland.org>
 <1572968467.2921.27.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572968467.2921.27.camel@suse.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 04:41:07PM +0100, Oliver Neukum wrote:
> Am Dienstag, den 05.11.2019, 10:09 -0500 schrieb Alan Stern:
> > On Tue, 5 Nov 2019, Oliver Neukum wrote:
> > 
> > > Am Montag, den 04.11.2019, 22:45 +0100 schrieb Greg Kroah-Hartman:
> > > >         Since commit ea44d190764b ("usbip: Implement SG support to
> > > >         vhci-hcd and stub driver") was merged, the USB/IP driver can
> > > >         also handle SG.
> > > 
> > > Hi,
> > > 
> > > same story as 4.4.x
> > 
> > I'm not sure about uas, but it was reported just yesterday that the 
> > corresponding commit for usb-storage caused a 30% speed degradation:
> > 
> > 	https://marc.info/?l=linux-usb&m=157293660212040&w=2
> > 
> > Given this information, perhaps you will decide that the revert is 
> > worthwhile.
> 
> Damned if I do, damned if I do not.
> Check for usbip and special case it?

We should be able to do that in the host controller driver for usbip,
right?  What is the symptom if you use a UAS device with usbip and this
commit?

thanks,

greg k-h
