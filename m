Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7706E381986
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 17:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhEOPSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 11:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhEOPSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 11:18:16 -0400
X-Greylist: delayed 385 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 15 May 2021 08:17:02 PDT
Received: from outbound3.mail.transip.nl (outbound3.mail.transip.nl [IPv6:2a01:7c8:7c9:ca11:136:144:136:12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7463C061573
        for <stable@vger.kernel.org>; Sat, 15 May 2021 08:17:02 -0700 (PDT)
Received: from submission6.mail.transip.nl (unknown [10.103.8.157])
        by outbound3.mail.transip.nl (Postfix) with ESMTP id 4Fj83G679FzlkTd;
        Sat, 15 May 2021 17:10:34 +0200 (CEST)
Received: from transip.email (unknown [10.103.8.118])
        by submission6.mail.transip.nl (Postfix) with ESMTPA id 4Fj83D09SZz12LLZ;
        Sat, 15 May 2021 17:10:31 +0200 (CEST)
MIME-Version: 1.0
Date:   Sat, 15 May 2021 17:10:31 +0200
From:   Dave Olsthoorn <dave@bewaar.me>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>, stable@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5.13] mwifiex: bring down link before deleting interface
In-Reply-To: <20210515024227.2159311-1-briannorris@chromium.org>
References: <20210515024227.2159311-1-briannorris@chromium.org>
Message-ID: <713286ddc100bd63a9dbefdece39c935@bewaar.me>
X-Sender: dave@bewaar.me
User-Agent: Webmail
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: ClueGetter at submission6.mail.transip.nl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=transip-a; d=bewaar.me; t=1621091434; h=from:subject:to:cc:
 references:in-reply-to:date:mime-version:content-type;
 bh=xi/Gjcr5n9G9VABIuXaOgf1ld1MiL0kidF6MW+Mvzrk=;
 b=dgLwY0HjBBuzKkJzH24lvQSrUgu5Ep2yGyXUP2S2AoexovjSj9sBq571BStgK2yX4etC7y
 nTUdyUK/sUnlOt9L4hbDl6qiaHNreDIpTATHq2GiCTCiiPviJVdfUuBMXLiHrlC0Ct//9z
 zVTm7UYJB990g6UCuCoSKbe5II0A92FAvl+0r9BWmY/sDSQt4wkTdgtIPKm5VV9nTPhjRs
 bQglze0kl0KkykkVrKpQQ8qXpHw1xlxGq3YveM95Y50XqUyXzDRr0DnWyWPgykk5tf01a7
 FVA9U8qqC+H9WCCAFeGOQq0aIJLogl4RhR0kTN0d1VrTG0zqvGSzSUujQ1AMpQ==
X-Report-Abuse-To: abuse@transip.nl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-15 04:42, Brian Norris wrote:
> We can deadlock when rmmod'ing the driver or going through firmware
> reset, because the cfg80211_unregister_wdev() has to bring down the 
> link
> for us, ... which then grab the same wiphy lock.
> 
> nl80211_del_interface() already handles a very similar case, with a 
> nice
> description:
> 
>         /*
>          * We hold RTNL, so this is safe, without RTNL opencount cannot
>          * reach 0, and thus the rdev cannot be deleted.
>          *
>          * We need to do it for the dev_close(), since that will call
>          * the netdev notifiers, and we need to acquire the mutex there
>          * but don't know if we get there from here or from some other
>          * place (e.g. "ip link set ... down").
>          */
>         mutex_unlock(&rdev->wiphy.mtx);
> ...
> 
> Do similarly for mwifiex teardown, by ensuring we bring the link down
> first.
> 
> Sample deadlock trace:
> 
> [  247.103516] INFO: task rmmod:2119 blocked for more than 123 seconds.
> [  247.110630]       Not tainted 5.12.4 #5
> [  247.115796] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  247.124557] task:rmmod           state:D stack:    0 pid: 2119
> ppid:  2114 flags:0x00400208
> [  247.133905] Call trace:
> [  247.136644]  __switch_to+0x130/0x170
> [  247.140643]  __schedule+0x714/0xa0c
> [  247.144548]  schedule_preempt_disabled+0x88/0xf4
> [  247.149714]  __mutex_lock_common+0x43c/0x750
> [  247.154496]  mutex_lock_nested+0x5c/0x68
> [  247.158884]  cfg80211_netdev_notifier_call+0x280/0x4e0 [cfg80211]
> [  247.165769]  raw_notifier_call_chain+0x4c/0x78
> [  247.170742]  call_netdevice_notifiers_info+0x68/0xa4
> [  247.176305]  __dev_close_many+0x7c/0x138
> [  247.180693]  dev_close_many+0x7c/0x10c
> [  247.184893]  unregister_netdevice_many+0xfc/0x654
> [  247.190158]  unregister_netdevice_queue+0xb4/0xe0
> [  247.195424]  _cfg80211_unregister_wdev+0xa4/0x204 [cfg80211]
> [  247.201816]  cfg80211_unregister_wdev+0x20/0x2c [cfg80211]
> [  247.208016]  mwifiex_del_virtual_intf+0xc8/0x188 [mwifiex]
> [  247.214174]  mwifiex_uninit_sw+0x158/0x1b0 [mwifiex]
> [  247.219747]  mwifiex_remove_card+0x38/0xa0 [mwifiex]
> [  247.225316]  mwifiex_pcie_remove+0xd0/0xe0 [mwifiex_pcie]
> [  247.231451]  pci_device_remove+0x50/0xe0
> [  247.235849]  device_release_driver_internal+0x110/0x1b0
> [  247.241701]  driver_detach+0x5c/0x9c
> [  247.245704]  bus_remove_driver+0x84/0xb8
> [  247.250095]  driver_unregister+0x3c/0x60
> [  247.254486]  pci_unregister_driver+0x2c/0x90
> [  247.259267]  cleanup_module+0x18/0xcdc [mwifiex_pcie]
> 
> Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the 
> driver")
> Cc: stable@vger.kernel.org
> Link:
> https://lore.kernel.org/linux-wireless/98392296-40ee-6300-369c-32e16cff3725@gmail.com/
> Link:
> https://lore.kernel.org/linux-wireless/ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me/
> Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
> Reported-by: Dave Olsthoorn <dave@bewaar.me>

Thanks!

The firmware still seems to crash quicker than previously, but that's a 
unrelated problem.

Tested-by: Dave Olsthoorn <dave@bewaar.me>

> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/main.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c
> b/drivers/net/wireless/marvell/mwifiex/main.c
> index 529dfd8b7ae8..17399d4aa129 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1445,11 +1445,18 @@ static void mwifiex_uninit_sw(struct
> mwifiex_adapter *adapter)
>  		if (!priv)
>  			continue;
>  		rtnl_lock();
> -		wiphy_lock(adapter->wiphy);
>  		if (priv->netdev &&
> -		    priv->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED)
> +		    priv->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED) {
> +			/*
> +			 * Close the netdev now, because if we do it later, the
> +			 * netdev notifiers will need to acquire the wiphy lock
> +			 * again --> deadlock.
> +			 */
> +			dev_close(priv->wdev.netdev);
> +			wiphy_lock(adapter->wiphy);
>  			mwifiex_del_virtual_intf(adapter->wiphy, &priv->wdev);
> -		wiphy_unlock(adapter->wiphy);
> +			wiphy_unlock(adapter->wiphy);
> +		}
>  		rtnl_unlock();
>  	}
