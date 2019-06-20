Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617074CD65
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 14:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfFTMHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 08:07:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45783 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfFTMHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 08:07:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so2729973wre.12;
        Thu, 20 Jun 2019 05:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fWInJZV9G+ALRJgF96UsSfEQo+Nr0jEpCwgfg6RpTMM=;
        b=SGfxMA/auQHLkjCgvzy0/rjhdXFIiOZlY0xzr+gfOk7tLshPSeHj+jIxIolAyT+jFv
         +r5X8Fj1S8DUeDW3+IUPVrXwprGK+agASiHedUIulI23OiGdiYeM7b4/xy7KBuDLEHAo
         /84H+i9fvFy6V20/mfV09aqD+TUxjXwSSTWQsNXUatr+YDfLPEQRzHBhngxQCJLG8uOS
         hUMaPFT2jnr+BqLVCC6rP9xApL7IG4fLUP16mQwnF+9FxqVvICkBroWrNZJJjPx8dzVe
         s0vTiPb2IIC29pKLCKcxEnK+7PvS9Hn8PtrJjxWUmtTmrPnzaMZKgS9d8CFibgfoHf+O
         1zIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fWInJZV9G+ALRJgF96UsSfEQo+Nr0jEpCwgfg6RpTMM=;
        b=m3WAJYCSTeYuUVv1aWlvxoDRYFVW+AKvvOTbCpOqwAMQALtqoVQTw1xkkThF63opoy
         Wplo/xt6ytRbydzfk/gKBONwivsBoQyuzyfrusyuXW+EmOlzDEK8wcIB9L9foG5WkPR8
         P4dHFuZtpulGEbBTu2binRza6RSbJmCoB6htYS2amoc3qftQ7TNnG2wA+MBCJAe2IT30
         mzdth7MuntZrwNMrKiKwmDfTXPCmtV4l5JmFdIgMb6rlKjymHzg2ynuM4wZQ7J5O2/9f
         uvEwVA4z2Yn8EjqQ/bYowck+DX5uiAHeH4X4EAMBDq366X2ddvBux3QxR6+fu3L1aVXk
         I3Mg==
X-Gm-Message-State: APjAAAUFgeAyLqIbE30HUOq4eM7ler+K46Arzdny1shHofzkkDVXskUR
        v6JroaBVbhoVOyoHlaHOiNg=
X-Google-Smtp-Source: APXvYqxZpIVy6bGGEudPOi7E+EbbfkbsHbRt2Cm94Uu9vtNdWs+76OKBHhsGJF/igQA4KxOXjMAPRA==
X-Received: by 2002:adf:ebcd:: with SMTP id v13mr16823195wrn.263.1561032449986;
        Thu, 20 Jun 2019 05:07:29 -0700 (PDT)
Received: from debian64.daheim (pD9E29A96.dip0.t-ipconnect.de. [217.226.154.150])
        by smtp.gmail.com with ESMTPSA id y19sm6251145wmc.21.2019.06.20.05.07.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 05:07:28 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hdvqh-0001xc-SZ; Thu, 20 Jun 2019 14:07:27 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable <stable@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>
Subject: Re: crypto: crypto4xx - properly set IV after de- and encrypt breaks kernel 4.4
Date:   Thu, 20 Jun 2019 14:07:27 +0200
Message-ID: <4226536.PGTo7a8ESG@debian64>
In-Reply-To: <9d744c3b-d4ff-b84b-527b-fc050794499b@hauke-m.de>
References: <9d744c3b-d4ff-b84b-527b-fc050794499b@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday, June 20, 2019 11:36:50 AM CEST Hauke Mehrtens wrote:
> Hi,
> 
> The patch "crypto: crypto4xx - properly set IV after de- and encrypt"
> causes a compile error on kernel 4.4.

3.18 as well.
> 
> When I revert this commit it compiles for me again:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=e9a60ab1609a7d975922adad1bf9c46ac6954584
> 
> I do not have hardware to test if it is really working.

I have a few APM821XX. But please note drivers without

commit b66c685a482117d4e9ee987d252ca673689a5302
Author: Christian Lamparter <chunkeey@gmail.com>
Date:   Fri Dec 22 21:18:36 2017 +0100

    crypto: crypto4xx - support Revision B parts

don't work on those and I do have my doubts that 460EX
series (and older) would either. I also don't believe that
the inital driver as it was submitted would have worked.
From what I've seen in their SDK, they patched the testmgr
at the time to either disable tests or provided their own...
so, might as well revert these patches for 4.4 and 3.18.

Because...
 
> drivers/crypto/amcc/crypto4xx_core.c: In function
> 'crypto4xx_ablkcipher_done':
> drivers/crypto/amcc/crypto4xx_core.c:649:21: warning: dereferencing
> 'void *' pointer
>   if (pd_uinfo->sa_va->sa_command_0.bf.save_iv == SA_SAVE_IV) {

This would probably need 
9e0a0b3a1 ("crypto: crypto4xx - pointer arithmetic overhaul") which is
a big patch.

>                      ^
> drivers/crypto/amcc/crypto4xx_core.c:649:21: error: request for member
> 'sa_command_0' in something not a structure or union
> drivers/crypto/amcc/crypto4xx_core.c:650:38: error: implicit declaration
> of function 'crypto_skcipher_reqtfm' [-Werror=implicit-function-declaration]
>    struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
>                                       ^
This would require adding #include <crypto/skcipher.h> to crypto4xx_core.c

The patch that added it upstream was 
ce05ffe10457 ("crypto: crypto4xx - convert to skcipher")

But this is more than just a one-liner.

> drivers/crypto/amcc/crypto4xx_core.c:650:61: error: 'req' undeclared
> (first use in this function)
>    struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
>                                                              ^
> drivers/crypto/amcc/crypto4xx_core.c:650:61: note: each undeclared
> identifier is reported only once for each function it appears in
see "#include <crypto/skcipher.h>"

> drivers/crypto/amcc/crypto4xx_core.c:652:3: error: implicit declaration
> of function 'crypto4xx_memcpy_from_le32'
> [-Werror=implicit-function-declaration]
>    crypto4xx_memcpy_from_le32((u32 *)req->iv,
>    ^

crypto4xx_memcpy_from_le32 is from
4865b122d4af ("crypto: crypto4xx - use the correct LE32 format for IV and key defs")

I think crypto4xx_memcpy_le() could work in this place.
But again I do have my doubts that the device works
without said patch.

> drivers/crypto/amcc/crypto4xx_core.c:653:19: warning: dereferencing
> 'void *' pointer
>     pd_uinfo->sr_va->save_iv,
>                    ^
> drivers/crypto/amcc/crypto4xx_core.c:653:19: error: request for member
> 'save_iv' in something not a structure or union
See "crypto: crypto4xx - pointer arithmetic overhaul".
> drivers/crypto/amcc/crypto4xx_core.c:654:4: error: implicit declaration
> of function 'crypto_skcipher_ivsize' [-Werror=implicit-function-declaration]
>     crypto_skcipher_ivsize(skcipher));
>     ^

see "#include <crypto/skcipher.h>"

(Yeaah, there seems to be a limit of what automatic cherry-picking of
patches can do :( )



