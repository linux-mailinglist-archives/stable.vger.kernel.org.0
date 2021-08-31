Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937453FC2F5
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 08:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbhHaGrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 02:47:45 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:57905 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbhHaGro (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 02:47:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630392409; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=uFqd8D/yMCBI75fLiUWUKpTzLQcwLzG3XVPUw9rrh5M=; b=Cp9jzeCF3svj8mVQ8oVSo/f0kgvypRzr0eLxKNmfkqAIbi9mLruH0I2ukCxtTyZgnYJBjfWF
 humnLcBn+Jx1UX7Khpa6bH7Eaz8Zsega0Nv+i4FE6KR0V/7qbuIXSH86H1H3S7OCdCzBgPOp
 jw0Rgwjfwdf/kTRy8Gc5hv0m46s=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 612dd04eb52e91333c6c9c0b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 31 Aug 2021 06:46:38
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C7B52C4360C; Tue, 31 Aug 2021 06:46:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3EED7C4338F;
        Tue, 31 Aug 2021 06:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 3EED7C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "wcn36xx: Enable firmware link monitoring"
References: <1630343360-5942-1-git-send-email-loic.poulain@linaro.org>
        <401fd67a-4965-d4ae-8b6c-8c81a179a8c7@linaro.org>
        <CAMZdPi8KE_MDBMiXT60O92FMpQtim1FhhQ548=Sw5pXWAP+GxQ@mail.gmail.com>
Date:   Tue, 31 Aug 2021 09:46:34 +0300
In-Reply-To: <CAMZdPi8KE_MDBMiXT60O92FMpQtim1FhhQ548=Sw5pXWAP+GxQ@mail.gmail.com>
        (Loic Poulain's message of "Tue, 31 Aug 2021 08:14:01 +0200")
Message-ID: <874kb63yd1.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> writes:

> Hi Bryan,
>
> On Tue, 31 Aug 2021 at 03:13, Bryan O'Donoghue <bryan.odonoghue@linaro.org> wrote:
>
>  On 30/08/2021 18:09, Loic Poulain wrote:
>  > This reverts commit 8def9ec46a5fafc0abcf34489a9e8a787bca984d.
>  > 
>  > The firmware keep-alive does not cause any event in case of error
>  > such as non acked. It's just a basic keep alive to prevent the AP
>  > to kick-off the station due to inactivity. So let mac80211 submit
>  > its own monitoring packet (probe/null) and disconnect on timeout.
>  > 
>  > Note: We want to keep firmware keep alive to prevent kick-off
>  > when host is in suspend-to-mem (no mac80211 monitor packet).
>  > Ideally fw keep alive should be enabled in suspend path and disabled
>  > in resume path to prevent having both firmware and mac80211 submitting
>  > periodic null packets.
>  > 
>  > This fixes non detected AP leaving issues in active mode (nothing
>  > monitors beacon or connection).
>  > 
>  > Cc: stable@vger.kernel.org
>  > Fixes: 8def9ec46a5f ("wcn36xx: Enable firmware link monitoring")
>  > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>  > ---
>  >   drivers/net/wireless/ath/wcn36xx/main.c | 1 -
>  >   1 file changed, 1 deletion(-)
>  > 
>  > diff --git a/drivers/net/wireless/ath/wcn36xx/main.c
>  b/drivers/net/wireless/ath/wcn36xx/main.c
>  > index 216bc34..128d25d 100644
>  > --- a/drivers/net/wireless/ath/wcn36xx/main.c
>  > +++ b/drivers/net/wireless/ath/wcn36xx/main.c
>  > @@ -1362,7 +1362,6 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
>  >       ieee80211_hw_set(wcn->hw, HAS_RATE_CONTROL);
>  >       ieee80211_hw_set(wcn->hw, SINGLE_SCAN_ON_ALL_BANDS);
>  >       ieee80211_hw_set(wcn->hw, REPORTS_TX_ACK_STATUS);
>  > -     ieee80211_hw_set(wcn->hw, CONNECTION_MONITOR);
>  >   
>  >       wcn->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
>  >               BIT(NL80211_IFTYPE_AP) |
>  > 
>
>  But why is BSS heartbeat offload not running, it should be.
>
>  I agree we should switch this bit off for now since its obviously not 
>  working as intended.
>
>  But we need to root cause _why_
>
> I think it has just not be designed as a connection tracking mechanism but as a simple
> keep alive, which is submitted every 30s unconditionally.
>
>  In suspend absent a working heartbeat monitor - if the AP goes away we 
>  stay in suspend indefinitely.
>
> We shouldn't because the firmware is monitoring beacons and would cause a beacon miss
> indication, waking up the host.

No HTML please, our lists drop emails using HTML.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
