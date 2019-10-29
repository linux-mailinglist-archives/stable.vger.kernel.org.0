Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35704E850B
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 11:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfJ2KFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 06:05:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37234 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJ2KFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 06:05:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id q130so1709103wme.2;
        Tue, 29 Oct 2019 03:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VwVCJvBkvTdm9BSUnd9jdf4FOOPb5NaI8k+d4L1wBU4=;
        b=Q4zxjV67mrd/xnpNh5n6mQlH9CT33ulNoVoUUUuEoaeLQOiTFigDf29n3Jn/RqTGTg
         54Kp7ZymjvHUe+HVDNTz3LoElSoytx0PJ+YmHQkO4N4XU59PxV3e6WIykGj8MmxzMbMq
         ZPoLuTg1S63uun3TOKI72DBC3P6tmPoAiGqd2rlV8v/qCVvl/+nwmH2yMbOtxsp044Z9
         Ff1+z6i/m45tKwe/PRRVlEo4qEY2sV1aUNycXrIIDFnnUFZNsVRk1qBu5OsdT9lYMnoN
         ySZOC9MczHXIqI7CB7S9UGBTQAoTgDrhHiMKhld37CeukpTix6ArNGmRTC7US3jjFvGn
         UD5A==
X-Gm-Message-State: APjAAAUTl2HB8Dz+2PWYKn0p27tM9KbZh7mZAgYpxLiGoIg7zYz5o7As
        T/IRqf5elBSLYcOCz4T+0tGDMgQoAdM=
X-Google-Smtp-Source: APXvYqw5btc3uQXDpSHksE3uGXSr3w8/dvCp3XGFGivwHvwVClXWQs9OVelli8XsNivum7XMd+LniQ==
X-Received: by 2002:a1c:2344:: with SMTP id j65mr3455802wmj.38.1572343547384;
        Tue, 29 Oct 2019 03:05:47 -0700 (PDT)
Received: from pi (100.50.158.77.rev.sfr.net. [77.158.50.100])
        by smtp.gmail.com with ESMTPSA id c144sm2358614wmd.1.2019.10.29.03.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 03:05:46 -0700 (PDT)
Received: from johan by pi with local (Exim 4.92.2)
        (envelope-from <johan@pi>)
        id 1iPOMW-000205-8U; Tue, 29 Oct 2019 11:04:28 +0100
Date:   Tue, 29 Oct 2019 11:04:28 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 095/100] USB: usb-skeleton: fix
 use-after-free after driver unbind
Message-ID: <20191029100428.GA4691@localhost>
References: <20191018220525.9042-1-sashal@kernel.org>
 <20191018220525.9042-95-sashal@kernel.org>
 <20191018222205.GA6978@kroah.com>
 <20191029090435.GJ1554@sasha-vm>
 <20191029094321.GA582711@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029094321.GA582711@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 10:43:21AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Oct 29, 2019 at 05:04:35AM -0400, Sasha Levin wrote:
> > On Fri, Oct 18, 2019 at 06:22:05PM -0400, Greg Kroah-Hartman wrote:
> > > On Fri, Oct 18, 2019 at 06:05:20PM -0400, Sasha Levin wrote:
> > > > From: Johan Hovold <johan@kernel.org>
> > > > 
> > > > [ Upstream commit 6353001852776e7eeaab4da78922d4c6f2b076af ]
> > > > 
> > > > The driver failed to stop its read URB on disconnect, something which
> > > > could lead to a use-after-free in the completion handler after driver
> > > > unbind in case the character device has been closed.
> > > > 
> > > > Fixes: e7389cc9a7ff ("USB: skel_read really sucks royally")
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > Link: https://lore.kernel.org/r/20191009170944.30057-3-johan@kernel.org
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  drivers/usb/usb-skeleton.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > 
> > > This file does not even get built in the kernel tree, no need to
> > > backport anything for it :)
> > 
> > I'll drop it, but you're taking patches for this driver:
> > https://lore.kernel.org/patchwork/patch/1140673/ .
> 
> Ah yeah, I probably shouldn't have taken stable backports for that, my
> fault.

Note that this was all due to

	https://lkml.kernel.org/r/20190930161205.18803-2-johan@kernel.org

which fixed a PM bug due to an API change that was backported to stable.

I considered it comparable to a documentation fix to make sure that the
template driver matched the new API, hence the stable tag.

Johan
