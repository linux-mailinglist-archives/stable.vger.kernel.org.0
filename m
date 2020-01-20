Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BE41424CA
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 09:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgATIIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 03:08:31 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46938 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgATIIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 03:08:30 -0500
Received: by mail-lf1-f67.google.com with SMTP id z26so2632638lfg.13
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 00:08:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nSMNZ3YPbhKQynDbO5dPRDdqXKJW3Q83ZxIhNwBp39c=;
        b=U8wyq6NTRcl9Ifh7a4i7bmIfbS5dT9BvWgftyf6Jkq/atXUWPYvlCPi7Op5jgpIZRa
         8nCqosMoiDX9IGezMOio0+kUpA6wLZUqtN/Zu+HFWeGGPIM6/q6YsSFb7TK1J9K/2p/Q
         mGfaaf3HBvt8FjYj09BUFrctG93r17FejrtGY91rks9tVF8ffEYTc1x8itNTAtK0EPXy
         otSRCPie46xSliOId1/5HpA1WMY7nRBpWX2rZUHpb25fMK7RLg9mc3bPuEKTvaCN4x6U
         3u4UwCWZur3JTZvbxwPGQ6gQPDjO5aIXElskDvhXQUccwye1IlCiaZoQSuns1GeqbdJ0
         ml+g==
X-Gm-Message-State: APjAAAWrj/TnzETwpkN9T4r1WeRpGEehvRSgidi8xtJi4ICpLS1pHVj4
        VepOdY+LgtqVHSFB4t86A8xi8dsR
X-Google-Smtp-Source: APXvYqzZRUQ98rixIS7XITnL9NpIZTPx4dV10on/rBtXkJnMVDAUnevXQuqwj5HVEP4YEMSfjOgzgw==
X-Received: by 2002:ac2:5a43:: with SMTP id r3mr12772298lfn.150.1579507709068;
        Mon, 20 Jan 2020 00:08:29 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id a15sm16223866ljn.50.2020.01.20.00.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 00:08:28 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1itS6i-0000Fg-W0; Mon, 20 Jan 2020 09:08:25 +0100
Date:   Mon, 20 Jan 2020 09:08:24 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Johan Hovold <johan@kernel.org>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: serial: keyspan: handle unbound
 ports" failed to apply to 4.9-stable tree
Message-ID: <20200120080824.GC2301@localhost>
References: <157944127621242@kroah.com>
 <20200119154733.GR1706@sasha-vm>
 <20200119160136.GB2301@localhost>
 <20200119185326.GW1706@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119185326.GW1706@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 01:53:26PM -0500, Sasha Levin wrote:
> On Sun, Jan 19, 2020 at 05:01:36PM +0100, Johan Hovold wrote:
> >On Sun, Jan 19, 2020 at 10:47:33AM -0500, Sasha Levin wrote:
> >> On Sun, Jan 19, 2020 at 02:41:16PM +0100, gregkh@linuxfoundation.org wrote:
> >> >
> >> >The patch below does not apply to the 4.9-stable tree.
> >> >If someone wants it applied there, or to any other stable or longterm
> >> >tree, then please email the backport, including the original git commit
> >> >id to <stable@vger.kernel.org>.
> >> >
> >> >thanks,
> >> >
> >> >greg k-h
> >> >
> >> >------------------ original commit in Linus's tree ------------------
> >> >
> >> >From 3018dd3fa114b13261e9599ddb5656ef97a1fa17 Mon Sep 17 00:00:00 2001
> >> >From: Johan Hovold <johan@kernel.org>
> >> >Date: Fri, 17 Jan 2020 10:50:25 +0100
> >> >Subject: [PATCH] USB: serial: keyspan: handle unbound ports
> >> >
> >> >Check for NULL port data in the control URB completion handlers to avoid
> >> >dereferencing a NULL pointer in the unlikely case where a port device
> >> >isn't bound to a driver (e.g. after an allocation failure on port
> >> >probe()).
> >> >
> >> >Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
> >> >Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >> >Cc: stable <stable@vger.kernel.org>
> >> >Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> >Signed-off-by: Johan Hovold <johan@kernel.org>
> >>
> >> Grabbing the prerequisite for the other USB patch also resolved the
> >> conflict here, now queued for 4.9 and 4.4.
> >
> >Just curious; which prerequisite are referring to here? I can't seem to
> >understand why this one failed to apply to 4.9 in the first place as
> >there hasn't really been any changes to that code in the keyspan driver.
> 
> I thought that it was either dd1fae527612 ("USB: serial: io_edgeport:
> use irqsave() in USB's complete callback") or the stable commit that was
> applied on top, but you're right -  it doesn't seem to be either of
> those.

Thanks for confirming, and for doing the backports.

Johan
