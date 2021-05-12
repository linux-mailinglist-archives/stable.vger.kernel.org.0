Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15D337B764
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhELIFs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 12 May 2021 04:05:48 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:32452 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELIFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:05:46 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-226-GJ3a8MFKOOuK1O-e4s34MQ-1; Wed, 12 May 2021 09:04:35 +0100
X-MC-Unique: GJ3a8MFKOOuK1O-e4s34MQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 12 May 2021 09:04:33 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Wed, 12 May 2021 09:04:33 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joerg Roedel' <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Hyunwook Baek <baekhw@google.com>
CC:     Joerg Roedel <jroedel@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Juergen Gross" <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
Thread-Topic: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
Thread-Index: AQHXRwQswpicLJM6a0eoGXhfP+3kQqrfe29g
Date:   Wed, 12 May 2021 08:04:33 +0000
Message-ID: <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
In-Reply-To: <20210512075445.18935-4-joro@8bytes.org>
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg
> Sent: 12 May 2021 08:55
> 
> From: Joerg Roedel <jroedel@suse.de>
> 
> The put_user() and get_user() functions do checks on the address which is
> passed to them. They check whether the address is actually a user-space
> address and whether its fine to access it. They also call might_fault()
> to indicate that they could fault and possibly sleep.
> 
> All of these checks are neither wanted nor required in the #VC exception
> handler, which can be invoked from almost any context and also for MMIO
> instructions from kernel space on kernel memory. All the #VC handler
> wants to know is whether a fault happened when the access was tried.
> 
> This is provided by __put_user()/__get_user(), which just do the access
> no matter what.

That can't be right at all.
__put/get_user() are only valid on user addresses and will try to
fault in a missing page - so can sleep.

At best this is abused the calls.

	David

> Fixes: f980f9c31a92 ("x86/sev-es: Compile early handler code into kernel image")
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 6530a844eb61..110b39345b40 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -342,22 +342,22 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
>  	switch (size) {
>  	case 1:
>  		memcpy(&d1, buf, 1);
> -		if (put_user(d1, target))
> +		if (__put_user(d1, target))
>  			goto fault;
>  		break;
>  	case 2:
>  		memcpy(&d2, buf, 2);
> -		if (put_user(d2, target))
> +		if (__put_user(d2, target))
>  			goto fault;
>  		break;
>  	case 4:
>  		memcpy(&d4, buf, 4);
> -		if (put_user(d4, target))
> +		if (__put_user(d4, target))
>  			goto fault;
>  		break;
>  	case 8:
>  		memcpy(&d8, buf, 8);
> -		if (put_user(d8, target))
> +		if (__put_user(d8, target))
>  			goto fault;
>  		break;
>  	default:
> @@ -396,22 +396,22 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
> 
>  	switch (size) {
>  	case 1:
> -		if (get_user(d1, s))
> +		if (__get_user(d1, s))
>  			goto fault;
>  		memcpy(buf, &d1, 1);
>  		break;
>  	case 2:
> -		if (get_user(d2, s))
> +		if (__get_user(d2, s))
>  			goto fault;
>  		memcpy(buf, &d2, 2);
>  		break;
>  	case 4:
> -		if (get_user(d4, s))
> +		if (__get_user(d4, s))
>  			goto fault;
>  		memcpy(buf, &d4, 4);
>  		break;
>  	case 8:
> -		if (get_user(d8, s))
> +		if (__get_user(d8, s))
>  			goto fault;
>  		memcpy(buf, &d8, 8);
>  		break;
> --
> 2.31.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

