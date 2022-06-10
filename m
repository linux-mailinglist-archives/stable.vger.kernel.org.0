Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35E754666F
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 14:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348795AbiFJMSN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 10 Jun 2022 08:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348837AbiFJMSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 08:18:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9F6E2732D6
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 05:18:08 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-317-aDi4xA9AOVCCz2X-8OmFHQ-1; Fri, 10 Jun 2022 13:18:05 +0100
X-MC-Unique: aDi4xA9AOVCCz2X-8OmFHQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 10 Jun 2022 13:18:03 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 10 Jun 2022 13:18:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Lobakin' <alexandr.lobakin@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yury Norov <yury.norov@gmail.com>
CC:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matt Turner <mattst88@gmail.com>,
        Brian Cain <bcain@quicinc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yoshinori Sato" <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Marco Elver <elver@google.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-m68k@lists.linux-m68k.org" <linux-m68k@lists.linux-m68k.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: RE: [PATCH v2 1/6] ia64, processor: fix -Wincompatible-pointer-types
 in ia64_get_irr()
Thread-Topic: [PATCH v2 1/6] ia64, processor: fix -Wincompatible-pointer-types
 in ia64_get_irr()
Thread-Index: AQHYfL5z40oI9Qjgz0qz+n7lpkip7a1Ijjiw
Date:   Fri, 10 Jun 2022 12:18:03 +0000
Message-ID: <8711f7d6bdc148bd916d87515e71b3c2@AcuMS.aculab.com>
References: <20220610113427.908751-1-alexandr.lobakin@intel.com>
 <20220610113427.908751-2-alexandr.lobakin@intel.com>
In-Reply-To: <20220610113427.908751-2-alexandr.lobakin@intel.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin
> Sent: 10 June 2022 12:34
> 
> test_bit(), as any other bitmap op, takes `unsigned long *` as a
> second argument (pointer to the actual bitmap), as any bitmap
> itself is an array of unsigned longs. However, the ia64_get_irr()
> code passes a ref to `u64` as a second argument.
> This works with the ia64 bitops implementation due to that they
> have `void *` as the second argument and then cast it later on.
> This works with the bitmap API itself due to that `unsigned long`
> has the same size on ia64 as `u64` (`unsigned long long`), but
> from the compiler PoV those two are different.
> Define @irr as `unsigned long` to fix that. That implies no
> functional changes. Has been hidden for 16 years!

Wouldn't it be better to just test the bit?
As in:
	return irr & (1ull << bit);

    David

> 
> Fixes: a58786917ce2 ("[IA64] avoid broken SAL_CACHE_FLUSH implementations")
> Cc: stable@vger.kernel.org # 2.6.16+
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  arch/ia64/include/asm/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
> index 7cbce290f4e5..757c2f6d8d4b 100644
> --- a/arch/ia64/include/asm/processor.h
> +++ b/arch/ia64/include/asm/processor.h
> @@ -538,7 +538,7 @@ ia64_get_irr(unsigned int vector)
>  {
>  	unsigned int reg = vector / 64;
>  	unsigned int bit = vector % 64;
> -	u64 irr;
> +	unsigned long irr;
> 
>  	switch (reg) {
>  	case 0: irr = ia64_getreg(_IA64_REG_CR_IRR0); break;
> --
> 2.36.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

