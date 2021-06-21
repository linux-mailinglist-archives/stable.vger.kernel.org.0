Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4E73AECCD
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFUPyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhFUPyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 11:54:21 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F5CC061574;
        Mon, 21 Jun 2021 08:52:07 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id v17-20020a4aa5110000b0290249d63900faso4619467ook.0;
        Mon, 21 Jun 2021 08:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DSfyzKavfa1LC7yxbCe25ppAb0rRQT6nPAbNd2OwNJg=;
        b=uzSqXhf94tKd922NNhuvUCE69EkxEw+DD7mN5umpjyyWBDoP+hbLYIWL4oEogIQxNa
         A8RO8ddUqLCfOPMHkqtdnI6CuJiQ/rPP40Ipol6YBQ4NNPkXL8kvYHd+OqiTjB8bA5Gq
         rUAN5+OJSfIAlZQDbxEf3FfWYin1DUsh8i8aYpBvT5KCjxAoUfkIeRtQ5uDEebuR5MGU
         1pQ06chn5C0NzE/AR7MThFx4cvz4GJd7y6YxYrx8djE+Q0uijxuIxxZDQd437prV6fro
         Oje/x09tYgsVCNYzvTONRtuw7WFXUfeDA0XP0Y+ZyqgzPcCJOzCeA7LlejpmexL0b8TB
         oTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DSfyzKavfa1LC7yxbCe25ppAb0rRQT6nPAbNd2OwNJg=;
        b=MP9kR5M9ZCFURSGKrUAuwHV+gKFW+FNJw4YJhdOKgMo+O6s5JoehdJho4x3Ht/yrgR
         R8gbD7/EYs0D+tnTLgTkxL8gelllQqE+wcuNLMDbqq+A7PhWrkY2Ssao4qaUwD4u+tVi
         +whpdnuZY7kElusZ2HOmd13ehbo3FJu+1UD1UuqCvmoqtEgU1stNE3k+JYQpKvGwUmij
         A39DAbavlZLVuAGCiViMEqREgrLU2CV8WH5NnBQ1lgz83V7V/KlhoZgSUSDvXpLYm30w
         GjbU2CDC7BhtMiwFNixkTJwRsSfWyMCk5wJ4QBTFV9B4Gs1D6w4XW6QQXfigPJXKonPp
         BlVA==
X-Gm-Message-State: AOAM533niSwBb3G/PdhXrDT2QpvTkqsA+R028fwVAlJf6COTEFqZW7/9
        P45vxBeB1qNSMBO4zzWl0MaZxM6Htcs=
X-Google-Smtp-Source: ABdhPJzP9OwdB3oGKhBxNTvtGy7hfzSnAP9Q46kb98AoOs1/SzdrypCWKjXFzYeFZi2qDC8nCZip5g==
X-Received: by 2002:a4a:e099:: with SMTP id w25mr21488656oos.43.1624290726464;
        Mon, 21 Jun 2021 08:52:06 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id b198sm3671206oii.19.2021.06.21.08.52.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 08:52:06 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH v2] rtw88: Fix some memory leaks
To:     Pkshih <pkshih@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
References: <20210620194110.7520-1-Larry.Finger@lwfinger.net>
 <19c86cb8dbe04b56b76a386b5faeaa89@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2c552c7c-bb11-a914-78e8-900d6bae39a9@lwfinger.net>
Date:   Mon, 21 Jun 2021 10:52:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <19c86cb8dbe04b56b76a386b5faeaa89@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/21 5:40 AM, Pkshih wrote:
> 
> 
>> -----Original Message-----
>> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry Finger
>> Sent: Monday, June 21, 2021 3:41 AM
>> To: kvalo@codeaurora.org
>> Cc: linux-wireless@vger.kernel.org; Larry Finger; Stable
>> Subject: [PATCH v2] rtw88: Fix some memory leaks
>>
>> There are memory leaks of skb's from routines rtw_fw_c2h_cmd_rx_irqsafe()
>> and rtw_coex_info_response(), both arising from C2H operations. There are
>> no leaks from the buffers sent to mac80211.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
>> ---
>> v2 - add the missinf changelog.
>>
>> ---
>>   drivers/net/wireless/realtek/rtw88/coex.c | 4 +++-
>>   drivers/net/wireless/realtek/rtw88/fw.c   | 2 ++
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
>> index cedbf3825848..e81bf5070183 100644
>> --- a/drivers/net/wireless/realtek/rtw88/coex.c
>> +++ b/drivers/net/wireless/realtek/rtw88/coex.c
>> @@ -591,8 +591,10 @@ void rtw_coex_info_response(struct rtw_dev *rtwdev, struct sk_buff *skb)
>>   	struct rtw_coex *coex = &rtwdev->coex;
>>   	u8 *payload = get_payload_from_coex_resp(skb);
>>
>> -	if (payload[0] != COEX_RESP_ACK_BY_WL_FW)
>> +	if (payload[0] != COEX_RESP_ACK_BY_WL_FW) {
>> +		dev_kfree_skb_any(skb);
>>   		return;
>> +	}
>>
>>   	skb_queue_tail(&coex->queue, skb);
>>   	wake_up(&coex->wait);
>> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
>> index 797b08b2a494..43525ad8543f 100644
>> --- a/drivers/net/wireless/realtek/rtw88/fw.c
>> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
>> @@ -231,9 +231,11 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
>>   	switch (c2h->id) {
>>   	case C2H_BT_MP_INFO:
>>   		rtw_coex_info_response(rtwdev, skb);
>> +		dev_kfree_skb_any(skb);
> 
> The rtw_coex_info_response() puts skb into a skb_queue, so we can't free it here.
> Instead, we should free it after we dequeue and do thing.
> So, we send another patch:
> https://lore.kernel.org/linux-wireless/20210621103023.41928-1-pkshih@realtek.com/T/#u
> 
> I hope this isn't confusing you.

No, it is not confusing. T=You fixed some leaks the I did not know existed.

Kalle: Take P-K's patch and discard mine.

Thanks,

Larry
