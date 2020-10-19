Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87A72922D2
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 09:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgJSHMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 03:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgJSHMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 03:12:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9245F2080D;
        Mon, 19 Oct 2020 07:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603091549;
        bh=5KWfa7sJYcWcm6dkg2aYHmuXbbgdGpIrlFETSjV9xXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hDSlXXt3EdItHz+5KX4HMmeskgYWe80eeGRlu/Gt5LW0eVRCeAgR+nIe9leVjsKmp
         HD/bqqR/mnVPW/6CBxA9oZwnyFR4NYEXRvNA6/SN94e0dbLorEvvSPzFLjgXbUCmSy
         xzUqcXqG9R9m8s3IF4dtfC5oKvo5QKYFH8N5MX9U=
Date:   Mon, 19 Oct 2020 09:13:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 054/111] USB: cdc-acm: handle broken union
 descriptors
Message-ID: <20201019071314.GA3219053@kroah.com>
References: <20201018191807.4052726-1-sashal@kernel.org>
 <20201018191807.4052726-54-sashal@kernel.org>
 <20201019070218.GO26280@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019070218.GO26280@localhost>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 19, 2020 at 09:02:18AM +0200, Johan Hovold wrote:
> On Sun, Oct 18, 2020 at 03:17:10PM -0400, Sasha Levin wrote:
> > From: Johan Hovold <johan@kernel.org>
> > 
> > [ Upstream commit 960c7339de27c6d6fec13b54880501c3576bb08d ]
> > 
> > Handle broken union functional descriptors where the master-interface
> > doesn't exist or where its class is of neither Communication or Data
> > type (as required by the specification) by falling back to
> > "combined-interface" probing.
> > 
> > Note that this still allows for handling union descriptors with switched
> > interfaces.
> > 
> > This specifically makes the Whistler radio scanners TRX series devices
> > work with the driver without adding further quirks to the device-id
> > table.
> > 
> > Reported-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> > Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> > Acked-by: Oliver Neukum <oneukum@suse.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Link: https://lore.kernel.org/r/20200921135951.24045-3-johan@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I was surprised to see this picked up by AUTOSEL since I remember adding
> a stable tag to this patch (to v2, changed my mind since v1) -- and it's
> there in the lore link above.
> 
> Greg, just to make sure this wasn't due to a b4 bug; did you drop the
> stable tag on purpose when applying?

I did not, looks like b4 stripped it off!

> The tag-order has been reshuffled by b4 too it seems (I know, some
> people think that's ok) so maybe it fell out in the process.

I think so, let me verify it's a bug and report it to Konstantin...

thanks,

greg k-h
