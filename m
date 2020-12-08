Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB72D3418
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 21:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgLHU3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 15:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbgLHU3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 15:29:15 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50556C061793
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 12:28:29 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id c14so3325791qtn.0
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 12:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pXHQqefKGTlk5PV0hW65Jgx+0PaDoieyIGG72FsWOhY=;
        b=ZihMAVlLdTidJ7S5+1t6zKTggHOhCrB3cRSizKCmG3dKKG9DwDg+AsuZLjxaeDYt9/
         zYRJ9ygdhvaiouSzktL6r1ThmPvdQ/WbZ6N2sy2wbyEu+ubGwHPKlhvejp7uUbvqgygQ
         NnaWWmnYpNYh7RjQJ9uVkLOX1Kd0T4HGqs0Rm+k5xUE1v1Z1nXj34jv12sdvD0HURxwV
         6PQ6w33SV3hkVPKXdbXGPQQZwmD0p4CA8u38MNK4jCUl4ZbVd5fDYkrcQwHJocML3jTK
         5udgBQqxATbbhSKEvzlw7jHFSOUfzyeF605qOiMF7g9F7j9OaV+fC/dCGgd00BjqAZFp
         BG3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pXHQqefKGTlk5PV0hW65Jgx+0PaDoieyIGG72FsWOhY=;
        b=Cm8vGyz+1sC4Hj6dTWOhflPUXttp1bhntbq1CIFWT+1vl65q/HhK/Va+FI7sJOEaTr
         J70/RCLpZ6SpPshTETWFI2EE4XDZ9RYHgdP96k96HnVUewty+9Vx86FT84mlyW+BKBfe
         eWxnBvLx/JCBhXcA3N0Zn6G4Cqba8KmmC0SoEmDKYxGyyA6oTdOvD1+MZPA6Wft04jdq
         hEN9FLO0OGbrbr+by9ZVMA+bYv1GHkvipiT0h7+r/mo/nbNGJBVaekVqwBtIZl26/lKa
         c4T0hYlYGiBmGZFmMQ1dyMKinDh4H7GQYIGA28AjKPgKJsT6tyfWEZOE6R9IGdgNEXHn
         JvLA==
X-Gm-Message-State: AOAM530kxxO2kNucxpyovwiYk4byo4qZjxDtQcew7IMDvMFTauV+m1eR
        xWB1PQNxMGELB61u1HZQGxQ=
X-Google-Smtp-Source: ABdhPJykg/WL9Zm6K7+LRYH6iyGa0clLq4urmPtnb2It0Ho/bkqtd2RmxS2hQLsdvXiwn/rcced43w==
X-Received: by 2002:a05:622a:208:: with SMTP id b8mr32858781qtx.124.1607459308193;
        Tue, 08 Dec 2020 12:28:28 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id u20sm10993693qtb.9.2020.12.08.12.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 12:28:27 -0800 (PST)
Date:   Tue, 8 Dec 2020 13:28:26 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <20201208202826.GA3625918@ubuntu-m3-large-x86>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208171145.GA3241@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 06:11:45PM +0100, Lukas Wunner wrote:
> On Tue, Dec 08, 2020 at 08:47:39AM -0500, Sasha Levin wrote:
> > On Tue, Dec 08, 2020 at 08:32:41AM +0100, Lukas Wunner wrote:
> > > On Mon, Dec 07, 2020 at 05:49:01PM -0700, Nathan Chancellor wrote:
> > > > On Sun, Dec 06, 2020 at 01:31:03PM +0100, Lukas Wunner wrote:
> > > > > [ Upstream commit e13ee6cc4781edaf8c7321bee19217e3702ed481 ]
> > > > >
> > > > > bcm2835aux_spi_remove() accesses the driver's private data after calling
> > > > > spi_unregister_master() even though that function releases the last
> > > > > reference on the spi_master and thereby frees the private data.
> > > > >
> > > > > Fix by switching over to the new devm_spi_alloc_master() helper which
> > > > > keeps the private data accessible until the driver has unbound.
> > > > >
> > > > > Fixes: b9dd3f6d4172 ("spi: bcm2835aux: Fix controller unregister order")
> > > > > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > > > > Cc: <stable@vger.kernel.org> # v4.4+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
> > > > > Cc: <stable@vger.kernel.org> # v4.4+: b9dd3f6d4172: spi: bcm2835aux: Fix controller unregister order
> > > > > Cc: <stable@vger.kernel.org> # v4.4+
> > > > > Link: https://lore.kernel.org/r/b290b06357d0c0bdee9cecc539b840a90630f101.1605121038.git.lukas@wunner.de
> > > > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > > > 
> > > > Please ensure that commit d853b3406903 ("spi: bcm2835aux: Restore err
> > > > assignment in bcm2835aux_spi_probe") is picked up with this patch in all
> > > > of the stable trees that it is applied to.
> > > 
> > > That shouldn't be necessary as I've made sure that the backports to
> > > 4.19 and earlier do not exhibit the issue fixed by d853b3406903.
> > > 
> > > However, nobody is perfect, so if I've missed anything, please let
> > > me know.
> > 
> > Could we instead have the backports exhibit the issue (like they did
> > upstream) and then take d853b3406903 on top?
> 
> The upstream commit e13ee6cc4781 did not apply cleanly to 4.19 and earlier,
> several adjustments were required.  Could I have made it so that the fixup
> d853b3406903 would have still been required?  Probably, but it seems a
> little silly to submit a known-bad patch.
> 
> Thanks,
> 
> Lukas

I did not really look at the actual patches themselves, just the fact
that I saw the commit title without my patch as a follow up in the
series. If your backport avoids the issue entirely, that is fine by me.

Cheers,
Nathan
