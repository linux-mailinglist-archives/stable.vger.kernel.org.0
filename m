Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E4336368C
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 18:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhDRQL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 12:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhDRQLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 12:11:55 -0400
X-Greylist: delayed 528 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Apr 2021 09:11:27 PDT
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F120C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 09:11:27 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5b07e8e5.dip0.t-ipconnect.de [91.7.232.229])
        by mail.itouring.de (Postfix) with ESMTPSA id 5A2DC1255C7;
        Sun, 18 Apr 2021 18:02:32 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id E1AB4F015C1;
        Sun, 18 Apr 2021 18:02:31 +0200 (CEST)
Subject: Re: FAILED: patch "[PATCH] r8169: don't advertise pause in jumbo
 mode" failed to apply to 5.10-stable tree
To:     Heiner Kallweit <hkallweit1@gmail.com>, stable@vger.kernel.org
References: <161874219017114@kroah.com>
 <c4028e4f-6901-f5f5-a213-4435243f1058@gmail.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <5118f703-1e4a-4dbe-b9e0-3ec9b9cfc6ea@applied-asynchrony.com>
Date:   Sun, 18 Apr 2021 18:02:31 +0200
MIME-Version: 1.0
In-Reply-To: <c4028e4f-6901-f5f5-a213-4435243f1058@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-04-18 17:54, Heiner Kallweit wrote:
> On 18.04.2021 12:36, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.10-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> >From 453a77894efa4d9b6ef9644d74b9419c47ac427c Mon Sep 17 00:00:00 2001
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Date: Wed, 14 Apr 2021 10:47:10 +0200
>> Subject: [PATCH] r8169: don't advertise pause in jumbo mode
>>
>> It has been reported [0] that using pause frames in jumbo mode impacts
>> performance. There's no available chip documentation, but vendor
>> drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
>> do the same, according to Roman it fixes the issue.
>>
>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=212617
>>
>> Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
>> Reported-by: Roman Mamedov <rm+bko@romanrm.net>
>> Tested-by: Roman Mamedov <rm+bko@romanrm.net>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 581a92fc3292..1df2c002c9f6 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -2350,6 +2350,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
>>   
>>   	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
>>   		pcie_set_readrq(tp->pci_dev, readrq);
>> +
>> +	/* Chip doesn't support pause in jumbo mode */
>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>> +			 tp->phydev->advertising, !jumbo);
>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>> +			 tp->phydev->advertising, !jumbo);
>> +	phy_start_aneg(tp->phydev);
>>   }
>>   
>>   DECLARE_RTL_COND(rtl_chipcmd_cond)
>> @@ -4630,8 +4637,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>>   	if (!tp->supports_gmii)
>>   		phy_set_max_speed(phydev, SPEED_100);
>>   
>> -	phy_support_asym_pause(phydev);
>> -
>>   	phy_attached_info(phydev);
>>   
>>   	return 0;
>>
> 
>>From ed6aaf67921a7ed44a3e07785c2125835ca5a969 Mon Sep 17 00:00:00 2001
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Sun, 18 Apr 2021 17:50:06 +0200
> Subject: [PATCH] r8169: don't advertise pause in jumbo mode
> 
> It has been reported [0] that using pause frames in jumbo mode impacts
> performance. There's no available chip documentation, but vendor
> drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
> do the same, according to Roman it fixes the issue.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=212617
> 
> Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
> Reported-by: Roman Mamedov <rm+bko@romanrm.net>
> Tested-by: Roman Mamedov <rm+bko@romanrm.net>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>   drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index d634da20b4f9..feca75eb75e4 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2419,6 +2419,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
>   
>   	if (!jumbo && pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
>   		pcie_set_readrq(tp->pci_dev, 4096);
> +
> +	/* Chip doesn't support pause in jumbo mode */
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +			 tp->phydev->advertising, !jumbo);
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +			 tp->phydev->advertising, !jumbo);
> +	phy_start_aneg(tp->phydev);
>   }
>   
>   DECLARE_RTL_COND(rtl_chipcmd_cond)
> @@ -4710,8 +4717,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>   	if (!tp->supports_gmii)
>   		phy_set_max_speed(phydev, SPEED_100);
>   
> -	phy_support_asym_pause(phydev);
> -
>   	phy_attached_info(phydev);
>   
>   	return 0;
> 

I've *just* been looking into this as well (new machine with an r8169 onboard..sigh)
and found that simply applying 5e00e16cb989 ("r8169: tweak max read request size for
newer chips also in jumbo mtu mode") makes it apply cleanly. Said patch also seems
(to me) make sense by itself, so maybe just pick that instead?

thanks,
Holger
