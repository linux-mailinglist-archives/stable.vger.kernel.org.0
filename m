Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CB6381866
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 13:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhEOLiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 07:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhEOLiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 07:38:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E46C06174A;
        Sat, 15 May 2021 04:36:45 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h4so1633060wrt.12;
        Sat, 15 May 2021 04:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cSp8LF2MME6Ckv5v8oMTTz5JcuCknELMGg+c5XDNUMQ=;
        b=AAv2pP43L4XNX9IIGIqkicts0NEsASnURbw12nDHEZh60mkAVwI+dvzAZw3g7jCtU0
         jgV6YTWCv0mEE4bdJhnyNd3tr4qck0U03AU6hzgnPF8wCVav3HWRX9KdD7qV38+GBuHD
         vxjxoSDtWWlHIWfzgG4FcK5ifBOXvwPshnLAcFF3w3DrvE9PMWiXVp2oMXZn32IzTkGz
         9mklfa2GnRmBK/sWXJUrDyQnz/vrA76Fg83VcEN3qSzySo2JxEWg3BlQnaVoZMch953p
         X8tOwGUyp74sep9tHnN9WWEwSVV/1mCHtqEO2zeh5YjawzeDRvGkV5qQufvD4F2WeYDw
         A4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cSp8LF2MME6Ckv5v8oMTTz5JcuCknELMGg+c5XDNUMQ=;
        b=o+OWLXk585OhLc1QkD7OD15ABMv9h0YS5bNcWoosxYDc180iWbVmeS3aG1p39eXqCR
         Xh+K1UILfewYl50KayqCZwyxiA5AD9qLsWgSVg6ZdzPpLxExu9dqCPrrNHmPm8ebP6rB
         BGYHFMpUYb4RzXVfWNEYaV18tWTVrDSvE9WWk0td1MRVj4pmCCoWCAApExAESJNKej+O
         2f84KonMcDiFr+q1fZyAty0d7k40VJMtvAHkNX1OnOhqJM1CEgzEEXOyvjCbNUeqMr0D
         PNtB9MGz7mTjhyuPH0X/W1HjwDmI1Xf6vQ8GJlQ7oD0z+AnJlniNwwKaY6779YQh9IFh
         6pCQ==
X-Gm-Message-State: AOAM532i1BOq/wHn2Ks1it8j2ueusMTjAxqvip+trET31BfAlsoLlFTo
        8CZ95Ub+uuASKXWksR3nHro=
X-Google-Smtp-Source: ABdhPJx1ButsfSEjAXN6qGgyzcNJEEMhGdDV3wHwDdeU6og+qTPgGl0hk7ttYTIlYCwZRSa7lbcogQ==
X-Received: by 2002:adf:f907:: with SMTP id b7mr36216530wrr.357.1621078603774;
        Sat, 15 May 2021 04:36:43 -0700 (PDT)
Received: from [192.168.2.202] (p5487bcad.dip0.t-ipconnect.de. [84.135.188.173])
        by smtp.gmail.com with ESMTPSA id j18sm7256135wmq.27.2021.05.15.04.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 May 2021 04:36:43 -0700 (PDT)
Subject: Re: [PATCH 5.13] mwifiex: bring down link before deleting interface
To:     Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>, stable@vger.kernel.org,
        dave@bewaar.me, Johannes Berg <johannes@sipsolutions.net>
References: <20210515024227.2159311-1-briannorris@chromium.org>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <c6f3b4dd-bf4f-bd28-7b8f-35c18a89a64a@gmail.com>
Date:   Sat, 15 May 2021 13:36:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210515024227.2159311-1-briannorris@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/21 4:42 AM, Brian Norris wrote:
> We can deadlock when rmmod'ing the driver or going through firmware
> reset, because the cfg80211_unregister_wdev() has to bring down the link
> for us, ... which then grab the same wiphy lock.
> 
> nl80211_del_interface() already handles a very similar case, with a nice
> description:
> 
>          /*
>           * We hold RTNL, so this is safe, without RTNL opencount cannot
>           * reach 0, and thus the rdev cannot be deleted.
>           *
>           * We need to do it for the dev_close(), since that will call
>           * the netdev notifiers, and we need to acquire the mutex there
>           * but don't know if we get there from here or from some other
>           * place (e.g. "ip link set ... down").
>           */
>          mutex_unlock(&rdev->wiphy.mtx);
> ...
> 
> Do similarly for mwifiex teardown, by ensuring we bring the link down
> first.
> 
> Sample deadlock trace:
> 
> [  247.103516] INFO: task rmmod:2119 blocked for more than 123 seconds.
> [  247.110630]       Not tainted 5.12.4 #5
> [  247.115796] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  247.124557] task:rmmod           state:D stack:    0 pid: 2119 ppid:  2114 flags:0x00400208
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
> Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-wireless/98392296-40ee-6300-369c-32e16cff3725@gmail.com/
> Link: https://lore.kernel.org/linux-wireless/ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me/
> Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
> Reported-by: dave@bewaar.me
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Thanks!

Tested-by: Maximilian Luz <luzmaximilian@gmail.com>

> ---
>   drivers/net/wireless/marvell/mwifiex/main.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 529dfd8b7ae8..17399d4aa129 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1445,11 +1445,18 @@ static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
>   		if (!priv)
>   			continue;
>   		rtnl_lock();
> -		wiphy_lock(adapter->wiphy);
>   		if (priv->netdev &&
> -		    priv->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED)
> +		    priv->wdev.iftype != NL80211_IFTYPE_UNSPECIFIED) {
> +			/*
> +			 * Close the netdev now, because if we do it later, the
> +			 * netdev notifiers will need to acquire the wiphy lock
> +			 * again --> deadlock.
> +			 */
> +			dev_close(priv->wdev.netdev);
> +			wiphy_lock(adapter->wiphy);
>   			mwifiex_del_virtual_intf(adapter->wiphy, &priv->wdev);
> -		wiphy_unlock(adapter->wiphy);
> +			wiphy_unlock(adapter->wiphy);
> +		}
>   		rtnl_unlock();
>   	}
>   
> 
