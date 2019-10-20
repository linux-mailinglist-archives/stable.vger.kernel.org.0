Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B131DDBCF
	for <lists+stable@lfdr.de>; Sun, 20 Oct 2019 03:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfJTBNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 21:13:42 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:32969 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfJTBNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Oct 2019 21:13:42 -0400
Received: by mail-oi1-f193.google.com with SMTP id a15so8315755oic.0;
        Sat, 19 Oct 2019 18:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fbjtrTwV/qweB3GLJOtY6Y3VDm+9k3ygd6yFcHUDd/I=;
        b=ceQqlJjPLVpSbZQIP5r8TynJGPzCMBsxR8hmgoOeSROqdQu8pgoQ1l/DWD7ersZyEN
         DdxRQG5a0oz9aPx8PHUoxjihk6WsSi/LU37C1g1OLwudRVkLNr358gjkG6aa245CZZad
         9UBFNeJ4wm3gHbX9m8jFS4SD0VYJOldIAnmXjq9inKi8gNkfWnq6lbFTMLCR52Fl1LSq
         QENxA1ZCEPvNrOxo4i1r08ima0sCDF3w1Ml1ryRlnwAHdZAof5hzizroqcBQdeL7vj+D
         bTx4WCef0CIEX/Sl2iL7BQ/i9rnDlBqZUjNMFmRJMGP4OBV9iNY8v86gxy4ixTljYIhz
         FPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fbjtrTwV/qweB3GLJOtY6Y3VDm+9k3ygd6yFcHUDd/I=;
        b=MpensErKx+N2se+LIsA6HnJBimrrXw//coGRnqCjlJ91qROSwzaElrYZFu6exV1PsP
         01l31h1tMcUjHNNS5heNj+Wp4yP9rDJhX92yz1xGm3YsD2pXoDAZghUgAeQe66JbcEKK
         jU8M7zn9SqBdw4hvr4Zjn1slJZ1EM0PVkujdSoRz7dQKpPUT0uNEAmcMH33Df1xkbc7b
         iY0YBTiA0+d0Phw+jCi5EQsAPa36U/aerRN1zcO3MIOKPi4qyWn3TVNkKzOkbq/Kuurl
         Q102FaDxsn622F1ucNrGLw5pRKa8xzL/b5IAHWbhOnUH3IsMT5kucPvHFb9SUpzm57Yo
         gLnQ==
X-Gm-Message-State: APjAAAVOPfbJMw/zR1LxqWO34TdcAFF6tZGn0DXnMKg7kTfSRngxFIoy
        VPdxQUknUKaDoEPYOYcEbgBsfmYL
X-Google-Smtp-Source: APXvYqxkrCaD4IneFODQ3NPxJcxOKW3SSGDij7pRGcIX5pd10Rc5YwPPnUK3aLDOo1AszwS8xxZrCA==
X-Received: by 2002:aca:5ed7:: with SMTP id s206mr13104954oib.134.1571534021039;
        Sat, 19 Oct 2019 18:13:41 -0700 (PDT)
Received: from [192.168.1.122] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t22sm2953914otc.9.2019.10.19.18.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Oct 2019 18:13:40 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl_pci: Fix problem of too small skb->len
To:     "ian.schram" <ian.schram@telenet.be>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Stable <stable@vger.kernel.org>
References: <20191019190222.29681-1-Larry.Finger@lwfinger.net>
 <05f25c80-51a9-bfad-ea4a-3c17b0eecf64@telenet.be>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <20649f24-6412-4fac-f640-c611916aa85c@lwfinger.net>
Date:   Sat, 19 Oct 2019 20:13:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <05f25c80-51a9-bfad-ea4a-3c17b0eecf64@telenet.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/19 5:23 PM, ian.schram wrote:
> Hi,
> 
> 
> This patch doesn't appear to do anything? The increased length is not actually
> used, is a part of the patch missing?
> 
> 
> ps: superficial reading, i am not hampered by any specific knowledge of this 
> driver.
> 
> On 2019-10-19 21:02, Larry Finger wrote:
>> In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
>> only"), buffers whose length is too short cause a WARN_ON(1) to be
>> executed. This change exposed a fault in rtlwifi drivers, which is fixed
>> by increasing the length of the affected buffer before it is sent to
>> mac80211.
>>
>> Cc: Stable <stable@vger.kernel.org> # v5.0+
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> Kalle,
>>
>> Please send to v5.4.
>>
>> Larry
>> ---
>>
>>   drivers/net/wireless/realtek/rtlwifi/pci.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c 
>> b/drivers/net/wireless/realtek/rtlwifi/pci.c
>> index 6087ec7a90a6..bb5144b7c64f 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
>> @@ -692,7 +692,10 @@ static void _rtl_pci_rx_to_mac80211(struct ieee80211_hw *hw,
>>           dev_kfree_skb_any(skb);
>>       } else {
>>           struct sk_buff *uskb = NULL;
>> +        int len = skb->len;
>> +        if (unlikely(len <= FCS_LEN))
>> +            len = FCS_LEN + 2;
>>           uskb = dev_alloc_skb(skb->len + 128);
>>           if (likely(uskb)) {
>>               memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
>>

Ian,

Yes, I debugged using a different tree and missed one use of the new len. V2 
submitted.

Thanks for noticing.

Larry

