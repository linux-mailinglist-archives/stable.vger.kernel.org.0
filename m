Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1071B13B796
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 03:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgAOCPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 21:15:48 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41344 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbgAOCPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 21:15:48 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so7653085pfw.8;
        Tue, 14 Jan 2020 18:15:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J26ofUR3ODZFKYUwZwovSvNraObvIoktYNYuocxeBTc=;
        b=HPJ5yfdeZd2nEm9VDPXdoiRwFsYnV1Jxhrd82+ethOxwNcxH3S+GLkFFV+6FMUD87U
         0TTe+gQUfcsv/M/KR5YdpWlV7w7S5FjkckD0od/QIr4qHgceTDMubTJnhpRLHD0GBW7f
         Mb30ZgDUmSJQBXO7Dk+Prq0Rds/39/sdN+UtZqWuycahDqIJhNd/GdwQgzkJGGsYrKvG
         VM7Q9gbiQ51IaDu4mdYrEUYVj75mOvBZ6EgkpsSKTLsVN/50tW/nPSy++2y7Q48EY+1N
         M+wXDjii4ir+y/pCqMoBDI2EI59d4kGCOL6hJXAPBqqaM+NA205okBpEoHQJ3Suve3XU
         whBg==
X-Gm-Message-State: APjAAAVRnBWXtHGp8EiNmRlZT6EF/ItI4/lo52dljt3Gd+RB3omF4EZp
        FgmGU/11+PQyU8C/c/BwP4A=
X-Google-Smtp-Source: APXvYqx+Y6MXk6p34YH4fcWpwtETUyP8vIwvAVxlDFSpQ1L1jzbu3gQ4eTFBhCslPosGq/RoLM06Gg==
X-Received: by 2002:a62:7fcd:: with SMTP id a196mr28145031pfd.208.1579054547296;
        Tue, 14 Jan 2020 18:15:47 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id c19sm20646838pfc.144.2020.01.14.18.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 18:15:46 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 6B06A40244; Wed, 15 Jan 2020 02:15:45 +0000 (UTC)
Date:   Wed, 15 Jan 2020 02:15:45 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jari Ruusu <jari.ruusu@gmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: Fix built-in early-load Intel microcode alignment
Message-ID: <20200115021545.GD11244@42.do-not-panic.com>
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <20200113154739.GB11244@42.do-not-panic.com>
 <CACMCwJL8tu+GHPeRADR_12xhcYSiDv+Yxdy=yLqMxEsn=P9zFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMCwJL8tu+GHPeRADR_12xhcYSiDv+Yxdy=yLqMxEsn=P9zFA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 09:58:25PM +0200, Jari Ruusu wrote:
> On 1/13/20, Luis Chamberlain <mcgrof@kernel.org> wrote:
> > So what happens with you use the built-in firmware loader for
> > the Intel microcode at this time? I am surprised this issue
> > wasn't reported earlier, so thanks for picking it up, but to
> > be complete such a change requires a bit more information.
> >
> > What exactly happens now?
> 
> Before that 16-byte alignment patch was applied, my only one
> microcode built-in BLOB was "accidentally" 16-byte aligned.

How did it accidentially get 16-byte aligned?

Also, how do you *know* something is broken right now? I mean
you issued a patch for stable. I thought you hit a panic or
some issue while loading. If we are not sure this fixes a real
issue as of yet, I can't see the merit for propagating a fix
to stable.

> After that patch was applied, new kernel System.map file was
> exactly same. So, for me that patch did not change anything.
> 
> Same 16-byte alignment before and after patch:
> 
> $  grep " _fw_.*_bin" System.map
> ffffffff81f55e90 r _fw_intel_ucode_06_8e_09_bin
> 
> >> Fix this by forcing all built-in firmware BLOBs to 16-byte
> >> alignment.
> >
> > That's a huge stretch, see below.
> 
> I understand and to some degree agree.
> 
> > So I'd like to determine first if we really need this.
> 
> We do need it. Violating Intel specs is not good. It may be that
> some processor models require aligned and some accept less
> aligned.

Fair point. A fix to follow the spec is however different than to say
without it things don't work, and we need to propagate a fix to stable
kernels.

> > If set as a global new config option, we can use the same logic and
> > allow an architecture override if the user / architecture kconfig
> > configures it such:
> >
> > config ARCH_DEFAULT_FIRMWARE_ALIGNMENT
> > 	string "Default architecture firmware aligmnent"
> > 	"4" if 64BIT
> > 	"3" if !64BIT
> >
> > config FIRMWARE_BUILTIN_ALIGN
> > 	string "Built in firmware aligment requirement"
> > 	default ARCH_DEFAULT_FIRMWARE_ALIGNMENT if !ARCH_CUSTOM_FIRMWARE_ALIGNMENT
> > 	default ARCH_CUSTOM_FIRMWARE_ALIGNMENT_VAL if
> > ARCH_CUSTOM_FIRMWARE_ALIGNMENT
> > 	  Some good description goes here
> >
> > Or something like that.
> 
> It doesn't have to user visible config option, only default align
> changed when selected set of options are enabled.

Right, I didn't intend for it to be visible really. It was just an
example of kconfig magic how perhaps how to define this if we needed
something configurable per arch.

> My patch was intentionally minimal, without #ifdef spaghetti.

Thanks for it. We just need to dust it off a bit now.

  Luis
