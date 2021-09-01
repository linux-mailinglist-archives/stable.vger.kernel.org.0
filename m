Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860833FD3B2
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 08:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242198AbhIAGQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 02:16:04 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:28376 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242085AbhIAGQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 02:16:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630476907; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ZXaAicq53OuRyXnDIGqMVp7cKVSiuHVVieLqiFabWkI=; b=NAH2lCaA95JufiiLvTyrdfNZhhexxPc4PQF8lUSshd1rUUVirFG0z7L1YIABcDA/6rrw4BU2
 Sepwdw2PoBdSNBiLP+spwSTxYEhTDIWWkHFARy6t3Mz2wamvqeFsHZSBItKZ9Q8J2M9mMzaM
 8WcqWF6Ehh3sZnVfk5xYZ7riP48=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 612f1a5bd15f4d68a2c1db5d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 01 Sep 2021 06:14:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 56530C4360D; Wed,  1 Sep 2021 06:14:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4748FC4338F;
        Wed,  1 Sep 2021 06:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 4748FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Benjamin Li <benl@squareup.com>
Subject: Re: [PATCH] Revert "wcn36xx: Enable firmware link monitoring"
References: <1630343360-5942-1-git-send-email-loic.poulain@linaro.org>
        <878s0i3yfq.fsf@codeaurora.org>
        <40edf308-d12c-2116-0e5f-22cab413ea71@linaro.org>
        <afb41aa0-c6a8-4663-3b05-c26046a2f5b1@linaro.org>
Date:   Wed, 01 Sep 2021 09:14:46 +0300
In-Reply-To: <afb41aa0-c6a8-4663-3b05-c26046a2f5b1@linaro.org> (Bryan
        O'Donoghue's message of "Wed, 1 Sep 2021 00:54:14 +0100")
Message-ID: <87o89c3jqh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> writes:

> On 01/09/2021 00:51, Bryan O'Donoghue wrote:
>> On 31/08/2021 07:44, Kalle Valo wrote:
>>> Loic Poulain <loic.poulain@linaro.org> writes:
>>>
>>>> This reverts commit wcn->hw, CONNECTION_MONITOR.
>>>>
>>>> The firmware keep-alive does not cause any event in case of error
>>>> such as non acked. It's just a basic keep alive to prevent the AP
>>>> to kick-off the station due to inactivity. So let mac80211 submit
>>>> its own monitoring packet (probe/null) and disconnect on timeout.
>>>>
>>>> Note: We want to keep firmware keep alive to prevent kick-off
>>>> when host is in suspend-to-mem (no mac80211 monitor packet).
>>>> Ideally fw keep alive should be enabled in suspend path and disabled
>>>> in resume path to prevent having both firmware and mac80211 submitting
>>>> periodic null packets.
>>>>
>>>> This fixes non detected AP leaving issues in active mode (nothing
>>>> monitors beacon or connection).
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 8def9ec46a5f ("wcn36xx: Enable firmware link monitoring")
>>>> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>>>
>>> I'll queue this to v5.15.
>>>
>>
>> Might want to hold off on that.
>>
>> Its been reported by testing that
>> wcn36xx_smd_delete_sta_context_ind() actually _is_ firing.
>>
>> But if you look at wcn36xx_smd_delete_sta_context_ind() it doesn't
>> seem to do ieee80211_connection_loss() like it presumably should.
>>
>> I think the right fix here might be to call
>> ieee80211_connection_loss() in wcn36xx_smd_delete_sta_context_ind()
>> if (wcn->hw & CONNECTION_MONITOR)
>>
>> ---
>> bod
>
> In that case right now if (wcn->hw & CONNECTION_MONITOR) we'd
> presumably rely on a subsequent wcn36xx_smd_missed_beacon_ind() but...
>
> its not clear that wcn36xx_smd_missed_beacon_ind() would fire
> subsequent to wcn36xx_smd_delete_sta_context_ind()
>
> In fact, it would be pretty illogical if it did.
>
> I think instead of revert - we want to just do better processing here
> in wcn36xx_smd_delete_sta_context_ind() alright.

Ok, I'll drop this patch.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
