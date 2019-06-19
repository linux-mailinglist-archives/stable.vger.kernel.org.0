Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6ED4AFB2
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 03:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFSBvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 21:51:47 -0400
Received: from mail-eopbgr100106.outbound.protection.outlook.com ([40.107.10.106]:36969
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfFSBvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 21:51:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDsoCLbOhHFdXN7drZHBCR3qOvxiZOIwLCcdZPCVsUE=;
 b=Ju8e4Que1N8rxOl3HYYfUD73pmoVEAgC/PFx/eK8DYuHr6RArXn1ZwldZsp2eZ2vMLOoEvLE8k99qwU1W70WGMzuldDtLt6nhxLbKE2EU2w9dFcLOKmg5Mo/eZUzyrMPEBU47d3VWXyCzlewz21wgJhTG5DfL0n4igg0IYZU50w=
Received: from LO2P265MB0847.GBRP265.PROD.OUTLOOK.COM (20.176.139.20) by
 LO2P265MB0334.GBRP265.PROD.OUTLOOK.COM (10.166.98.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 19 Jun 2019 01:51:43 +0000
Received: from LO2P265MB0847.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c4af:389:2951:fdd1]) by LO2P265MB0847.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c4af:389:2951:fdd1%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 01:51:43 +0000
From:   Gary Guo <gary@garyguo.net>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        ShihPo Hung <shihpo.hung@sifive.com>
CC:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] riscv: mm: synchronize MMU after pte change
Thread-Topic: [PATCH v2] riscv: mm: synchronize MMU after pte change
Thread-Index: AQHVJMTbnSKBLobc0UyHqyY4rraZbaafpnuAgAKRjBA=
Date:   Wed, 19 Jun 2019 01:51:43 +0000
Message-ID: <LO2P265MB08472C6BF2C5DA5459744756D6E50@LO2P265MB0847.GBRP265.PROD.OUTLOOK.COM>
References: <CALoQrwdLANaOaYiGvFxt23PBdHcgcc_LWVFORNwrAXWBhOyJsA@mail.gmail.com>
 <alpine.DEB.2.21.9999.1906170328330.19994@viisi.sifive.com>
In-Reply-To: <alpine.DEB.2.21.9999.1906170328330.19994@viisi.sifive.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gary@garyguo.net; 
x-originating-ip: [2001:470:6972:501:103f:fc42:2dce:8cd9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f64bcde-ed57-4e37-b72c-08d6f458ae40
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:LO2P265MB0334;
x-ms-traffictypediagnostic: LO2P265MB0334:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <LO2P265MB03340F03BBBF2E3B7516E1EFD6E50@LO2P265MB0334.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39830400003)(366004)(376002)(346002)(13464003)(189003)(199004)(446003)(486006)(7736002)(9686003)(305945005)(8676002)(7696005)(81156014)(81166006)(5660300002)(966005)(73956011)(74316002)(54906003)(76176011)(99286004)(316002)(68736007)(6116002)(66476007)(11346002)(476003)(14454004)(25786009)(66446008)(66556008)(52536014)(2906002)(71200400001)(64756008)(6246003)(71190400001)(110136005)(186003)(229853002)(86362001)(6306002)(76116006)(8936002)(508600001)(66946007)(46003)(102836004)(53936002)(6506007)(4326008)(53546011)(256004)(6436002)(33656002)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:LO2P265MB0334;H:LO2P265MB0847.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: garyguo.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JrQnksefTgMx7V09WLGDC5h6Uosu70VdIlmImQz30F6fYr2v0DfkCWhw3pxhzEkHk+HFBp5KyulJ3ZZit0KZysg0PzRhAhVIf8r7WkIwr9QdPaycEEqNg2lpHLovb9fAuDOeurmlAfhOWVWPeuuvXow1AE7JKdNx/LjTpAP/CG/v4+aTZv7PYuGsBx+OhuUdIUosJ4eLcF+c2XzRrg4ltMvWNOovDhoRpRHyyw6fi+rjm0YBnPAOHva82wNtxgk5fN3JWnxBnG4mBtVWEcOz0HKj9+XnVssLofN73KsC8AAOTZ87cUDIvd+6weEs07ZR5gTITeCciG3ydTYfu/ToqlhNIkDQjJOtAluVmIW4jAkc8QfzKErJA2mgZMSjJHEhXRu90y7ZiHXTionWb3OvbodQyu7a19aqF27FNSJJm88=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f64bcde-ed57-4e37-b72c-08d6f458ae40
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 01:51:43.6610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gary@garyguo.net
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB0334
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I don't think it is sensible that any hardware would actually cache invalid=
 entries.
From my research https://arxiv.org/pdf/1905.06825 (will appear in CARRV 201=
9), existing Linux code already emits too many SFENCE.VMAs (94% of all flus=
hes) that are completely unnecessary for a hardware that does not cache inv=
alid entries. Adding a couple of more would definitely not good, considerin=
g that TLB flush could be expensive for some microarchitectures.

I think the spec should be fixed, recommending against invalid entries to b=
e cached, and then we can do things similar to other architectures, i.e. us=
e flush_tlb_fix_spurious_fault instead.

> -----Original Message-----
> From: linux-riscv <linux-riscv-bounces@lists.infradead.org> On Behalf Of =
Paul
> Walmsley
> Sent: Monday, June 17, 2019 11:33
> To: ShihPo Hung <shihpo.hung@sifive.com>
> Cc: linux-riscv@lists.infradead.org; Palmer Dabbelt <palmer@sifive.com>; =
Albert
> Ou <aou@eecs.berkeley.edu>; stable@vger.kernel.org
> Subject: Re: [PATCH v2] riscv: mm: synchronize MMU after pte change
>=20
> Hi ShihPo,
>=20
> On Mon, 17 Jun 2019, ShihPo Hung wrote:
>=20
> > Because RISC-V compliant implementations can cache invalid entries
> > in TLB, an SFENCE.VMA is necessary after changes to the page table.
> > This patch adds an SFENCE.vma for the vmalloc_fault path.
> >
> > Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
> > Cc: Palmer Dabbelt <palmer@sifive.com>
> > Cc: Albert Ou <aou@eecs.berkeley.edu>
> > Cc: Paul Walmsley <paul.walmsley@sifive.com>
> > Cc: linux-riscv@lists.infradead.org
> > Cc: stable@vger.kernel.org
>=20
> Looks like something in your patch flow converted tabs to whitespace, so
> the patch doesn't apply.  Then, with the tabs fixed, the comment text
> exceeds 80 columns.
>=20
> I've fixed those issues by hand for this patch (revised patch below, as
> queued for v5.2-rc), but could you please fix these issues for future
> patches?  Running checkpatch.pl --strict should help identify these issue=
s
> before posting.
>=20
>=20
> thanks,
>=20
> - Paul
>=20
>=20
> From: ShihPo Hung <shihpo.hung@sifive.com>
> Date: Mon, 17 Jun 2019 12:26:17 +0800
> Subject: [PATCH] [PATCH v2] riscv: mm: synchronize MMU after pte change
>=20
> Because RISC-V compliant implementations can cache invalid entries
> in TLB, an SFENCE.VMA is necessary after changes to the page table.
> This patch adds an SFENCE.vma for the vmalloc_fault path.
>=20
> Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
> [paul.walmsley@sifive.com: reversed tab->whitespace conversion,
>  wrapped comment lines]
> Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@sifive.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: linux-riscv@lists.infradead.org
> Cc: stable@vger.kernel.org
> ---
>  arch/riscv/mm/fault.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
> index cec8be9e2d6a..5b72e60c5a6b 100644
> --- a/arch/riscv/mm/fault.c
> +++ b/arch/riscv/mm/fault.c
> @@ -29,6 +29,7 @@
>=20
>  #include <asm/pgalloc.h>
>  #include <asm/ptrace.h>
> +#include <asm/tlbflush.h>
>=20
>  /*
>   * This routine handles page faults.  It determines the address and the
> @@ -278,6 +279,18 @@ asmlinkage void do_page_fault(struct pt_regs *regs)
>  		pte_k =3D pte_offset_kernel(pmd_k, addr);
>  		if (!pte_present(*pte_k))
>  			goto no_context;
> +
> +		/*
> +		 * The kernel assumes that TLBs don't cache invalid
> +		 * entries, but in RISC-V, SFENCE.VMA specifies an
> +		 * ordering constraint, not a cache flush; it is
> +		 * necessary even after writing invalid entries.
> +		 * Relying on flush_tlb_fix_spurious_fault would
> +		 * suffice, but the extra traps reduce
> +		 * performance. So, eagerly SFENCE.VMA.
> +		 */
> +		local_flush_tlb_page(addr);
> +
>  		return;
>  	}
>  }
> --
> 2.20.1
>=20
>=20
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
