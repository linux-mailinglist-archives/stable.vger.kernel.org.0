Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403AC34EA43
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 16:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhC3OWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 10:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbhC3OWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 10:22:22 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEE68C061574;
        Tue, 30 Mar 2021 07:22:21 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 4118D92009C; Tue, 30 Mar 2021 16:22:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 3571492009B;
        Tue, 30 Mar 2021 16:22:19 +0200 (CEST)
Date:   Tue, 30 Mar 2021 16:22:19 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     YunQiang Su <wzssyqa@gmail.com>,
        YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v9] MIPS: force use FR=0 for FPXX binaries
In-Reply-To: <20210330122437.GA10355@alpha.franken.de>
Message-ID: <alpine.DEB.2.21.2103301559190.18977@angie.orcam.me.uk>
References: <20210322015902.18451-1-yunqiang.su@cipunited.com> <CAKcpw6UPQFOt2DyY9EbKxziWyJXOsUwcf4khrAyFC=yTX1EuAg@mail.gmail.com> <20210329090058.GA6564@alpha.franken.de> <CAKcpw6Vd6pCT2PB4pZATnEq8Y4pSj4cwNFZgg6yK6VjoeY+N-Q@mail.gmail.com>
 <20210330122437.GA10355@alpha.franken.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 30 Mar 2021, Thomas Bogendoerfer wrote:

> I want a single go binary, which I can inspect about the FPXX thing and
> see how easy it would be to just patch the binary and make it run without
> this patch.

 I have experimented with this a bit and unfortunately a command like:

$ objcopy --remove-section=.MIPS.abiflags go go-noabiflags

will indeed remove the MIPS ABI Flags section, but will leave an empty 
ABIFLAGS segment behind:

  ABIFLAGS       0x000000 0x00400248 0x00000000 0x00000 0x00000 R   0x4

which the kernel will choke on in `arch_elf_pt_proc':

		if (phdr32->p_filesz < sizeof(abiflags))
			return -EINVAL;

or:

		if (phdr64->p_filesz < sizeof(abiflags))
			return -EINVAL;

which I think is another implementation bug; I think we should silently 
ignore an empty segment like say `readelf -A' does, that is:

		if (!phdr32->p_filesz)
			return 0;

etc.  Sadly there's no option for `objcopy' to explicitly handle segments 
anyhow including to remove empty ones.

 There's the `--update-section' section option for `objcopy' that should 
work, but it requires more effort as an image of a patched .MIPS.abiflags 
section is required (still doable).

  Maciej
