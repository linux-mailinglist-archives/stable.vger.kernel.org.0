Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9630537FC63
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 19:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhEMRUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 13:20:21 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48517 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231232AbhEMRTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 13:19:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620926317; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=iM3ko5L1PPEvD7mpUvwhSW4LYEMmmMA1RfYovsAbYmk=;
 b=Tl+KboUUaf20pV4lPjo1CP/2HUeoChgvgVun8YXBsxY3+MAESreoO9ykNPkGsy3hfquESOuw
 ovC5EPWBj2XrWgDUKhrwerHqbZ6FUL1viMyza97PjoQ2SlT/94hF0URKAQy6ziF5FLGM85Qs
 JL+kKyXz1Fp6Yor1h1hF/6TPhRs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 609d5f62ff1bb9beecb323b3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 13 May 2021 17:18:26
 GMT
Sender: jjohnson=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EF3C1C433F1; Thu, 13 May 2021 17:18:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jjohnson)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83412C4338A;
        Thu, 13 May 2021 17:18:22 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 13 May 2021 10:18:22 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 14/18] ath10k: drop MPDU which has discard flag set by
 firmware for SDIO
In-Reply-To: <CA+ASDXPwAWEEvWBdiLpMrm-PTcSH7QQHwx_T5nxN+faQt=Wi_g@mail.gmail.com>
References: <20210511180259.159598-1-johannes@sipsolutions.net>
 <20210511200110.11968c725b5c.Idd166365ebea2771c0c0a38c78b5060750f90e17@changeid>
 <CA+ASDXPwAWEEvWBdiLpMrm-PTcSH7QQHwx_T5nxN+faQt=Wi_g@mail.gmail.com>
Message-ID: <e417165a0f952b030a195dde4979058f@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-12 11:35, Brian Norris wrote:
> On Tue, May 11, 2021 at 11:03 AM Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -2312,6 +2312,11 @@ static bool ath10k_htt_rx_proc_rx_ind_hl(struct
>> ath10k_htt *htt,
>>         fw_desc = &rx->fw_desc;
>>         rx_desc_len = fw_desc->len;
>> 
>> +       if (fw_desc->u.bits.discard) {
>> +               ath10k_dbg(ar, ATH10K_DBG_HTT, "htt discard mpdu\n");
>> +               goto err;
>> +       }
>> +
>>         /* I have not yet seen any case where num_mpdu_ranges > 1.
>>          * qcacld does not seem handle that case either, so we 
>> introduce
>> the
>>          * same limitiation here as well.
>> diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h
>> b/drivers/net/wireless/ath/ath10k/rx_desc.h
>> index f2b6bf8f0d60..705b6295e466 100644
>> --- a/drivers/net/wireless/ath/ath10k/rx_desc.h
>> +++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
>> @@ -1282,7 +1282,19 @@ struct fw_rx_desc_base {
>>  #define FW_RX_DESC_UDP              (1 << 6)
>> 
>>  struct fw_rx_desc_hl {
>> -       u8 info0;
>> +       union {
>> +               struct {
>> +               u8 discard:1,
>> +                  forward:1,
>> +                  any_err:1,
>> +                  dup_err:1,
>> +                  reserved:1,
>> +                  inspect:1,
>> +                  extension:2;
>> +               } bits;
>> +               u8 info0;
>> +       } u;
> 
> Am I misled here, or are you introducing endianness issues here? From 
> C99:
> 
> "The order of allocation of bit-fields within a unit (high-order to
> low-order or low-order to high-order) is implementation-defined."
> 
> Now, we're pretty well attuned to two implementations (big and little
> endian), and this should work for the most common one (little endian),
> but it's not wise to assume everyone is little endian.
> 
> Brian

This issue was identified in internal review, but due to the embargo 
expiring
we sent it out as-is since that is what had been tested. The author will 
have
a follow-up change to replace this.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
