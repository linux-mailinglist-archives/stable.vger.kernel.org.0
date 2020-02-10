Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCEF1581BA
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 18:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBJRvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 12:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgBJRvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 12:51:14 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DED520842;
        Mon, 10 Feb 2020 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581357073;
        bh=5huHFuo004r9HYmfzS4hwK/u27DOp2pQbnaBtYJ/lhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1M7+4YTGaNkf7cMjriFv+1ZXTgj7PPuQdU5oyFHif+mQIAzWMehhb1O/qRQIqFCjH
         ajq3t/hhnr8EcNy3UNn6vyccOfGvMTrlJ6KVBEVidPXMJbrMzxUwuWUpmfgL3YTAX9
         te/C5PBfLzV0z1l7fJD410gcHt0wRAa7imyvOA5c=
Date:   Mon, 10 Feb 2020 09:51:12 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Basil Eljuse <Basil.Eljuse@arm.com>
Subject: Re: [PATCH 5.5 284/367] compat: scsi: sg: fix v3 compat read/write
 interface
Message-ID: <20200210175112.GB1003262@kroah.com>
References: <20200210122423.695146547@linuxfoundation.org>
 <20200210122450.176337512@linuxfoundation.org>
 <CA+G9fYu4pDFaG-dA2KbVp61HGNzA1R3F_=Z5isC8_ammG4iZkQ@mail.gmail.com>
 <CAK8P3a0iq1fj7iVuYMYczbg2ij-x5b0D5OeKiy_2Pebk+ucMeA@mail.gmail.com>
 <CAEUSe787_LxgSWmo4cxU52Ti3mq3ydtco5J7A87Eec7HeLMCNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe787_LxgSWmo4cxU52Ti3mq3ydtco5J7A87Eec7HeLMCNQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 11:45:58AM -0600, Daniel Díaz wrote:
> Helo!
> 
> On Mon, 10 Feb 2020 at 09:58, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Mon, Feb 10, 2020 at 4:41 PM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > The arm64 architecture 64k page size enabled build failed on stable rc 5.5
> > > CONFIG_ARM64_64K_PAGES=y
> > > CROSS_COMPILE=aarch64-linux-gnu-
> > > Toolchain gcc-9
> > >
> > > In file included from ../block/scsi_ioctl.c:23:
> > >  ../include/scsi/sg.h:75:2: error: unknown type name ‘compat_int_t’
> > >   compat_int_t interface_id; /* [i] 'S' for SCSI generic (required) */
> > >   ^~~~~~~~~~~~
> > >  ../include/scsi/sg.h:76:2: error: unknown type name ‘compat_int_t’
> > >   compat_int_t dxfer_direction; /* [i] data transfer direction  */
> > >   ^~~~~~~~~~~~
> > >
> > > ...
> > >  ../include/scsi/sg.h:97:2: error: unknown type name ‘compat_uint_t’
> > >   compat_uint_t info;  /* [o] auxiliary information */
> >
> > Hi Naresh,
> >
> > Does it work if you backport 071aaa43513a ("compat: ARM64: always include
> > asm-generic/compat.h")?
> 
> Yes, cherry-picking 556d687a4ccd ("compat: ARM64: always include
> asm-generic/compat.h") gets it back on track.

Great, I'll go add that now and push out a -rc2.  Thanks for finding
this so quickly.

greg k-h
