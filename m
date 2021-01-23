Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63E73012E7
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 04:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbhAWD7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 22:59:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726533AbhAWD7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 22:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611374275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WJ9Mm5Q1SkM9lfn4njziV+U6R5yBys70RfxEBh9Yi+c=;
        b=dbe2JFS1dogNfbJ/cJo4tHGNrYmmmf85fSynO9MQ5owX+tIpq90M/KFp9vwhfvrfgfukcb
        3TbsAO9Ck8zjrUYijH0BX8DrxWl9p3RNHWy8npcsCjpv7JjLpdsD4XrF24rGUpeZvZkfYi
        aFdARL2j8o02ylIHThc/u7f2LAC0lp4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-3tQGP1XmNuKJg-RaQaU7Cw-1; Fri, 22 Jan 2021 22:57:51 -0500
X-MC-Unique: 3tQGP1XmNuKJg-RaQaU7Cw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0958F8018A3;
        Sat, 23 Jan 2021 03:57:48 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-12-54.pek2.redhat.com [10.72.12.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D90CA5DA2D;
        Sat, 23 Jan 2021 03:57:36 +0000 (UTC)
Date:   Sat, 23 Jan 2021 11:57:33 +0800
From:   Dave Young <dyoung@redhat.com>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     John Donnelly <john.p.donnelly@oracle.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        Kairui Song <kasong@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, Baoquan He <bhe@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kexec mailing list <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Diego Elio =?iso-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.com>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
Message-ID: <20210123035733.GA6865@dhcp-128-65.nay.redhat.com>
References: <CACPcB9e8p5Ayw15aOe5ZNPOa7MF3+pzPdcaZgTc_E_TZYkgD6Q@mail.gmail.com>
 <AC36B9BC-654C-4FC1-8EA3-94B986639F1E@oracle.com>
 <CACPcB9d7kU1TYaF-g2GH16Wg=hrQu71sGDoC8uMFFMc6oW_duQ@mail.gmail.com>
 <CAHD1Q_yB1B4gu7EDqbZJ5dxAAkr-dVKa9yRDK-tE3oLeTTmLJQ@mail.gmail.com>
 <20201123034705.GA5908@dhcp-128-65.nay.redhat.com>
 <d6b5b7f3-ba38-be61-d3fe-975c3343a79d@oracle.com>
 <20210122012254.GA3174@dhcp-128-65.nay.redhat.com>
 <20210122031244.GA4717@dhcp-128-65.nay.redhat.com>
 <730EBE33-5571-49C0-AF38-08C49736EB70@oracle.com>
 <20210123035126.GA6539@dhcp-128-65.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123035126.GA6539@dhcp-128-65.nay.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/23/21 at 11:51am, Dave Young wrote:
> Hi Saeed,
> On 01/22/21 at 05:14pm, Saeed Mirzamohammadi wrote:
> > Hi,
> > 
> > > On Jan 21, 2021, at 7:12 PM, Dave Young <dyoung@redhat.com> wrote:
> > > 
> > > On 01/22/21 at 09:22am, Dave Young wrote:
> > >> Hi John,
> > >> 
> > >> On 01/21/21 at 09:32am, john.p.donnelly@oracle.com wrote:
> > >>> On 11/22/20 9:47 PM, Dave Young wrote:
> > >>>> Hi Guilherme,
> > >>>> On 11/22/20 at 12:32pm, Guilherme Piccoli wrote:
> > >>>>> Hi Dave and Kairui, thanks for your responses! OK, if that makes sense
> > >>>>> to you I'm fine with it. I'd just recommend to test recent kernels in
> > >>>>> multiple distros with the minimum "range" to see if 64M is enough for
> > >>>>> crashkernel, maybe we'd need to bump that.
> > >>>> 
> > >>>> Giving the different kernel configs and the different userspace
> > >>>> initramfs setup it is hard to get an uniform value for all distributions,
> > >>>> but we can have an interface/kconfig-option for them to provide a value like this patch
> > >>>> is doing. And it could be improved like Kairui said about some known
> > >>>> kernel added extra values later, probably some more improvements if
> > >>>> doable.
> > >>>> 
> > >>>> Thanks
> > >>>> Dave
> > >>>> 
> > >>> 
> > >>> Hi.
> > >>> 
> > >>> Are we going to move forward with implementing this for X86 and Arm ?
> > >>> 
> > >>> If other platform maintainers want to include this CONFIG option in their
> > >>> configuration settings they have a starting point.
> > >> 
> > >> I would expect this become arch independent.
> > > 
> > > Clarify a bit, it can be a general config option under arch/Kconfig and
> > > just put the code in general arch independent part.
> > 
> > Does this mean that we need to add the option to def_configs in all archs as well?
> > 
> 
> I think we do not need to add defconfig, something like this will just work?
> 
> BTW, it should depend on CRASH_CORE instead of CRASH_DUMP, the logic of
> parsing crashkernel is in kernel/crash_core.c
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index af14a567b493..fa6efeb52dc5 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -14,6 +14,11 @@ menu "General architecture-dependent options"
>  config CRASH_CORE
>  	bool
>  
> +config CRASH_AUTO_STR
> +	depends on CRASH_CORE
> +	string "Memory reserved for crash kernel"
> +	default "1G-:128M"

People do not want to see the default value if they do not need kdump 
so it would be better to add another kconfig option as a switch which is
set default as off in bool state.

> +	... help text [snip] ...
> +
>  config KEXEC_CORE
>  	select CRASH_CORE
>  	bool
> 
> [...]
> 
> > Thanks,
> > Saeed
> > 
> > > 
> > >> 
> > >> Saeed, Kairui, would any of you like to update the patch?
> > >> 
> > >>> 
> > >>> Thank you,
> > >>> 
> > >>> John.
> > >>> 
> > >>> ( I am not currently on many of the included dist lists  in this email, so
> > >>> hopefully key contributors are included in this exchange )
> > >>> 
> > >> 
> > >> Thanks
> > >> Dave
> > 
> 
> Thanks
> Dave

