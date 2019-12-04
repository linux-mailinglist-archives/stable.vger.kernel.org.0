Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B04B1122B4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 07:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfLDGBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 01:01:01 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:43470 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfLDGBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 01:01:01 -0500
Received: by mail-pj1-f65.google.com with SMTP id g4so2518095pjs.10
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 22:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RdPm1aE5nkSm/tNOmWvHENkEA77h8ntvYrufdn+0eNo=;
        b=BEqUItQW7izDeC4rVSgqxyItC6oyjov+2GBxY0Z4/fPccZJwkdiuDrbq7v7ml0j8/j
         2MtA0+3pO2qs7byaG0RXzV/Em+kF7dPf6FjiDrViVzTR7E+2HgqtbGSjgko1aGfQtLwv
         y8wKnB7W1/C6mCx9gYzH6DXBW/OuDfUnjNt+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RdPm1aE5nkSm/tNOmWvHENkEA77h8ntvYrufdn+0eNo=;
        b=M3mrmABoTE/jdgu9vCVhVAetjrHO3Or8VJulrftF00pWyelMZr6zXuaCd0Tz+qBT4M
         Qr4eVb++Dv7f8E0pKtTYGkuG7XidxEVexZKnYQDuKAsUkx3UHTiExIKimWVhIvyHSAfm
         bzyVBDivcIpuGQMegsRm9clxS9Dl+6N+8T7tiG5zL5laXiHOLOaiIABzqNNgg50eNafi
         fivxnwcf5frEPl8PsvK9WIA/qxn4IVR0c5WKvmzeshHdtFtyoi1nRacm61xBnmZm0aAV
         4rqRURGDFqALuMYfyoP2VnvHb7kS9UAcMSoPG/w0x4mdOPWoD1iT9z+KVn092ZSbM5RQ
         Sq3Q==
X-Gm-Message-State: APjAAAUBQh0V7GlFn0J79vZOut//AZsc2p9sTZrrHWLUcvyzEed1WvGL
        LLsazwF1IC5YLrAiPS/jXagl+mBKn28=
X-Google-Smtp-Source: APXvYqyft7oXGFxXGWSJJh4Bo8kU9wwu8F8dOFIf8lnCrWkN2/ND1itdzMr4y5qv1bl5xi4jroG4KA==
X-Received: by 2002:a17:902:8d98:: with SMTP id v24mr1761700plo.329.1575439260491;
        Tue, 03 Dec 2019 22:01:00 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7daa-d2ea-7edb-cfe8.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7daa:d2ea:7edb:cfe8])
        by smtp.gmail.com with ESMTPSA id e1sm6286147pfl.98.2019.12.03.22.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 22:00:59 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     lvivier@redhat.com, Greg Kurz <groug@kaod.org>,
        stable@vger.kernel.org,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] powerpc/xive: skip ioremap() of ESB pages for LSI interrupts
In-Reply-To: <20191203163642.2428-1-clg@kaod.org>
References: <20191203163642.2428-1-clg@kaod.org>
Date:   Wed, 04 Dec 2019 17:00:55 +1100
Message-ID: <87v9qweijs.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

C=C3=A9dric Le Goater <clg@kaod.org> writes:

> The PCI INTx interrupts and other LSI interrupts are handled differently
> under a sPAPR platform. When the interrupt source characteristics are
> queried, the hypervisor returns an H_INT_ESB flag to inform the OS
> that it should be using the H_INT_ESB hcall for interrupt management
> and not loads and stores on the interrupt ESB pages.
>
> A default -1 value is returned for the addresses of the ESB pages. The
> driver ignores this condition today and performs a bogus IO mapping.
> Recent changes and the DEBUG_VM configuration option make the bug
> visible with :
>
> [    0.015518] kernel BUG at arch/powerpc/include/asm/book3s/64/pgtable.h=
:612!
> [    0.015578] Oops: Exception in kernel mode, sig: 5 [#1]
> [    0.015627] LE PAGE_SIZE=3D64K MMU=3DRadix MMU=3DHash SMP NR_CPUS=3D10=
24 NUMA pSeries
> [    0.015697] Modules linked in:
> [    0.015739] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-0.rc6.git0=
.1.fc32.ppc64le #1
> [    0.015812] NIP:  c000000000f63294 LR: c000000000f62e44 CTR: 000000000=
0000000
> [    0.015889] REGS: c0000000fa45f0d0 TRAP: 0700   Not tainted  (5.4.0-0.=
rc6.git0.1.fc32.ppc64le)
> [    0.015971] MSR:  8000000002029033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 440=
00424  XER: 00000000
> [    0.016050] CFAR: c000000000f63128 IRQMASK: 0
> [    0.016050] GPR00: c000000000f62e44 c0000000fa45f360 c000000001be5400 =
0000000000000000
> [    0.016050] GPR04: c0000000019c7d38 c0000000fa340030 00000000fa330009 =
c000000001c15e18
> [    0.016050] GPR08: 0000000000000040 ffe0000000000000 0000000000000000 =
8418dd352dbd190f
> [    0.016050] GPR12: 0000000000000000 c000000001e00000 c00a000080060000 =
c00a000080060000
> [    0.016050] GPR16: 0000ffffffffffff 80000000000001ae c000000001c24d98 =
ffffffffffff0000
> [    0.016050] GPR20: c00a00008007ffff c000000001cafca0 c00a00008007ffff =
ffffffffffff0000
> [    0.016050] GPR24: c00a000080080000 c00a000080080000 c000000001cafca8 =
c00a000080080000
> [    0.016050] GPR28: c0000000fa32e010 c00a000080060000 ffffffffffff0000 =
c0000000fa330000
> [    0.016711] NIP [c000000000f63294] ioremap_page_range+0x4c4/0x6e0
> [    0.016778] LR [c000000000f62e44] ioremap_page_range+0x74/0x6e0
> [    0.016846] Call Trace:
> [    0.016876] [c0000000fa45f360] [c000000000f62e44] ioremap_page_range+0=
x74/0x6e0 (unreliable)
> [    0.016969] [c0000000fa45f460] [c0000000000934bc] do_ioremap+0x8c/0x120
> [    0.017037] [c0000000fa45f4b0] [c0000000000938e8] __ioremap_caller+0x1=
28/0x140
> [    0.017116] [c0000000fa45f500] [c0000000000931a0] ioremap+0x30/0x50
> [    0.017184] [c0000000fa45f520] [c0000000000d1380] xive_spapr_populate_=
irq_data+0x170/0x260
> [    0.017263] [c0000000fa45f5c0] [c0000000000cc90c] xive_irq_domain_map+=
0x8c/0x170
> [    0.017344] [c0000000fa45f600] [c000000000219124] irq_domain_associate=
+0xb4/0x2d0
> [    0.017424] [c0000000fa45f690] [c000000000219fe0] irq_create_mapping+0=
x1e0/0x3b0
> [    0.017506] [c0000000fa45f730] [c00000000021ad6c] irq_create_fwspec_ma=
pping+0x27c/0x3e0
> [    0.017586] [c0000000fa45f7c0] [c00000000021af68] irq_create_of_mappin=
g+0x98/0xb0
> [    0.017666] [c0000000fa45f830] [c0000000008d4e48] of_irq_parse_and_map=
_pci+0x168/0x230
> [    0.017746] [c0000000fa45f910] [c000000000075428] pcibios_setup_device=
+0x88/0x250
> [    0.017826] [c0000000fa45f9a0] [c000000000077b84] pcibios_setup_bus_de=
vices+0x54/0x100
> [    0.017906] [c0000000fa45fa10] [c0000000000793f0] __of_scan_bus+0x160/=
0x310
> [    0.017973] [c0000000fa45faf0] [c000000000075fc0] pcibios_scan_phb+0x3=
30/0x390
> [    0.018054] [c0000000fa45fba0] [c00000000139217c] pcibios_init+0x8c/0x=
128
> [    0.018121] [c0000000fa45fc20] [c0000000000107b0] do_one_initcall+0x60=
/0x2c0
> [    0.018201] [c0000000fa45fcf0] [c000000001384624] kernel_init_freeable=
+0x290/0x378
> [    0.018280] [c0000000fa45fdb0] [c000000000010d24] kernel_init+0x2c/0x1=
48
> [    0.018348] [c0000000fa45fe20] [c00000000000bdbc] ret_from_kernel_thre=
ad+0x5c/0x80
> [    0.018427] Instruction dump:
> [    0.018468] 41820014 3920fe7f 7d494838 7d290074 7929d182 f8e10038 6929=
0001 0b090000
> [    0.018552] 7a098420 0b090000 7bc95960 7929a802 <0b090000> 7fc68b78 e8=
610048 7dc47378

I hit this too, and your patch works for me. I can't claim to understand
it, but I can verify it! :)

Tested-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel
>
> Cc: stable@vger.kernel.org # v4.14+
> Fixes: bed81ee181dd ("powerpc/xive: introduce H_INT_ESB hcall")
> Signed-off-by: C=C3=A9dric Le Goater <clg@kaod.org>
> ---
>  arch/powerpc/sysdev/xive/spapr.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/=
spapr.c
> index 33c10749edec..55dc61cb4867 100644
> --- a/arch/powerpc/sysdev/xive/spapr.c
> +++ b/arch/powerpc/sysdev/xive/spapr.c
> @@ -392,20 +392,28 @@ static int xive_spapr_populate_irq_data(u32 hw_irq,=
 struct xive_irq_data *data)
>  	data->esb_shift =3D esb_shift;
>  	data->trig_page =3D trig_page;
>=20=20
> +	data->hw_irq =3D hw_irq;
> +
>  	/*
>  	 * No chip-id for the sPAPR backend. This has an impact how we
>  	 * pick a target. See xive_pick_irq_target().
>  	 */
>  	data->src_chip =3D XIVE_INVALID_CHIP_ID;
>=20=20
> +	/*
> +	 * When the H_INT_ESB flag is set, the H_INT_ESB hcall should
> +	 * be used for interrupt management. Skip the remapping of the
> +	 * ESB pages which are not available.
> +	 */
> +	if (data->flags & XIVE_IRQ_FLAG_H_INT_ESB)
> +		return 0;
> +
>  	data->eoi_mmio =3D ioremap(data->eoi_page, 1u << data->esb_shift);
>  	if (!data->eoi_mmio) {
>  		pr_err("Failed to map EOI page for irq 0x%x\n", hw_irq);
>  		return -ENOMEM;
>  	}
>=20=20
> -	data->hw_irq =3D hw_irq;
> -
>  	/* Full function page supports trigger */
>  	if (flags & XIVE_SRC_TRIGGER) {
>  		data->trig_mmio =3D data->eoi_mmio;
> --=20
> 2.21.0
