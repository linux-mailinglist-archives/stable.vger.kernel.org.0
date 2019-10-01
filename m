Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0833C38A8
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 17:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388277AbfJAPNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 11:13:25 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36252 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfJAPNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 11:13:25 -0400
Received: by mail-ed1-f65.google.com with SMTP id h2so12277732edn.3;
        Tue, 01 Oct 2019 08:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=N2FlzG+PxQCjT3jm2D3Aa1IldYkDzjEnGNfZ4YLjVII=;
        b=GTLlE36emsyfwlCmg5/qd+JCYVMMKgASzsy4gmL+XPeskYqSSSuJISrQ3A6dDD7t+9
         F+V7XPh7bQttfJku/JHEpVwBQdsQQK174lSegpomZrTGIBleXS809G6+RrucB2/3PzNO
         cCYYCOnMZsOQT9+5ORElE7x4qrE9o8Bn37g1s63AU426pysTPJUrGDbwBlITeZVQer3j
         FYTPzJ90dbeNq4eySZ/SgEs+CBE5/r0k9F77oFU1jHeGvMYp5Vw+93okzSpvVVdLJPPU
         7VcncYpfqwPxiELEb/1orqM2ZE866YdWQhnd4MEt4FXsly+RE1c4W6iJvHb7xo7D7/JR
         1ToA==
X-Gm-Message-State: APjAAAUN0a3/RbdDZc9uQhr0wn9Sq3kAP9A7+8fUdt5/EMCoCjUzo1gd
        87ZBNk48IMxh1PLYBoO+8TA=
X-Google-Smtp-Source: APXvYqxyVJmic1F+7fZfFZQAxNcXMB5Z/ocNdDnPHOVjj8h1tH2nOU0MyL/PgaJMMnw3AF2+JFzzgw==
X-Received: by 2002:a17:906:7802:: with SMTP id u2mr15475439ejm.3.1569942803627;
        Tue, 01 Oct 2019 08:13:23 -0700 (PDT)
Received: from [10.10.2.174] (bran.ispras.ru. [83.149.199.196])
        by smtp.gmail.com with ESMTPSA id gl4sm1878601ejb.6.2019.10.01.08.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:13:23 -0700 (PDT)
Reply-To: efremov@linux.com
Subject: Re: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
To:     David Laight <David.Laight@ACULAB.COM>,
        'Dan Carpenter' <dan.carpenter@oracle.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <20190930110141.29271-1-efremov@linux.com>
 <37b195b700394e95aa8329afc9f60431@AcuMS.aculab.com>
 <e4051dcb-10dc-ff17-ec0b-6f51dccdb5bf@linux.com>
 <20191001135649.GH22609@kadam>
 <8d2e8196cae74ec4ae20e9c23e898207@AcuMS.aculab.com>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <a7c002f7-c6f2-a9ed-0100-acfbafea65c5@linux.com>
Date:   Tue, 1 Oct 2019 18:13:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <8d2e8196cae74ec4ae20e9c23e898207@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/1/19 5:36 PM, David Laight wrote:
>> From: Dan Carpenter
>> Sent: 01 October 2019 14:57
>> Subject: Re: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
> ...
>> That's true for glibc memcpy() but not for the kernel memcpy().  In the
>> kernel there are lots of places which do a zero size memcpy().
> 
> And probably from NULL (or even garbage) pointers.
> 
> After all a pointer to the end of an array (a + ARRAY_SIZE(a)) is valid
> but must not be dereferenced - so memcpy() can't dereference it's
> source address when the length is zero.
> 
>> The glibc attitude is "the standard allows us to put knives here" so
>> let's put knives everywhere in the path.  And the GCC attitude is let's
>> silently remove NULL checks instead of just printing a warning that the
>> NULL check isn't required...  It could really make someone despondent.
> 
> gcc is the one that add knives...
> 

Just found an official documentation to this issue:
https://gcc.gnu.org/gcc-4.9/porting_to.html
"Null pointer checks may be optimized away more aggressively
...
The pointers passed to memmove (and similar functions in <string.h>) must be non-null
even when nbytes==0, so GCC can use that information to remove the check after the
memmove call. Calling copy(p, NULL, 0) can therefore deference a null pointer and crash."

But again, I would say that the bug in this code is because the if condition was copy-pasted
and it should be inverted.

Thanks,
Denis
