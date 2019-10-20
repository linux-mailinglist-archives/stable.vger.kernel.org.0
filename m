Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD1CDDD4E
	for <lists+stable@lfdr.de>; Sun, 20 Oct 2019 10:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfJTI2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Oct 2019 04:28:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJTI2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Oct 2019 04:28:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5432960D4C; Sun, 20 Oct 2019 08:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571560099;
        bh=VJ+3BY4N5uiFdl5h5/baueL661bRnGGWhze5C9VXYI4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Js3qyiV/CqwSecWlDAfnFllxDIcnZmfbfUOb4lF9e6/1nL+PyNrM/4JpuEANIAo7c
         jqMwQOrj+Cxl0DS8JqF1CpEE4R+XoUPRGHKvBT4fQnAxDtB2DSAbNiy12dZwd+GgCG
         hs8ay3sCYy0z+KIUqn8ziSKf+82nQUntuGIJD20o=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 841B360CA5;
        Sun, 20 Oct 2019 08:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571560098;
        bh=VJ+3BY4N5uiFdl5h5/baueL661bRnGGWhze5C9VXYI4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ikHQi7c3iFcWj1as1ykx1A1u76MB1bOgTtJZ/RSZc1FqE+345Lu5MYHUt6WIe/320
         XOy4kBpuCWRz5KsogqLRXZ8a77TLE+b9a5/MTc7bctjt9FNhxGkSQ5a8WA2mu/tZCd
         51kbkSzw4krYSN2XtPr3BVjDgeiMyV5gRgTf9GK0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 841B360CA5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH V2] rtlwifi: rtl_pci: Fix problem of too small skb->len
References: <20191020011153.29383-1-Larry.Finger@lwfinger.net>
Date:   Sun, 20 Oct 2019 11:28:14 +0300
In-Reply-To: <20191020011153.29383-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sat, 19 Oct 2019 20:11:53 -0500")
Message-ID: <874l03lt29.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
> only"), buffers whose length is too short cause a WARN_ON(1) to be
> executed. This change exposed a fault in rtlwifi drivers, which is fixed
> by increasing the length of the affected buffer before it is sent to
> mac80211.

With what frames, or in what scenarios, do you get these warnings?

> Cc: Stable <stable@vger.kernel.org> # v5.0+
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> V2 - added missing usage of new len
> ---
> Please Apply to 5.4
> ---
>  drivers/net/wireless/realtek/rtlwifi/pci.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
> index 6087ec7a90a6..3e9185162e51 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -692,12 +692,15 @@ static void _rtl_pci_rx_to_mac80211(struct ieee80211_hw *hw,
>  		dev_kfree_skb_any(skb);
>  	} else {
>  		struct sk_buff *uskb = NULL;
> +		int len = skb->len;
>  
> +		if (unlikely(len <= FCS_LEN))
> +			len = FCS_LEN + 2;

I don't understand this change, I think this needs a comment in the
code, or better yet a proper define documenting the meaning of the
value. What does these two bytes contain? Or are you just working around
the mac80211 warning by increasing the length with a random value you
chose?

-- 
Kalle Valo
