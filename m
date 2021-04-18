Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53E0363418
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 08:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhDRGfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 02:35:32 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:19717 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhDRGfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 02:35:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618727704; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=uQERvfmFkZO+Sw0ATrJt+sXpIvuGslbipMcOPO/kLbI=;
 b=HJqhVHhIuUghpZ8Y/Tf7hmQCPMJaboorRkMuPXk1OEimV77l0jiqAyx2CYNmHiUnXA8zCRaG
 xRb/Dc6OKJIL+rzyvnm1Nmh4xBXFPtKH1n0R/WkuLNtO8f1txlSkV3trNYfHKMNmOLFe0p55
 yiObdUwmQvi68GqmETrF524ZO2k=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 607bd311f34440a9d436374f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 06:34:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B02ACC433D3; Sun, 18 Apr 2021 06:34:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46CCAC433F1;
        Sun, 18 Apr 2021 06:34:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46CCAC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: rtw88: Fix array overrun in rtw_get_tx_power_params()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210401192717.28927-1-Larry.Finger@lwfinger.net>
References: <20210401192717.28927-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        =?utf-8?b?0JHQvtCz0LTQsNC9INCf0LjQu9C40L/QtdC90LrQvg==?= 
        <bogdan.pylypenko107@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210418063457.B02ACC433D3@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 06:34:57 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Using a kernel with the Undefined Behaviour Sanity Checker (UBSAN) enabled, the
> following array overrun is logged:
> 
> ================================================================================
> UBSAN: array-index-out-of-bounds in /home/finger/wireless-drivers-next/drivers/net/wireless/realtek/rtw88/phy.c:1789:34
> index 5 is out of range for type 'u8 [5]'
> CPU: 2 PID: 84 Comm: kworker/u16:3 Tainted: G           O      5.12.0-rc5-00086-gd88bba47038e-dirty #651
> Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.50   09/29/2014
> Workqueue: phy0 ieee80211_scan_work [mac80211]
> Call Trace:
>  dump_stack+0x64/0x7c
>  ubsan_epilogue+0x5/0x40
>  __ubsan_handle_out_of_bounds.cold+0x43/0x48
>  rtw_get_tx_power_params+0x83a/drivers/net/wireless/realtek/rtw88/0xad0 [rtw_core]
>  ? rtw_pci_read16+0x20/0x20 [rtw_pci]
>  ? check_hw_ready+0x50/0x90 [rtw_core]
>  rtw_phy_get_tx_power_index+0x4d/0xd0 [rtw_core]
>  rtw_phy_set_tx_power_level+0xee/0x1b0 [rtw_core]
>  rtw_set_channel+0xab/0x110 [rtw_core]
>  rtw_ops_config+0x87/0xc0 [rtw_core]
>  ieee80211_hw_config+0x9d/0x130 [mac80211]
>  ieee80211_scan_state_set_channel+0x81/0x170 [mac80211]
>  ieee80211_scan_work+0x19f/0x2a0 [mac80211]
>  process_one_work+0x1dd/0x3a0
>  worker_thread+0x49/0x330
>  ? rescuer_thread+0x3a0/0x3a0
>  kthread+0x134/0x150
>  ? kthread_create_worker_on_cpu+0x70/0x70
>  ret_from_fork+0x22/0x30
> ================================================================================
> 
> The statement where an array is being overrun is shown in the following snippet:
> 
> 	if (rate <= DESC_RATE11M)
> 		tx_power = pwr_idx_2g->cck_base[group];
> 	else
> ====>		tx_power = pwr_idx_2g->bw40_base[group];
> 
> The associated arrays are defined in main.h as follows:
> 
> struct rtw_2g_txpwr_idx {
> 	u8 cck_base[6];
> 	u8 bw40_base[5];
> 	struct rtw_2g_1s_pwr_idx_diff ht_1s_diff;
> 	struct rtw_2g_ns_pwr_idx_diff ht_2s_diff;
> 	struct rtw_2g_ns_pwr_idx_diff ht_3s_diff;
> 	struct rtw_2g_ns_pwr_idx_diff ht_4s_diff;
> };
> 
> The problem arises because the value of group is 5 for channel 14. The trivial
> increase in the dimension of bw40_base fails as this struct must match the layout of
> efuse. The fix is to add the rate as an argument to rtw_get_channel_group() and set
> the group for channel 14 to 4 if rate <= DESC_RATE11M.
> 
> This patch fixes commit fa6dfe6bff24 ("rtw88: resolve order of tx power setting routines")
> 
> Fixes: fa6dfe6bff24 ("rtw88: resolve order of tx power setting routines")
> Reported-by: Богдан Пилипенко <bogdan.pylypenko107@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Stable <stable@vger.kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

2ff25985ea9c rtw88: Fix array overrun in rtw_get_tx_power_params()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210401192717.28927-1-Larry.Finger@lwfinger.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

