Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8A2C2331
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 16:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbfI3OZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 10:25:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37024 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731276AbfI3OZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 10:25:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id r4so8839333edy.4;
        Mon, 30 Sep 2019 07:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OpLZCxVJpBgsNbMjEaZfq3+E0DlE1NH8zVCBJHO9OVs=;
        b=e72weoppf6JfZ53f85GsyiYVEjb0qN0KVtPSu5wOR+MJd3gDYLBEgzpv3kyewZ89Uz
         ceSz7a85I7Zx2ddysvCOZZrZFzXGV/OyNk5rHecNVEGHJhLroPS0ClKmBCtRDhmuNycz
         lRGwJwLV94qLLYmBPy1nL4p++OVGm+QdkQzGO/gMUCPUj/XHOo6lL5kN5KVEB34sArQJ
         gCu9Tq95znJ0aZjRsY1boNoH9kU4upDcJWSNHIGarTuncVPUItCRoAThI2TNmCnU28gS
         VDH//waQocRL3igXlIywGBs3pIxtSybOVX/2PiyjzRuC00LsMpjNqsXlRQ7PJfjGEODC
         DdZA==
X-Gm-Message-State: APjAAAVuiXDy5X1To067bx8tl6xB1shwY6Eib8pfy29nSyuECxTiLqq+
        iRILhIpR/3YhQvxyRNtqpSs=
X-Google-Smtp-Source: APXvYqwpxhHy2gun3EIxWoTehrjW4QdbA9X0fp1k2JMKaG57RiLYZFUHvA44EtXZdKvFBSaSgKIdEQ==
X-Received: by 2002:a50:9e26:: with SMTP id z35mr19911245ede.265.1569853545116;
        Mon, 30 Sep 2019 07:25:45 -0700 (PDT)
Received: from [10.10.2.174] (bran.ispras.ru. [83.149.199.196])
        by smtp.gmail.com with ESMTPSA id rl4sm1390000ejb.27.2019.09.30.07.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 07:25:44 -0700 (PDT)
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
Message-ID: <e4051dcb-10dc-ff17-ec0b-6f51dccdb5bf@linux.com>
Date:   Mon, 30 Sep 2019 17:25:43 +0300
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

Well, technically you are right. However, UBSAN warns about passing NULL
to memcpy and from the formal point of view this is an undefined behavior [1].
There were a discussion [2] about interesting implication of assuming that
memcpy with 0 size and NULL pointer is fine. This could result in that compiler
assume that pointer is not NULL. However, this is not the case here since
this "if then" branch is a dead code in it's current form. I just find this
piece of code very funny regarding this patch [3].

[1] https://stackoverflow.com/questions/5243012/is-it-guaranteed-to-be-safe-to-perform-memcpy0-0-0
[2] https://groups.google.com/forum/#!msg/syzkaller-netbsd-bugs/8B4CIKN0Xz8/wRvIUWxiAgAJ
[3] https://github.com/torvalds/linux/commit/8f884e76cae65af65c6bec759a17cb0527c54a15#diff-a476c238511f9374c2f1b947fdaffbbcL2339

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
> 
> OTOH if the code hasn't been tested maybe the entire source file should be removed :-)
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

