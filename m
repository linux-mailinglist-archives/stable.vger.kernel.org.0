Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32FD3638CB
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 02:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhDSAa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 20:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231860AbhDSAa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Apr 2021 20:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D5F6109F;
        Mon, 19 Apr 2021 00:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618792198;
        bh=v+mMExwjfZvuic9/6c+ByRE9N/1cBPMclyWCJVmu1Vg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LvjILQ2XCM9ateOeYnuHqEp8wUS6dv1BmKvYH80COZVo6LsoNWrUdMo0hDiEsCvXH
         gnD+QUJqKJ+ox1XOp40kUcHjydIKtU1jWxidNSvLW/f1naBEIzQsg53Jqf25a8xE1l
         s/f1HeflPNsbhrpSMLQwHn9qwVs+u/JLu5b1P9JM06zJ3s6NJf0Y/BtX3eTpOZxT04
         iXXGTiRYHuoUVwm83cRm/lIr0Wx9WEun//dJOFIBt2WAytsMGFgC0ri7kTCKHkpGiF
         ZYaCmyd7QSPC+eo63rqvsKPRpAsUb5Mv73+PUZonAkCwEuDnGKHE9xOJSXBE3idcG0
         tikgFatgAUTjQ==
Date:   Sun, 18 Apr 2021 20:29:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] r8169: don't advertise pause in jumbo
 mode" failed to apply to 5.4-stable tree
Message-ID: <YHzPBVyY5r9MD2IC@sashalap>
References: <161874218928233@kroah.com>
 <476069fb-8a0f-bd52-3f8e-5fbf6e0fab17@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <476069fb-8a0f-bd52-3f8e-5fbf6e0fab17@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 18, 2021 at 05:53:31PM +0200, Heiner Kallweit wrote:
>On 18.04.2021 12:36, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.4-stable tree.
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
>>>From 453a77894efa4d9b6ef9644d74b9419c47ac427c Mon Sep 17 00:00:00 2001
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
>>  	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
>>  		pcie_set_readrq(tp->pci_dev, readrq);
>> +
>> +	/* Chip doesn't support pause in jumbo mode */
>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>> +			 tp->phydev->advertising, !jumbo);
>> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>> +			 tp->phydev->advertising, !jumbo);
>> +	phy_start_aneg(tp->phydev);
>>  }
>>
>>  DECLARE_RTL_COND(rtl_chipcmd_cond)
>> @@ -4630,8 +4637,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>>  	if (!tp->supports_gmii)
>>  		phy_set_max_speed(phydev, SPEED_100);
>>
>> -	phy_support_asym_pause(phydev);
>> -
>>  	phy_attached_info(phydev);
>>
>>  	return 0;
>>
>
>>From 90501465d4f9be209587047db1560a310a9fce1b Mon Sep 17 00:00:00 2001
>From: Heiner Kallweit <hkallweit1@gmail.com>
>Date: Sun, 18 Apr 2021 17:42:13 +0200
>Subject: [PATCH] r8169: don't advertise pause in jumbo mode
>
>It has been reported [0] that using pause frames in jumbo mode impacts
>performance. There's no available chip documentation, but vendor
>drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
>do the same, according to Roman it fixes the issue.
>
>[0] https://bugzilla.kernel.org/show_bug.cgi?id=212617
>
>Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
>Reported-by: Roman Mamedov <rm+bko@romanrm.net>
>Tested-by: Roman Mamedov <rm+bko@romanrm.net>
>Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

I've resolved this by taking 5e00e16cb989 ("r8169: tweak max read
request size for newer chips also in jumbo mtu mode") instead, thanks!

-- 
Thanks,
Sasha
