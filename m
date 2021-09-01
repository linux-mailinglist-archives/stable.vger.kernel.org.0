Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424483FE1A7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 20:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344779AbhIASDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 14:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344544AbhIASDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 14:03:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC58DC0613C1
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 11:02:35 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id x4so278624pgh.1
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 11:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y30if3F3NS1+QkGYwwybS7kbIaoempyrzf9jSIfoY3A=;
        b=ESredNTJViz+fzZkQ9m1MSPT3f0f154gcIeOGNFX7Q4gaI0pDTE1Gg9QpIhLX/bsIN
         sqJZ5ZbH7QAo4eMn/tf4BQ0lWmYVvghCuMBoolH58nH9Vx5aewNop+MmfSIff6JTs+Z5
         jmze25Fq8cVXjxxwX+KqnBae1gP4cflG5UP/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y30if3F3NS1+QkGYwwybS7kbIaoempyrzf9jSIfoY3A=;
        b=uPu5ba8KDJ9ASFFaaX/6A/OtdWs1zFC4OIExVtEnNAqqO9YbhvCkD3zKm3GMLsdrH4
         ZksgtSaGjiGF4qq8ifVjzmuGsMniTSU2WuMwEM70U+N0HNf+sANeZ5OwjJH2m4MHMeeS
         QjjASbMNU+2hHssnnNoRJUesQuQiLxP0eFEsvGOp29FYhLwtcPkvNTayWvgzE7ezrnou
         PI2UtHXjLrQppiMhdpUdSsvFjgAekhxx9+hJCytUZ2ngLXdQrgD9qvAT4Tm+AjPoSnSk
         Z7yCkH/xyEhPFG+AuQtXv77QeoXmE0wBPAXyOqSbtxl4EzE91B9Ksb6mvyB1Stk/mIlp
         1SbA==
X-Gm-Message-State: AOAM5309glDg1AGyf8hFR1kFbW5VEXua4O4lIDh7ItviqBuZ547sPDB/
        HluEOfBAgx3why7wyDmurx+vvQ==
X-Google-Smtp-Source: ABdhPJzsAsOgDwSLPteGex0dqQAwNeVXY4yZb23xomFOALrmZvS9rc7jQepSJ7jUP15ZkXZ0ai76og==
X-Received: by 2002:aa7:9ae9:0:b0:3f5:e1a7:db23 with SMTP id y9-20020aa79ae9000000b003f5e1a7db23mr718513pfp.42.1630519355340;
        Wed, 01 Sep 2021 11:02:35 -0700 (PDT)
Received: from benl-m5lvdt.local ([2600:6c50:4d00:2376:c5f1:a747:4b09:56ac])
        by smtp.gmail.com with ESMTPSA id v190sm147942pfv.166.2021.09.01.11.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 11:02:34 -0700 (PDT)
Subject: Re: [PATCH] wcn36xx: handle connection loss indication
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210901030542.17257-1-benl@squareup.com>
 <CAMZdPi_frOfwf+9nfiUw2NJhfuSVgcPj3=Hx2g0d8UsaZza5MA@mail.gmail.com>
 <b6157d1f-b548-13c0-3683-2d8c35964d1d@linaro.org>
From:   Benjamin Li <benl@squareup.com>
Message-ID: <168f96a5-58ec-fea9-c0d3-61f925bd1129@squareup.com>
Date:   Wed, 1 Sep 2021 11:02:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <b6157d1f-b548-13c0-3683-2d8c35964d1d@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for the investigation!

As discussed offline, I will send v2 with Fixes: removed, and Bryan will test and submit a separate patch to add the additional feat_caps for the power_save off case.

Depending on DB410c testing, these feat_caps may need to be gated for WCN3680 only, in which case Loic's patch to re-enable CONNECTION_MONITOR (but gated for WCN3660/3620) would still be needed.

Ben

On 9/1/21 4:56 AM, Bryan O'Donoghue wrote:
> On 01/09/2021 07:40, Loic Poulain wrote:
>> iw wlan0 set power_save off
> 
> I do this on wcn3680b and get no loss of signal
> 
> If I do this though
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 03966072f34c..ba613fbb728d 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2345,6 +2345,8 @@ int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn)
>                 set_feat_caps(msg_body.feat_caps, DOT11AC);
>                 set_feat_caps(msg_body.feat_caps, ANTENNA_DIVERSITY_SELECTION);
>         }
> +       set_feat_caps(msg_body.feat_caps, IBSS_HEARTBEAT_OFFLOAD);
> +       set_feat_caps(msg_body.feat_caps, WLANACTIVE_OFFLOAD);
> 
>         PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> 
> @@ -2589,7 +2591,7 @@ static int wcn36xx_smd_missed_beacon_ind(struct wcn36xx *wcn,
>         struct wcn36xx_hal_missed_beacon_ind_msg *rsp = buf;
>         struct ieee80211_vif *vif = NULL;
>         struct wcn36xx_vif *tmp;
> -
> +wcn36xx_info("%s/%d\n", __func__, __LINE__);
>         /* Old FW does not have bss index */
>         if (wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
>                 list_for_each_entry(tmp, &wcn->vif_list, list) {
> @@ -2608,7 +2610,7 @@ static int wcn36xx_smd_missed_beacon_ind(struct wcn36xx *wcn,
> 
>         list_for_each_entry(tmp, &wcn->vif_list, list) {
>                 if (tmp->bss_index == rsp->bss_index) {
> -                       wcn36xx_dbg(WCN36XX_DBG_HAL, "beacon missed bss_index %d\n",
> +                       wcn36xx_info("beacon missed bss_index %d\n",
>                                     rsp->bss_index);
>                         vif = wcn36xx_priv_to_vif(tmp);
>                         ieee80211_connection_loss(vif);
> 
> 
> bingo
> 
> root@linaro-developer:~# iw wlan0 set power_save off
> 
> 
> # pulls plug on AP
> 
> root@linaro-developer:~# [   83.290987] wcn36xx: wcn36xx_smd_missed_beacon_ind/2594
> [   83.291070] wcn36xx: beacon missed bss_index 0
> [   83.295403] wlan0: Connection to AP e2:63:da:9c:a4:bd lost
> 
> I'm not sure if both flags are required but, this is the behavior we want
> 
