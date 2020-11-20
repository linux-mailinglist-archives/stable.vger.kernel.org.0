Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB2B2BA05E
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 03:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgKTC06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 21:26:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726117AbgKTC06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 21:26:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605839216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4sxKhMof86hickCRVUEuAEtymNQnjon9Bfb0eSzoC34=;
        b=DLZ7lTcsQgo4wZGboMZCQrBKGq5bqLUjXDXQtenAfRPly49+CWffU7vSkTV2cEEaIYJkPP
        mh+ahPj6DB/3rm65m3sldneLpA+hpFA6uhvgMaHzx+6BJuR+1XJGLmNIp2pPnNhlFyxxex
        p+D2mTOaLcONDMO51ecUbyZAy/qQa70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-sOa4YTahNv2t3MXF3bnYLw-1; Thu, 19 Nov 2020 21:26:43 -0500
X-MC-Unique: sOa4YTahNv2t3MXF3bnYLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12C6A180E46F;
        Fri, 20 Nov 2020 02:26:39 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-12-196.pek2.redhat.com [10.72.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CAF110013BD;
        Fri, 20 Nov 2020 02:26:25 +0000 (UTC)
Date:   Fri, 20 Nov 2020 10:26:22 +0800
From:   Dave Young <dyoung@redhat.com>
To:     Guilherme Piccoli <gpiccoli@canonical.com>
Cc:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, john.p.donnelly@oracle.com,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, Baoquan He <bhe@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kexec mailing list <kexec@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Diego Elio =?iso-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.com>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Dann Frazier <dann.frazier@canonical.com>
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
Message-ID: <20201120022622.GA3731@dhcp-128-65.nay.redhat.com>
References: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
 <CAHD1Q_yA37wWrOscBHpSFEjFecGFcrzY6R6qU_iMESzYArV_Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHD1Q_yA37wWrOscBHpSFEjFecGFcrzY6R6qU_iMESzYArV_Kg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guilherme,
On 11/19/20 at 06:56pm, Guilherme Piccoli wrote:
> Hi Saeed, thanks for your patch/idea! Comments inline, below.
> 
> On Wed, Nov 18, 2020 at 8:29 PM Saeed Mirzamohammadi
> <saeed.mirzamohammadi@oracle.com> wrote:
> >
> > This adds crashkernel=auto feature to configure reserved memory for
> > vmcore creation to both x86 and ARM platforms based on the total memory
> > size.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> > Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> > ---
> >  Documentation/admin-guide/kdump/kdump.rst |  5 +++++
> >  arch/arm64/Kconfig                        | 26 ++++++++++++++++++++++-
> >  arch/arm64/configs/defconfig              |  1 +
> >  arch/x86/Kconfig                          | 26 ++++++++++++++++++++++-
> >  arch/x86/configs/x86_64_defconfig         |  1 +
> >  kernel/crash_core.c                       | 20 +++++++++++++++--
> >  6 files changed, 75 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/kdump/kdump.rst b/Documentation/admin-guide/kdump/kdump.rst
> > index 75a9dd98e76e..f95a2af64f59 100644
> > --- a/Documentation/admin-guide/kdump/kdump.rst
> > +++ b/Documentation/admin-guide/kdump/kdump.rst
> > @@ -285,7 +285,12 @@ This would mean:
> >      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> >      3) if the RAM size is larger than 2G, then reserve 128M
> >
> > +Or you can use crashkernel=auto if you have enough memory. The threshold
> > +is 1G on x86_64 and arm64. If your system memory is less than the threshold,
> > +crashkernel=auto will not reserve memory. The size changes according to
> > +the system memory size like below:
> >
> > +    x86_64/arm64: 1G-64G:128M,64G-1T:256M,1T-:512M
> 
> As mentioned in the thread, this was tried before and never got merged
> - I'm not sure the all the reasons, but I speculate that a stronger
> reason is that it'd likely fail in many cases. I've seen cases of 256G

Yes, there were a few tries, last time I tried to set a default value, I
do not think people are strongly against it.  We have been using the
auto in Red Hat for long time, it does work for most of usual cases
like Saeed said in the patch. But I think all of us are aligned it is
not possible to satisfy all the user cases.  Anyway I also think this is
good to have.

> servers that require crashkernel=600M (or more), due to the amount of
> devices. Also, the minimum nowadays would likely be 96M or more - I'm
> looping Cascardo and Dann (Debian/Ubuntu maintainers of kdump stuff)
> so they maybe can jump in with even more examples/considerations.

Another reason of people have different feeling about the memory
requirement is currently distributions are doing different on kdump,
especially for the userspace part. Kairui did a lot of work in dracut to
reduce the memory requirements in dracut, for example only add dump
required kernel modules in 2nd kernel initramfs, also we have a lot of
other twicks for dracut to use "hostonly" mode, eg. hostonly multipath
configurations will just bring up necessary paths instead of creating
all of the multipath devices.

> 
> What we've been trying to do in Ubuntu/Debian is using an estimator
> approach [0] - this is purely userspace and tries to infer the amount
> of necessary memory a kdump minimal[1] kernel would take. I'm not
> -1'ing your approach totally, but I think a bit more consideration is
> needed in the ranges, at least accounting the number of devices of the
> machine or something like that.

There are definitely room to improve and make it better in the future,
but I think this is a good start and simple enough proposal for the time
being :)

> 
> Cheers,
> 
> 
> Guilherme
> 
> [0] https://salsa.debian.org/debian/makedumpfile/-/merge_requests/7
> [1] Minimal as having a reduced initrd + "shrinking" parameters (like
> nr_cpus=1).
> 

Thanks
Dave

