Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03596C9F92
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 15:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbfJCNju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 09:39:50 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44973 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbfJCNju (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 09:39:50 -0400
Received: by mail-ed1-f68.google.com with SMTP id r16so2464011edq.11;
        Thu, 03 Oct 2019 06:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RhaZOkcAwmULT8u7N7kowltYRpwtVwSoOJwHBuJuEoY=;
        b=OFN/uyCG5Dk6Ye+LXVfKF1+fV0EStU24XzH0u+ZPSA4anSkVXHhkSOzfauxhwKztU7
         8QLd4krvsv+okyfYwgcwtDj6HdPfZMUEFmySJ67rJLjN6OOLcshMr3Wd+ZIO66sb2p95
         WVj85n4i9b0oJV9oZVDZsgflxauIML5S8Sy9COmv0DuwRs4/j6IL+2Tbl3nddIUhuKUh
         /jEtO6iKltFSFVpY6z1wIq6vSHDVoUy7YT8/kgUsvWYUk85RD3/ECpthj/5AeQCNKGvF
         mWBI6gu1MkWzIiMVVypRUAzwbGToFrBR4OBQT+bHatawViSDgZRYgAduASFz1iuwDWpW
         5dAw==
X-Gm-Message-State: APjAAAUjR365i+cJhCBlmDbb8UfSnQKpD7vpDMFBQD8pvgPyhhWy0BWp
        fs76XSkFcnTDf/hEOGeIJYeJ0nPL
X-Google-Smtp-Source: APXvYqzyiC0cLLXBzdvi0NlDNe67GEOoU0CKLkdTaT+S6oxWh7OVAQM1ybREoGXS2HDQdcobj1lsMg==
X-Received: by 2002:a17:906:944b:: with SMTP id z11mr7507866ejx.46.1570109986998;
        Thu, 03 Oct 2019 06:39:46 -0700 (PDT)
Received: from [10.10.2.174] (bran.ispras.ru. [83.149.199.196])
        by smtp.gmail.com with ESMTPSA id y25sm255019eju.39.2019.10.03.06.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 06:39:46 -0700 (PDT)
Reply-To: efremov@linux.com
Subject: Re: [PATCH] staging: wlan-ng: fix uninitialized variable
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <20191002174103.1274-1-efremov@linux.com>
 <20191003112649.GR22609@kadam>
From:   Denis Efremov <efremov@linux.com>
Message-ID: <c5b92b25-e66c-77b4-3f33-91f7002ef75e@linux.com>
Date:   Thu, 3 Oct 2019 16:39:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191003112649.GR22609@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10/3/19 2:26 PM, Dan Carpenter wrote:
> On Wed, Oct 02, 2019 at 08:41:03PM +0300, Denis Efremov wrote:
>> The result variable in prism2_connect() can be used uninitialized on path
>> !channel --> ... --> is_wep --> sme->key --> sme->key_idx >= NUM_WEPKEYS.
>> This patch initializes result with 0.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Denis Efremov <efremov@linux.com>
>> ---
>>  drivers/staging/wlan-ng/cfg80211.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
>> index eee1998c4b18..d426905e187e 100644
>> --- a/drivers/staging/wlan-ng/cfg80211.c
>> +++ b/drivers/staging/wlan-ng/cfg80211.c
>> @@ -441,7 +441,7 @@ static int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
>>  	int chan = -1;
>>  	int is_wep = (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) ||
>>  	    (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104);
>> -	int result;
>> +	int result = 0;
>>  	int err = 0;
>>  
> 
> I can't see any reason why we should have both "err" and "result".
> Maybe in olden times "result" used to save positive error codes instead
> of negative error codes but now it's just negatives and zero on success.
> There is no reason for the exit label either, we could just return
> directly.
> 
> So could you redo it and get rid of "result" entirely?  Otherwise it
> just causes more bugs like this.
> 

Yes, of course. I will prepare v2.

Thanks,
Denis
