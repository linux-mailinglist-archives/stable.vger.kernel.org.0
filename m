Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642561FEFE5
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 12:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgFRKsM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 18 Jun 2020 06:48:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:41126 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbgFRKsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 06:48:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-59-0qlN27EdMR2sxCfZfgQJ6g-1; Thu, 18 Jun 2020 11:48:06 +0100
X-MC-Unique: 0qlN27EdMR2sxCfZfgQJ6g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 18 Jun 2020 11:48:05 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 18 Jun 2020 11:48:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matt Fleming' <matt@codeblueprint.co.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Alexey Dobriyan <adobriyan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Kumar, Venkataramanan" <Venkataramanan.Kumar@amd.com>,
        Jan Kara <jack@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/asm/64: Align start of __clear_user() loop to
 16-bytes
Thread-Topic: [PATCH] x86/asm/64: Align start of __clear_user() loop to
 16-bytes
Thread-Index: AQHWRVoOsv5Rc5DeEUqSipuEjk3RuqjeLGsw
Date:   Thu, 18 Jun 2020 10:48:05 +0000
Message-ID: <39f8304b75094f87a54ace7732708d30@AcuMS.aculab.com>
References: <20200618102002.30034-1-matt@codeblueprint.co.uk>
In-Reply-To: <20200618102002.30034-1-matt@codeblueprint.co.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Fleming
> Sent: 18 June 2020 11:20
> x86 CPUs can suffer severe performance drops if a tight loop, such as
> the ones in __clear_user(), straddles a 16-byte instruction fetch
> window, or worse, a 64-byte cacheline. This issues was discovered in the
> SUSE kernel with the following commit,
> 
>   1153933703d9 ("x86/asm/64: Micro-optimize __clear_user() - Use immediate constants")
> 
> which increased the code object size from 10 bytes to 15 bytes and
> caused the 8-byte copy loop in __clear_user() to be split across a
> 64-byte cacheline.
> 
> Aligning the start of the loop to 16-bytes makes this fit neatly inside
> a single instruction fetch window again and restores the performance of
> __clear_user() which is used heavily when reading from /dev/zero.
> 
> Here are some numbers from running libmicro's read_z* and pread_z*
> microbenchmarks which read from /dev/zero:
> 
>   Zen 1 (Naples)
> 
>   libmicro-file
>                                         5.7.0-rc6              5.7.0-rc6              5.7.0-rc6
>                                                     revert-1153933703d9+               align16+
>   Time mean95-pread_z100k       9.9195 (   0.00%)      5.9856 (  39.66%)      5.9938 (  39.58%)
>   Time mean95-pread_z10k        1.1378 (   0.00%)      0.7450 (  34.52%)      0.7467 (  34.38%)
>   Time mean95-pread_z1k         0.2623 (   0.00%)      0.2251 (  14.18%)      0.2252 (  14.15%)
>   Time mean95-pread_zw100k      9.9974 (   0.00%)      6.0648 (  39.34%)      6.0756 (  39.23%)
>   Time mean95-read_z100k        9.8940 (   0.00%)      5.9885 (  39.47%)      5.9994 (  39.36%)
>   Time mean95-read_z10k         1.1394 (   0.00%)      0.7483 (  34.33%)      0.7482 (  34.33%)
> 
> Note that this doesn't affect Haswell or Broadwell microarchitectures
> which seem to avoid the alignment issue by executing the loop straight
> out of the Loop Stream Detector (verified using perf events).

Which cpu was affected?
At least one source (www.agner.org/optimize) implies that both ivy
bridge and sandy bridge have uop caches that mean (If I've read it
correctly) the loop shouldn't be affected by the alignment).

> diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
> index fff28c6f73a2..b0dfac3d3df7 100644
> --- a/arch/x86/lib/usercopy_64.c
> +++ b/arch/x86/lib/usercopy_64.c
> @@ -24,6 +24,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
>  	asm volatile(
>  		"	testq  %[size8],%[size8]\n"
>  		"	jz     4f\n"
> +		"	.align 16\n"
>  		"0:	movq $0,(%[dst])\n"
>  		"	addq   $8,%[dst]\n"
>  		"	decl %%ecx ; jnz   0b\n"

You can do better that that loop.
Change 'dst' to point to the end of the buffer, negate the count
and divide by 8 and you get:
		"0:	movq $0,($[dst],%%ecx,8)\n"
		"	add $1,%%ecx"
		"	jnz 0b\n"
which might run at one iteration per clock especially on cpu that pair
the add and jnz into a single uop.
(You need to use add not inc.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

