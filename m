Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7746E396
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 08:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhLIIC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 03:02:57 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42730 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbhLIIC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 03:02:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2C55CE241A;
        Thu,  9 Dec 2021 07:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C78C004DD;
        Thu,  9 Dec 2021 07:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639036760;
        bh=7usM8Vbzbt7a1NhxXqycqXWoO9LCXTfcFvZdVhjm9/U=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Mf9H26Oyq6oVoTZpwcFL+iPOu0W2niMsBMuhcrJg/36GCepmIKD8APRtzCU3a7BWy
         DZwr88C76kvk611BGBUGXCHjOaOiAXu2NHBkVJSkedoRrwj4/DZHq6S28yMJmmp1pX
         OGJvCBUqv/dy9buOCqjt+ImxIGjVA7AQBtpjEko8yNbu4x4bWlXMOqgM0bJggtiz3u
         GZ4l0PPbrNL9lLbqITb8hXrH7K7d4/NrhtlbX32CNrobn19W/ojq6MV0jg+jlVTGcB
         JqcU3IGwCn/0LRHOw/la5pbiRUW93RbUP0t8fkuCmDPXVOHFHIMs2wsz5tupcS1at9
         3xGAvFdgAdFbA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Fix buffer overflow when scanning with extraie
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211207142913.1734635-1-sven@narfation.org>
References: <20211207142913.1734635-1-sven@narfation.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Wen Gong <quic_wgong@quicinc.com>,
        Sven Eckelmann <sven@narfation.org>, stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163903675519.20904.4795349677435567607.kvalo@kernel.org>
Date:   Thu,  9 Dec 2021 07:59:19 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sven Eckelmann <sven@narfation.org> wrote:

> If cfg80211 is providing extraie's for a scanning process then ath11k will
> copy that over to the firmware. The extraie.len is a 32 bit value in struct
> element_info and describes the amount of bytes for the vendor information
> elements.
> 
> The WMI_TLV packet is having a special WMI_TAG_ARRAY_BYTE section. This
> section can have a (payload) length up to 65535 bytes because the
> WMI_TLV_LEN can store up to 16 bits. The code was missing such a check and
> could have created a scan request which cannot be parsed correctly by the
> firmware.
> 
> But the bigger problem was the allocation of the buffer. It has to align
> the TLV sections by 4 bytes. But the code was using an u8 to store the
> newly calculated length of this section (with alignment). And the new
> calculated length was then used to allocate the skbuff. But the actual code
> to copy in the data is using the extraie.len and not the calculated
> "aligned" length.
> 
> The length of extraie with IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS enabled
> was 264 bytes during tests with a QCA Milan card. But it only allocated 8
> bytes (264 bytes % 256) for it. As consequence, the code to memcpy the
> extraie into the skb was then just overwriting data after skb->end. Things
> like shinfo were therefore corrupted. This could usually be seen by a crash
> in skb_zcopy_clear which tried to call a ubuf_info callback (using a bogus
> address).
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-02892.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
> 
> Cc: stable@vger.kernel.org
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

a658c929ded7 ath11k: Fix buffer overflow when scanning with extraie

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211207142913.1734635-1-sven@narfation.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

