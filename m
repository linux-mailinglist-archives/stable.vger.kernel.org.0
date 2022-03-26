Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF6C4E8482
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 23:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiCZWSA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 26 Mar 2022 18:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiCZWRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 18:17:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38D672F004
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 15:16:09 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-221-RimintWePiOs3iKZRZSi5g-1; Sat, 26 Mar 2022 22:16:06 +0000
X-MC-Unique: RimintWePiOs3iKZRZSi5g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Sat, 26 Mar 2022 22:16:03 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Sat, 26 Mar 2022 22:16:03 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joerg Roedel' <joro@8bytes.org>, "x86@kernel.org" <x86@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] x86/sev: Unroll string mmio with
 CC_ATTR_GUEST_UNROLL_STRING_IO
Thread-Topic: [PATCH v3] x86/sev: Unroll string mmio with
 CC_ATTR_GUEST_UNROLL_STRING_IO
Thread-Index: AQHYQR+Ze4D1k2sivEGZy3Tw8cJv76zSOd1g
Date:   Sat, 26 Mar 2022 22:16:03 +0000
Message-ID: <b89b59753ee4439c8b9ea7413dab66c0@AcuMS.aculab.com>
References: <20220326144127.15967-1-joro@8bytes.org>
In-Reply-To: <20220326144127.15967-1-joro@8bytes.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <joro@8bytes.org>
> Sent: 26 March 2022 14:41
> 
> The io specific memcpy/memset functions use string mmio accesses to do
> their work. Under SEV the hypervisor can't emulate these instructions,
> because they read/write directly from/to encrypted memory.
> 
> KVM will inject a page fault exception into the guest when it is asked
> to emulate string mmio instructions for an SEV guest:
> 
> 	BUG: unable to handle page fault for address: ffffc90000065068
> 	#PF: supervisor read access in kernel mode
> 	#PF: error_code(0x0000) - not-present page
> 	PGD 8000100000067 P4D 8000100000067 PUD 80001000fb067 PMD 80001000fc067 PTE 80000000fed40173
> 	Oops: 0000 [#1] PREEMPT SMP NOPTI
> 	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc7 #3
> 
> As string mmio for an SEV guest can not be supported by the
> hypervisor, unroll the instructions for CC_ATTR_GUEST_UNROLL_STRING_IO
> enabled kernels.
> 
> This issue appears when kernels are launched in recent libvirt-managed
> SEV virtual machines, because libvirt started to add a tpm-crb device
> to the guest by default.
> 
> The kernel driver for tpm-crb uses memcpy_to/from_io() functions to
> access MMIO memory, resulting in a page-fault injected by KVM and
> crashing the kernel at boot.
> 
> Cc: stable@vger.kernel.org #4.15+
> Fixes: d8aa7eea78a1 ('x86/mm: Add Secure Encrypted Virtualization (SEV) support')
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
> Changes v2->v3:
> 	- Fix sparse warnings introduced by v2
> 
>  arch/x86/lib/iomem.c | 65 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 57 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/lib/iomem.c b/arch/x86/lib/iomem.c
> index df50451d94ef..3e2f33fc33de 100644
> --- a/arch/x86/lib/iomem.c
> +++ b/arch/x86/lib/iomem.c
> @@ -22,7 +22,7 @@ static __always_inline void rep_movs(void *to, const void *from, size_t n)
>  		     : "memory");
>  }
> 
> -void memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
> +static void string_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
>  {
>  	if (unlikely(!n))
>  		return;
> @@ -38,9 +38,8 @@ void memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
>  	}
>  	rep_movs(to, (const void *)from, n);
>  }
> -EXPORT_SYMBOL(memcpy_fromio);
> 
> -void memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
> +static void string_memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
>  {
>  	if (unlikely(!n))
>  		return;
> @@ -56,14 +55,64 @@ void memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
>  	}
>  	rep_movs((void *)to, (const void *) from, n);
>  }
> +
> +static void unrolled_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
> +{
> +	const volatile char __iomem *in = from;
> +	char *out = to;
> +	int i;
> +
> +	for (i = 0; i < n; ++i)
> +		out[i] = readb(&in[i]);
> +}

Wait a minute....
Aren't these functions supposed to be doing 'memory' copies?
In which case they need to be using 64bit IO accesses where
appropriate - otherwise the performance is horrid.

I thought the x86 memcpy_to/from_io() had been changed to
always use a software loop rather than using whatever memcpy()
ended up using.
In particular the 'rep movsb' ERMS (EMRS?) copy that is fast
(on some cpu) for memory-memory copies is always a byte copy
on uncached locations typical for io addresses.

PIO reads from PCIe can be spectacularly slow.
You really do want to use the largest register available.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

