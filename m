Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BEEF14CA
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 12:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfKFLRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 06:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfKFLRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 06:17:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B192067B;
        Wed,  6 Nov 2019 11:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573039028;
        bh=MofkAeh32ygz8kQiJ/NW8nxCM7dhfQeKB7/bbaa70aU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ns9bAC0NqPB9Y8HYDug8Evp+nR+wHYk3/sqAjAcgF9twD05PXqHjgA7LBc6r7yiEa
         SFCzyhXELwHDKfwXqsCuv4Pr8PdDIWLg23rSncp1FMWKdvzJLkrYtnJbD54ae9/woL
         D4AinOxxBdoy3rg7i7xRze7VjeSoujc7MhNEd64U=
Date:   Wed, 6 Nov 2019 12:17:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.9 37/62] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
Message-ID: <20191106111706.GA3033188@kroah.com>
References: <20191104211901.387893698@linuxfoundation.org>
 <20191104211940.713506931@linuxfoundation.org>
 <1572964268.2921.19.camel@suse.com>
 <20191106001102.GI4787@sasha-vm>
 <1573026302.3090.2.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573026302.3090.2.camel@suse.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 08:45:02AM +0100, Oliver Neukum wrote:
> Am Dienstag, den 05.11.2019, 19:11 -0500 schrieb Sasha Levin:
> > On Tue, Nov 05, 2019 at 03:31:08PM +0100, Oliver Neukum wrote:
> > > Am Montag, den 04.11.2019, 22:44 +0100 schrieb Greg Kroah-Hartman:
> > > >         All the host controllers capable of SuperSpeed operation can
> > > >         handle fully general SG;
> > > > 
> > > >         Since commit ea44d190764b ("usbip: Implement SG support to
> > > >         vhci-hcd and stub driver") was merged, the USB/IP driver can
> > > >         also handle SG.
> > > 
> > > Not in 4.9.x. AFAICT the same story as 4.4.x
> > > The patch is not strictly needed, but breaks UAS over usbip.
> > 
> > It's in 4.9 since April this year... Same story for 4.4.
> 
> Hi,
> 
> now I am confused. Neither looking at the logs nor the source
> I can see the commit. Top commit is
> 9e48f0c28dd505e39bd136ec92a042b311b127c6
> of git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> 
> I am sorry for being obnoxious here and it is entirely possible that
> I am stupid, but this is a discrepancy that needs to be resolved.

Commit 3ae62a42090f ("UAS: fix alignment of scatter/gather segments") is
the patch that is being reverted here, and it is in the following kernel
releases:
	4.4.180 4.9.175 4.14.118 4.19.42 5.0.15 5.1.1 5.2
And it is causing known issues, so we should revert it.

Now if usbip breaks with this revert, we should add the newer patch that
keeps it working properly, is that what you are thinking that
ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
is?

thanks,

greg k-h
