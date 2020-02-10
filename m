Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203761571D0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 10:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgBJJfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 04:35:05 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42582 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgBJJfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 04:35:05 -0500
Received: by mail-lj1-f194.google.com with SMTP id d10so6301087ljl.9;
        Mon, 10 Feb 2020 01:35:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2dMtmeDRnp4IqIYHT+2e2+AiEKEG+n4IbCtoKAc5Vi0=;
        b=YMSk8Ba68rYzrYiuDUSRTkVrcxSAzMpeePY9x9yPBGYxQgeqakpvQSSKhjCslh0c5G
         Y3QiLFp93kbbrm0SmlYUPdn9BsMlgaOPdO1yzX29KFx8OuVcejNWfor605TBWot9EVTH
         Z0Cr9HuOfq42VJ5xEgNT5yt2t8jEJbfZw5kI+xieaDHNPSdSNhM+e5See4pvDw37C6j5
         fk2xcChRfnSeyfOrifHAlErFR9RT61WsSUaljdGCIfp1N07nGsuO2iBlGF8IHHX5+NGC
         mmMeuuEoBRjpAhiSnGiugYEZddgpC/MB2fmfv74nap9NzpJt9dJpG8Ku6NDgsLL9oo1r
         Bfng==
X-Gm-Message-State: APjAAAXTLuiFy+Ig8ORiQJ8LKVJNU/ntTmSs9WMmwh2LkH+Kb9eaSq3y
        vi33BN8gtZ6xtnOGP1XbJZA=
X-Google-Smtp-Source: APXvYqxKy4brjEUxzjMG+gW2v+H+fGRjyDf1ySMlmY1e+JOpQOVWfLrGV9FmXnjkf5WDmP3pAYjLzg==
X-Received: by 2002:a2e:5357:: with SMTP id t23mr302326ljd.227.1581327303258;
        Mon, 10 Feb 2020 01:35:03 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id 5sm6000098lju.69.2020.02.10.01.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 01:35:02 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1j15T2-00045d-7f; Mon, 10 Feb 2020 10:35:00 +0100
Date:   Mon, 10 Feb 2020 10:35:00 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, Jakub Nantl <jn@forever.cz>,
        Jonathan Olds <jontio@i4free.co.nz>,
        Michael Dreher <michael@5dot1.de>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: ch341: fix receiver regression
Message-ID: <20200210093500.GA3539@localhost>
References: <20200206111819.20829-1-johan@kernel.org>
 <20200206114546.GA3275679@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206114546.GA3275679@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 11:45:46AM +0000, Greg Kroah-Hartman wrote:
> On Thu, Feb 06, 2020 at 12:18:19PM +0100, Johan Hovold wrote:
> > While assumed not to make a difference, not using the factor 2 prescaler
> > makes the receiver more susceptible to errors.
> > 
> > Specifically, there have been reports of problems with devices that
> > cannot generate a 115200 rate with a smaller error than 2.1% (e.g.
> > 117647 bps). But this can also be reproduced with a low-speed RS232
> > tranceiver at 115200 when the input rate is close to nominal.
> > 
> > So whenever possible, enable the factor 2 prescaler and halve the
> > divisor in order to use settings closer to that of the previous
> > algorithm.
> > 
> > Fixes: 35714565089e ("USB: serial: ch341: reimplement line-speed handling")
> > Cc: stable <stable@vger.kernel.org>	# 5.5
> > Reported-by: Jakub Nantl <jn@forever.cz>
> > Tested-by: Jakub Nantl <jn@forever.cz>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for reviewing. Now applied.

Johan
