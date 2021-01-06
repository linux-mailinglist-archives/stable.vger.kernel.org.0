Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0835E2EBD21
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 12:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbhAFL0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 06:26:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbhAFL0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 06:26:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1815C22B37;
        Wed,  6 Jan 2021 11:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609932328;
        bh=dKDGsUfUFlfnuTfp1bAUM+cB+B1BsbaavEtFCZGIEy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L2eKcFBg22hLd9qDr4Scn+aHenc2YEWAQEeN4vOmQcP3xP2Th0tEjDgXi9EBSUUec
         NKj8FQ4YcSMKx4oTARcCGLTOUXQu2hxIj9FbzI+P/gO11bB4WjwUrlmbca3lvkRNko
         jHMMEbB85a/fO+K40wOvMAt7hV/kh2Vs/XSSRKrt9qnIpn8szs1xaMm7rKNR+2d+td
         A9GAV2BO/4OIFNkZi2hTxbNMpRhXMzGXl2I9AouxM4KXzzMgQUpdZnB5ZdPzgiTOmd
         bMTLcT9EhkTSUrsE9yzvBzD9jy9lvl0O3NgyDDsYNVy3hmf0gPTHfzuS0J0wVflYWx
         sE4JJfoK6FfFg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kx6wP-00076G-OS; Wed, 06 Jan 2021 12:25:25 +0100
Date:   Wed, 6 Jan 2021 12:25:25 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Pete Zaitcev <zaitcev@redhat.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: usblp: fix DMA to stack
Message-ID: <X/WeJfWKtFEebpMC@hovoldconsulting.com>
References: <20210104145302.2087-1-johan@kernel.org>
 <20210104113736.0af1ce0a@suzdal.zaitcev.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104113736.0af1ce0a@suzdal.zaitcev.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 11:37:36AM -0600, Pete Zaitcev wrote:
> On Mon,  4 Jan 2021 15:53:02 +0100
> Johan Hovold <johan@kernel.org> wrote:
> 
> > +++ b/drivers/usb/class/usblp.c
> > -#define usblp_hp_channel_change_request(usblp, channel, buffer) \
> > -	usblp_ctrl_msg(usblp, USBLP_REQ_HP_CHANNEL_CHANGE_REQUEST, USB_TYPE_VENDOR, USB_DIR_IN, USB_RECIP_INTERFACE, channel, buffer, 1)
> > +static int usblp_hp_channel_change_request(struct usblp *usblp, int channel, u8 *new_channel)
> 
> Acked-By: Pete Zaitcev <zaitcev@redhat.com>
> 
> I would probably get rid of the buffer pointer and return
> new_channel & 0xFF in case of success. That would kill
> the newChannel too, and there's no need to debage u8 versus
> unsigned char. But this is good enough. A function is better
> than trying to cram the kfree() into the clause of the switch.

Yeah, I wanted a minimal change suitable for stable and the helper was
already there to be used for this.

Johan
