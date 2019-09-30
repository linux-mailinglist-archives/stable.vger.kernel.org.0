Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C081C248A
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 17:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732109AbfI3Pki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 11:40:38 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41357 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfI3Pkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 11:40:37 -0400
Received: by mail-ed1-f68.google.com with SMTP id f20so9046070edv.8;
        Mon, 30 Sep 2019 08:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=l0yUcGu9MFmSuUJVKJXvSt9KSqYrsEKkvHYxaWpAOwY=;
        b=rpLz+rzMghFUgoOVWXnxivpxW3THowbyFQoTQioNFNCbw3XUcYH1648liYK+CFK819
         kIGZr+rzhPApUU8WxT2bYBpKddAgCjcRf52UJFJy+WXvpEt00ZGfmvFo6WiqawFqcSyK
         NnqAdjwy2VU8cC21pK3DYxymumEeHF1LQjB7pktwWC5RFnImdZsd3/XVcXv5ivzsWxCI
         qpfEswjIQ4KFnOkEhrC1ZXDwDLyXRGxMX3IhTUetouZ8KpMXeZN4HeeD/+xvObk9xcZC
         bc5uiu/BXjzcS7Vc0C53en3mXgxjt3Em55vWMdAwzfu19e6y7SgMxuibYdmGD3zNkVN9
         XypA==
X-Gm-Message-State: APjAAAUkqw+/XgncaiI1LHIRoe/UdAUFrNvYVbx2KXo+eeP9BQ24B0c2
        WIv8o0XnQInXUqT9DGg7uEYN9RQh
X-Google-Smtp-Source: APXvYqyGk9jEUdaFH3KevIMNskTk1I0chh4w+dn+1QHkHkE06xOO0cPwtJ0brhNDj0onn++FITIqDg==
X-Received: by 2002:a50:f09d:: with SMTP id v29mr20047749edl.4.1569858036234;
        Mon, 30 Sep 2019 08:40:36 -0700 (PDT)
Received: from [10.10.2.174] (bran.ispras.ru. [83.149.199.196])
        by smtp.gmail.com with ESMTPSA id j5sm2513357edj.62.2019.09.30.08.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 08:40:35 -0700 (PDT)
Reply-To: efremov@linux.com
Subject: Re: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
To:     David Laight <David.Laight@ACULAB.COM>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20190930110141.29271-1-efremov@linux.com>
 <37b195b700394e95aa8329afc9f60431@AcuMS.aculab.com>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <b3a92ac3-b097-3359-8729-ad353fac2a0d@linux.com>
Date:   Mon, 30 Sep 2019 18:40:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <37b195b700394e95aa8329afc9f60431@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/30/19 4:18 PM, David Laight wrote:
> From: Denis Efremov
>> Sent: 30 September 2019 12:02
>> memcpy() in phy_ConfigBBWithParaFile() and PHY_ConfigRFWithParaFile() is
>> called with "src == NULL && len == 0". This is an undefined behavior.
> 
> I'm pretty certain it is well defined (to do nothing).
> 
>> Moreover this if pre-condition "pBufLen && (*pBufLen == 0) && !pBuf"
>> is constantly false because it is a nested if in the else brach, i.e.,
>> "if (cond) { ... } else { if (cond) {...} }". This patch alters the
>> if condition to check "pBufLen && pBuf" pointers are not NULL.
>>
> ...
>> ---
>> Not tested. I don't have the hardware. The fix is based on my guess.
>>
>>  drivers/staging/rtl8723bs/hal/hal_com_phycfg.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
>> index 6539bee9b5ba..0902dc3c1825 100644
>> --- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
>> +++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
>> @@ -2320,7 +2320,7 @@ int phy_ConfigBBWithParaFile(
>>  			}
>>  		}
>>  	} else {
>> -		if (pBufLen && (*pBufLen == 0) && !pBuf) {
>> +		if (pBufLen && pBuf) {
>>  			memcpy(pHalData->para_file_buf, pBuf, *pBufLen);
> 
> The existing code is clearly garbage.
> It only ever does memcpy(tgt, NULL, 0).
> 
> Under the assumption that the code has been tested the copy clearly isn't needed at all
> and can be deleted completely!

Initially I also thought that this is just a dead code and it could be simply removed. However, if
we look at it more carefully, this if condition looks like a copy-paste error:

if (pBufLen && (*pBufLen == 0) && !pBuf) {
	// get proper len
	// allocate pBuf
	...
	memcpy(pBuf, pHalData->para_file_buf, rlen);
	...
} else {
	if (pBufLen && (*pBufLen == 0) && !pBuf) { // <== condition in patch
		memcpy(pHalData->para_file_buf, pBuf, *pBufLen);
		rtStatus = _SUCCESS;
	} else
		DBG_871X("%s(): Critical Error !!!\n", __func__);
}

Thus, I think it will be incorrect to delete the second memcpy.

> 
> OTOH if the code hasn't been tested maybe the entire source file should be removed :-)
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

