Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E821C2A6147
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 11:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgKDKNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 05:13:37 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36269 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgKDKNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 05:13:37 -0500
Received: by mail-lf1-f66.google.com with SMTP id h6so26383230lfj.3;
        Wed, 04 Nov 2020 02:13:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b9SBYmvOnvy5gEjjM8HWExZLyvdCdjl45JmB5Ywux6Q=;
        b=fvacvVZhZgaOFbLPigILoIaBpiNZaueYKCwXzKd8hq5Q4zbApXE3LpOhmOVDwXL9uB
         bzBKb2+u0yo4QZu17V+2ZAI/zORGr0JOKuJCNoEkDtGWpvYTPPyNeGGyI7kTXbHFWbzp
         MhrQAIZeUK3xWQL/G2sgGozyxSjMj1V8wXlz2OpJtf6ilhyCVraXZyYt0V0axRGCkWfS
         2H+zZQeKoWn+hfBP951kdyMr6sdjVyRqHWYkJd/xM11Gwsd3dwoiCglAlHVCtGq2qH08
         lnO6w0DEtAL0JZtoIYncKY6hLzkw+CrFJPIgHBMVvrdqE1UO6BuiNjRaUFoIAACqMRhI
         19rw==
X-Gm-Message-State: AOAM533uFubdCHPZRMU7A2lKRv0CS/Uouh+mLqjITw3qyqr5PiG3/LLZ
        6De1EDGmK0J3L5icZeYjNMxgaInmMPmmSw==
X-Google-Smtp-Source: ABdhPJxVxucpjkNuDjuNjCi2cXvQ+WEpyPe0k2StvrGNPYoeiWeynjBASVlUupjITRbocuYupamivw==
X-Received: by 2002:a19:4151:: with SMTP id o78mr8990431lfa.408.1604484813142;
        Wed, 04 Nov 2020 02:13:33 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id k22sm358325lfg.205.2020.11.04.02.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 02:13:32 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kaFnL-0007Yr-Df; Wed, 04 Nov 2020 11:13:36 +0100
Date:   Wed, 4 Nov 2020 11:13:35 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: cyberjack: fix write-URB completion race
Message-ID: <20201104101335.GR4085@localhost>
References: <20201026082548.17970-1-johan@kernel.org>
 <20201028093827.GC1953863@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028093827.GC1953863@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 10:38:27AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Oct 26, 2020 at 09:25:48AM +0100, Johan Hovold wrote:
> > The write-URB busy flag was being cleared before the completion handler
> > was done with the URB, something which could lead to corrupt transfers
> > due to a racing write request if the URB is resubmitted.
> > 
> > Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
> > Cc: stable <stable@vger.kernel.org>     # 2.6.13
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/serial/cyberjack.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks, applied for 5.10-rc.

Johan
