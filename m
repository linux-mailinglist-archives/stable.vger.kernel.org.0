Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933153549A8
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 02:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242958AbhDFA10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 20:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242974AbhDFA10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 20:27:26 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCC0C06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 17:27:17 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so13013309otk.5
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 17:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iyK4rQhQLhMhMBGWL7KTZwQjmba7kgMPObIPN0UjTeM=;
        b=Fpg5ZkYiZuavVqsFMD9sPomFzPa5AD0HNBA479/JG9CRdrBVgAXBXTEl/PSxeJPVgk
         4SY88TipowVRC4I09hrOyqf/gw/Z+RbMK3TpKhk9gDhhB/S3gj6BZRHpr/dgj3TYiZ8y
         RqBb/D9ax1IrpU9fdTD6ig0iwxWgLeO+nb1vA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iyK4rQhQLhMhMBGWL7KTZwQjmba7kgMPObIPN0UjTeM=;
        b=artDE6HnWwgeS7clUV5kRU95riavpmqm2Q+GDF/gNkLiMfeJqgBzxcnFQ8BWIJOzvB
         vcBKVwZermkPOWeHWyLXxiU8xeHIPzYdm7lqCAJRlwhkdW7ZbSNiHB1bG9ArQgXmCC3P
         /hcmbhHZ7dxl4LqYFIWuuHg2m4WDwpdrWtKtt7QWQxRLQ4Pe++G/LbK1Sr5FzMhs34Xz
         BrGQkdnTXkVz9XYMVFODSpM8iHgnprXPQ9Up0yKgb24fhZBbiKbJITN6me9/WDpfqqN3
         OCvFmZUjxNvheiLqBVvvoiya88rwS91sHfStIHO5j4hVx8d7xQlgbHWR22Jft5zWhfQP
         /6Ag==
X-Gm-Message-State: AOAM532ncwK6viN6eMnHVJVMbZRu/qwStrVduzkjHIoupUkkXkJNQev4
        FA5Xbn6B65WFGzTpz9SPnovqKPG6ElzZXQ==
X-Google-Smtp-Source: ABdhPJyPlBsx9IVGLGXDOvlSrxeZrM+nSbTZDxMGB8kV3II76bjPdj1Y2y27nckypAc5kQ4gM395hQ==
X-Received: by 2002:a9d:1b8:: with SMTP id e53mr24206742ote.97.1617668837206;
        Mon, 05 Apr 2021 17:27:17 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j4sm3658711oom.11.2021.04.05.17.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 17:27:16 -0700 (PDT)
Subject: Re: [PATCH 5.10 047/126] ath10k: hold RCU lock when calling
 ieee80211_find_sta_by_ifaddr()
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085032.596054465@linuxfoundation.org> <20210405153452.GC32232@amd>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3ad53312-6349-3663-103e-8636bd53d117@linuxfoundation.org>
Date:   Mon, 5 Apr 2021 18:27:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210405153452.GC32232@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/21 9:34 AM, Pavel Machek wrote:
> Hi!
> 
>> Fix ath10k_wmi_tlv_op_pull_peer_stats_info() to hold RCU lock before it
>> calls ieee80211_find_sta_by_ifaddr() and release it when the resulting
>> pointer is no longer needed.
> 
> It does that. But is also does the unlock even if it did not take the
> lock:
> 

There is only one path after it takes the lock.

>> +++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
>> @@ -576,13 +576,13 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
>>   	case WMI_TDLS_TEARDOWN_REASON_TX:
>>   	case WMI_TDLS_TEARDOWN_REASON_RSSI:
>>   	case WMI_TDLS_TEARDOWN_REASON_PTR_TIMEOUT:
>> +		rcu_read_lock();

Takes the lock here:

>>   		station = ieee80211_find_sta_by_ifaddr(ar->hw,
>>   						       ev->peer_macaddr.addr,
>>   						       NULL);
>>   		if (!station) {
>>   			ath10k_warn(ar, "did not find station from tdls peer event");
>> -			kfree(tb);
>> -			return;
>> +			goto exit;

Releases it if something fails

>>   		}
>>   		arvif = ath10k_get_arvif(ar, __le32_to_cpu(ev->vdev_id));
>>   		ieee80211_tdls_oper_request(
>> @@ -593,6 +593,9 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
>>   					);
>>   		break;
>>   	}
>> +

falls through here.

>> +exit:
>> +	rcu_read_unlock();
>>   	kfree(tb);
>>   }
> 
> The switch only takes the lock in 3 branches, but it is released
> unconditionally at the end.
> 

I don't see any other switch cases. However, default is missing:

It could be done this way perhaps: (simpler than what you proposed)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c 
b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index d97b33f789e4..7efbe03fbca8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -592,6 +592,9 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k 
*ar, struct sk_buff *skb)
                                         GFP_ATOMIC
                                         );
                 break;
+       default:
+               kfree(tb);
+               return;
         }

  exit:

thanks,
-- Shuah
