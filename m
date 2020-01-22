Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5263C1456DD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgAVNh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:37:59 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35289 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgAVNh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 08:37:59 -0500
Received: by mail-lj1-f195.google.com with SMTP id j1so6854254lja.2;
        Wed, 22 Jan 2020 05:37:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YLKzXOvGNmIzBzHnBJJLY3qgxu10LoeutM8SYCSkDU0=;
        b=f3aDoPk1aXJu3O5npqjSPfa0WI+DA2Jpc226krRxFfIfifTWDPafOaD5oIJqNuJGg5
         6+Bc1g62m4VbMQ0bTji5XFxA627otGzHSH69Bv0cYzIXbxHfY3muC/iSv3vE+Uru1ki1
         abFmyNFVj0uUrpAjB9O1+di/Vju6zgBQQVDWZKvRmCDaZ9vZp8kTx+CL9e66432OJKIK
         R2Q5UHnwkwApMfuasZeFQaYzQ+pxd1o67YXcqFFUK9eCK+7EFEUZSzn90oO9rv3/QlkH
         ohRObE0B2powo7Os6cY07/NbHtZls0HHQsGt+yaTFM7k/BYXh0Di66WzMFYXM+faXNas
         G03w==
X-Gm-Message-State: APjAAAVfPAtOl69ldY294hiTOsa+MBfC4duBLLK4vQc1uMNmEcrQ7C22
        EmEmT3tSi0HkSTeE2Hod/so=
X-Google-Smtp-Source: APXvYqzjtidvc5lzo/mPo34+wKWaQ0uPeltMxXjykIhJNYUGEL6/+U27WRjN++JBwxHEX/ghJgLauQ==
X-Received: by 2002:a2e:918c:: with SMTP id f12mr19899977ljg.66.1579700276602;
        Wed, 22 Jan 2020 05:37:56 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id t1sm20324164lji.98.2020.01.22.05.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:37:56 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iuGCe-0008NG-Gy; Wed, 22 Jan 2020 14:37:52 +0100
Date:   Wed, 22 Jan 2020 14:37:52 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3/5] USB: serial: ir-usb: fix IrLAP framing
Message-ID: <20200122133752.GF8375@localhost>
References: <20200122101530.29176-1-johan@kernel.org>
 <20200122101530.29176-4-johan@kernel.org>
 <20200122132542.GC3580@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122132542.GC3580@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 02:25:42PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Jan 22, 2020 at 11:15:28AM +0100, Johan Hovold wrote:
> > Commit f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
> > switched to using the generic write implementation which may combine
> > multiple write requests into larger transfers. This can break the IrLAP
> > protocol where end-of-frame is determined using the USB short packet
> > mechanism, for example, if multiple frames are sent in rapid succession.
> > 
> > Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
> > Cc: stable <stable@vger.kernel.org>     # 2.6.35
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/serial/ir-usb.c | 113 +++++++++++++++++++++++++++++-------
> >  1 file changed, 91 insertions(+), 22 deletions(-)
> 
> Ah, nice fix, sorry about that :(

The offending commit was mine so same to you. ;)

> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Johan
