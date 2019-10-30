Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360BAE98AE
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 10:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfJ3JCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 05:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfJ3JCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 05:02:20 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE7742083E;
        Wed, 30 Oct 2019 09:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572426138;
        bh=qDDn6Pqi5gdg0xPqXhf/M0A/TQfM681Mptbd731RAOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RC/Tpy5ZNRHF6PoKQHXz0uRgEcUe20OnXfZiM9/V4ayevaeTbGlZ8JzjHjG1AUlS9
         8O0uw5k1oePaQb9QFj44dStIAfTgZQ83ebpLqpPJvdiXGIC8qx6cNmVXubeg6p56xz
         FJykEcfDv0CQTfU91w/FA2gg0o47M6sP4JfcB294=
Date:   Wed, 30 Oct 2019 10:02:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Meng Zhuo <mengzhuo1203@gmail.com>, linux-mips@vger.kernel.org,
        Paul Burton <paul.burton@mips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 027/119] MIPS: elf_hwcap: Export userspace ASEs
Message-ID: <20191030090214.GA628862@kroah.com>
References: <20191027203259.948006506@linuxfoundation.org>
 <20191027203308.417745883@linuxfoundation.org>
 <c7cea5a0-bb68-b8ad-0548-6f246465a8b6@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7cea5a0-bb68-b8ad-0548-6f246465a8b6@flygoat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 06:50:38PM +0800, Jiaxun Yang wrote:
> 
> 在 2019/10/28 上午5:00, Greg Kroah-Hartman 写道:
> > From: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > 
> > [ Upstream commit 38dffe1e4dde1d3174fdce09d67370412843ebb5 ]
> > 
> > A Golang developer reported MIPS hwcap isn't reflecting instructions
> > that the processor actually supported so programs can't apply optimized
> > code at runtime.
> > 
> > Thus we export the ASEs that can be used in userspace programs.
> > 
> > Reported-by: Meng Zhuo <mengzhuo1203@gmail.com>
> > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > Cc: linux-mips@vger.kernel.org
> > Cc: Paul Burton <paul.burton@mips.com>
> > Cc: <stable@vger.kernel.org> # 4.14+
> > Signed-off-by: Paul Burton <paul.burton@mips.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   arch/mips/include/uapi/asm/hwcap.h | 11 ++++++++++
> >   arch/mips/kernel/cpu-probe.c       | 33 ++++++++++++++++++++++++++++++
> >   2 files changed, 44 insertions(+)
> > 
> > diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
> > index 600ad8fd68356..2475294c3d185 100644
> > --- a/arch/mips/include/uapi/asm/hwcap.h
> > +++ b/arch/mips/include/uapi/asm/hwcap.h
> > @@ -5,5 +5,16 @@
> >   /* HWCAP flags */
> >   #define HWCAP_MIPS_R6		(1 << 0)
> >   #define HWCAP_MIPS_MSA		(1 << 1)
> > +#define HWCAP_MIPS_MIPS16	(1 << 3)
> > +#define HWCAP_MIPS_MDMX     (1 << 4)
> > +#define HWCAP_MIPS_MIPS3D   (1 << 5)
> > +#define HWCAP_MIPS_SMARTMIPS (1 << 6)
> > +#define HWCAP_MIPS_DSP      (1 << 7)
> > +#define HWCAP_MIPS_DSP2     (1 << 8)
> > +#define HWCAP_MIPS_DSP3     (1 << 9)
> > +#define HWCAP_MIPS_MIPS16E2 (1 << 10)
> > +#define HWCAP_LOONGSON_MMI  (1 << 11)
> > +#define HWCAP_LOONGSON_EXT  (1 << 12)
> > +#define HWCAP_LOONGSON_EXT2 (1 << 13)
> >   #endif /* _UAPI_ASM_HWCAP_H */
> > diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> > index 3007ae1bb616a..c38cd62879f4e 100644
> > --- a/arch/mips/kernel/cpu-probe.c
> > +++ b/arch/mips/kernel/cpu-probe.c
> > @@ -2080,6 +2080,39 @@ void cpu_probe(void)
> >   		elf_hwcap |= HWCAP_MIPS_MSA;
> >   	}
> > +	if (cpu_has_mips16)
> > +		elf_hwcap |= HWCAP_MIPS_MIPS16;
> > +
> > +	if (cpu_has_mdmx)
> > +		elf_hwcap |= HWCAP_MIPS_MDMX;
> > +
> > +	if (cpu_has_mips3d)
> > +		elf_hwcap |= HWCAP_MIPS_MIPS3D;
> > +
> > +	if (cpu_has_smartmips)
> > +		elf_hwcap |= HWCAP_MIPS_SMARTMIPS;
> > +
> > +	if (cpu_has_dsp)
> > +		elf_hwcap |= HWCAP_MIPS_DSP;
> > +
> > +	if (cpu_has_dsp2)
> > +		elf_hwcap |= HWCAP_MIPS_DSP2;
> > +
> > +	if (cpu_has_dsp3)
> > +		elf_hwcap |= HWCAP_MIPS_DSP3;
> > +
> > +	if (cpu_has_loongson_mmi)
> > +		elf_hwcap |= HWCAP_LOONGSON_MMI;
> > +
> > +	if (cpu_has_loongson_mmi)
> > +		elf_hwcap |= HWCAP_LOONGSON_CAM;
> 
> Hi:
> 
> Sorry, there is a typo causing build failure.
> 
> Should be:

Can you resend this in a format we can apply it in?

thanks,

greg k-h
