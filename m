Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34082A614D
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 11:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgKDKO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 05:14:28 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41936 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgKDKO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 05:14:28 -0500
Received: by mail-lf1-f67.google.com with SMTP id 126so26363766lfi.8;
        Wed, 04 Nov 2020 02:14:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qj7cyA8bPmJuoqm8ZoVYSYnBqnNB68Vqkk/+rTU6vA8=;
        b=jhPrh68c0IId2fgB/J9LLb70OOVrr51bC3VfIKieM42d355bTJyZ4Ja5AqYY6/mvFR
         YsDYfMafohwZGLNgn3HVpU8+fnGUPa+iwiF2uIXwev+hUXENYNtyagW8UYrL15yam0N8
         j7NzDvs/l2ElQeqgVgn2Em/BoHLNfEYAVi2P2YML6el3jNLOvimTs1fX4vxgJXA0rqQs
         uTrjNV3R7BBSHZyyJDAye3UrdvdvtlpO1tiLe1mOkSjDwezRj/DIS7wAOV0WR8h1Q6gi
         PKz8Aa+xzVQuYAGl9xrAxGQg30YYPes6A6c3xIAJW52pSpnBtsI1QvYtSPqYsYLKL34w
         fFQw==
X-Gm-Message-State: AOAM530e5ctx+xqhWQZS5EB1t94dsUHXHDYXxluIlJxPCdPOD7hW5c5k
        fLfHlQMSxD7s+boDyKyKoTA=
X-Google-Smtp-Source: ABdhPJwkn4G7igYUZ+y+h05mEhBA4PfJOkGGFXxcLvL8aBzIA6NyFNfGap98na4N5Ocs3qjkm7CwUQ==
X-Received: by 2002:ac2:5b8b:: with SMTP id o11mr6292409lfn.285.1604484865918;
        Wed, 04 Nov 2020 02:14:25 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id v18sm359084lfo.137.2020.11.04.02.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 02:14:24 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kaFoC-0007ZE-VE; Wed, 04 Nov 2020 11:14:29 +0100
Date:   Wed, 4 Nov 2020 11:14:28 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: digi_acceleport: fix write-wakeup deadlocks
Message-ID: <20201104101428.GS4085@localhost>
References: <20201026104306.29576-1-johan@kernel.org>
 <20201028093818.GB1953863@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028093818.GB1953863@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 10:38:18AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Oct 26, 2020 at 11:43:06AM +0100, Johan Hovold wrote:
> > The driver must not call tty_wakeup() while holding its private lock as
> > line disciplines are allowed to call back into write() from
> > write_wakeup(), leading to a deadlock.
> > 
> > Also remove the unneeded work struct that was used to defer wakeup in
> > order to work around a possible race in ancient times (see comment about
> > n_tty write_chan() in commit 14b54e39b412 ("USB: serial: remove
> > changelogs and old todo entries")).
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/serial/digi_acceleport.c | 45 ++++++++--------------------
> >  1 file changed, 13 insertions(+), 32 deletions(-)
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for the review. Applied for -next along with the cleanup patch.

Johan
