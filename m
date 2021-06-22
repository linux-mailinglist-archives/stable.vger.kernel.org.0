Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE5A3AFD0C
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 08:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhFVG3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 02:29:32 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:23092 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVG3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 02:29:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624343236; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=rtK0tW1ju/GyKTMtCf1gJfa7tHEiWQ1khV7G/6BqZTU=; b=fz6zKIONJ9j4ZBt7O+ZDkI33UedFk4fTRtLyyZEzBD+JHY+TPCrcTaM4ZiDsHewoh6KM6OKL
 VKVwLUvUWzWjnmlYNljioWAoqVehrom3YynoTB3XNu5aYawa5XWOpf6qMEcJr3r+dnzYGQCJ
 xI9aoVJwyjdY0b0PyN00QQ2EmJM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60d182a8ea2aacd729483e3b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Jun 2021 06:26:48
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9BB38C43217; Tue, 22 Jun 2021 06:26:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A8612C433F1;
        Tue, 22 Jun 2021 06:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A8612C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] rtw88: Fix some memory leaks
References: <20210620194110.7520-1-Larry.Finger@lwfinger.net>
        <19c86cb8dbe04b56b76a386b5faeaa89@realtek.com>
        <2c552c7c-bb11-a914-78e8-900d6bae39a9@lwfinger.net>
Date:   Tue, 22 Jun 2021 09:26:32 +0300
In-Reply-To: <2c552c7c-bb11-a914-78e8-900d6bae39a9@lwfinger.net> (Larry
        Finger's message of "Mon, 21 Jun 2021 10:52:05 -0500")
Message-ID: <87sg1a5s9z.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 6/21/21 5:40 AM, Pkshih wrote:
>>
>>
>>> -----Original Message-----
>>> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry Finger
>>> Sent: Monday, June 21, 2021 3:41 AM
>>> To: kvalo@codeaurora.org
>>> Cc: linux-wireless@vger.kernel.org; Larry Finger; Stable
>>> Subject: [PATCH v2] rtw88: Fix some memory leaks
>>>
>>> There are memory leaks of skb's from routines rtw_fw_c2h_cmd_rx_irqsafe()
>>> and rtw_coex_info_response(), both arising from C2H operations. There are
>>> no leaks from the buffers sent to mac80211.
>>>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> Cc: Stable <stable@vger.kernel.org>
>>> ---
>>> v2 - add the missinf changelog.
>>>
>>> ---
>>>   drivers/net/wireless/realtek/rtw88/coex.c | 4 +++-
>>>   drivers/net/wireless/realtek/rtw88/fw.c   | 2 ++
>>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
>>> index cedbf3825848..e81bf5070183 100644
>>> --- a/drivers/net/wireless/realtek/rtw88/coex.c
>>> +++ b/drivers/net/wireless/realtek/rtw88/coex.c
>>> @@ -591,8 +591,10 @@ void rtw_coex_info_response(struct rtw_dev *rtwdev, struct sk_buff *skb)
>>>   	struct rtw_coex *coex = &rtwdev->coex;
>>>   	u8 *payload = get_payload_from_coex_resp(skb);
>>>
>>> -	if (payload[0] != COEX_RESP_ACK_BY_WL_FW)
>>> +	if (payload[0] != COEX_RESP_ACK_BY_WL_FW) {
>>> +		dev_kfree_skb_any(skb);
>>>   		return;
>>> +	}
>>>
>>>   	skb_queue_tail(&coex->queue, skb);
>>>   	wake_up(&coex->wait);
>>> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
>>> index 797b08b2a494..43525ad8543f 100644
>>> --- a/drivers/net/wireless/realtek/rtw88/fw.c
>>> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
>>> @@ -231,9 +231,11 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
>>>   	switch (c2h->id) {
>>>   	case C2H_BT_MP_INFO:
>>>   		rtw_coex_info_response(rtwdev, skb);
>>> +		dev_kfree_skb_any(skb);
>>
>> The rtw_coex_info_response() puts skb into a skb_queue, so we can't free it here.
>> Instead, we should free it after we dequeue and do thing.
>> So, we send another patch:
>> https://lore.kernel.org/linux-wireless/20210621103023.41928-1-pkshih@realtek.com/T/#u
>>
>> I hope this isn't confusing you.
>
> No, it is not confusing. T=You fixed some leaks the I did not know existed.
>
> Kalle: Take P-K's patch and discard mine.

Will do, thank you for clear instructions :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
