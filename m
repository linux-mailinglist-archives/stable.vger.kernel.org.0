Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE52036C5CA
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 14:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbhD0MIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 08:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235501AbhD0MIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 08:08:13 -0400
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3735C061756;
        Tue, 27 Apr 2021 05:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=skogtun.org
        ; s=ds202012; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yNQKTiaSX9YkEw5rvnmDnAQkpI15JsyRTEcsnXXwEEg=; b=XvpfghEsS3gej5oU+L7gQHaTa2
        11pJcImwautxN3ZRA+GAariMvsYFtY/LpTQdOutSo8KeOiaPL07jLLZ1aEg5CC05pSI7Js1F+OjMr
        P93SBTC8MKbVwGw45xmRGdGwBKla4L+zFtyvSkuIRcau1yiSSGqqurRse4gorjj6ACLbnXXCHuOgA
        5DSHAbXpbvkaErpY5bj1+NkOSSQ11xKuf7YtuEUnFVzs/9GkPiZvE+Hj/KsGVc34Z83vnDvpWqETJ
        zjol43RQXANlxETBvrD8Cskk3jfySgLfZF3oWKsoaEVxgX4LAZaWaBZpji9DgOuvhWV3xs2QGJhQK
        y9NFYmfw==;
Received: from [2001:4643:10eb:0:200:5e10:0:6] (port=48594)
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <harald@skogtun.org>)
        id 1lbMUy-0000M8-EV; Tue, 27 Apr 2021 14:07:28 +0200
Subject: Re: [PATCH] cfg80211: fix locking in netlink owner interface
 destruction
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
References: <20210427114946.aa0879857e8f.I846942fa5fc6ec92cda98f663df323240c49893a@changeid>
From:   Harald Arnesen <harald@skogtun.org>
Message-ID: <07e5bcb9-7de3-2e0a-cdeb-adc0dd4f1fd4@skogtun.org>
Date:   Tue, 27 Apr 2021 14:07:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210427114946.aa0879857e8f.I846942fa5fc6ec92cda98f663df323240c49893a@changeid>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I can confirm that the machine reboots with this patch applied.
Harald Arnesen


Johannes Berg [27.04.2021 11:49]:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Harald Arnesen reported [1] a deadlock at reboot time, and after
> he captured a stack trace a picture developed of what's going on:
> 
> The distribution he's using is using iwd (not wpa_supplicant) to
> manage wireless. iwd will usually use the "socket owner" option
> when it creates new interfaces, so that they're automatically
> destroyed when it quits (unexpectedly or otherwise). This is also
> done by wpa_supplicant, but it doesn't do it for the normal one,
> only for additional ones, which is different with iwd.
> 
> Anyway, during shutdown, iwd quits while the netdev is still UP,
> i.e. IFF_UP is set. This causes the stack trace that Linus so
> nicely transcribed from the pictures:
> 
> cfg80211_destroy_iface_wk() takes wiphy_lock
>  -> cfg80211_destroy_ifaces()
>   ->ieee80211_del_iface
>     ->ieeee80211_if_remove
>       ->cfg80211_unregister_wdev
>         ->unregister_netdevice_queue
>           ->dev_close_many
>             ->__dev_close_many
>               ->raw_notifier_call_chain
>                 ->cfg80211_netdev_notifier_call
> and that last call tries to take wiphy_lock again.
> 
> In commit a05829a7222e ("cfg80211: avoid holding the RTNL when
> calling the driver") I had taken into account the possibility of
> recursing from cfg80211 into cfg80211_netdev_notifier_call() via
> the network stack, but only for NETDEV_UNREGISTER, not for what
> happens here, NETDEV_GOING_DOWN and NETDEV_DOWN notifications.
> 
> Additionally, while this worked still back in commit 78f22b6a3a92
> ("cfg80211: allow userspace to take ownership of interfaces"), it
> missed another corner case: unregistering a netdev will cause
> dev_close() to be called, and thus stop wireless operations (e.g.
> disconnecting), but there are some types of virtual interfaces in
> wifi that don't have a netdev - for that we need an additional
> call to cfg80211_leave().
> 
> So, to fix this mess, change cfg80211_destroy_ifaces() to not
> require the wiphy_lock(), but instead make it acquire it, but
> only after it has actually closed all the netdevs on the list,
> and then call cfg80211_leave() as well before removing them
> from the driver, to fix the second issue. The locking change in
> this requires modifying the nl80211 call to not get the wiphy
> lock passed in, but acquire it by itself after flushing any
> potentially pending destruction requests.
> 
> [1] https://lore.kernel.org/r/09464e67-f3de-ac09-28a3-e27b7914ee7d@skogtun.org
> 
> Cc: stable@vger.kernel.org # 5.12
> Reported-by: Harald Arnesen <harald@skogtun.org>
> Fixes: 776a39b8196d ("cfg80211: call cfg80211_destroy_ifaces() with wiphy lock held")
> Fixes: 78f22b6a3a92 ("cfg80211: allow userspace to take ownership of interfaces")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Linus, I'll send this the regular way, just CC'ing you since
> you were involved in the debug.
> ---
>  net/wireless/core.c    | 21 +++++++++++++++++----
>  net/wireless/nl80211.c | 24 +++++++++++++++++++-----
>  2 files changed, 36 insertions(+), 9 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index a2785379df6e..589ee5a69a2e 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -332,14 +332,29 @@ static void cfg80211_event_work(struct work_struct *work)
>  void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev)
>  {
>  	struct wireless_dev *wdev, *tmp;
> +	bool found = false;
>  
>  	ASSERT_RTNL();
> -	lockdep_assert_wiphy(&rdev->wiphy);
>  
> +	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
> +		if (wdev->nl_owner_dead) {
> +			if (wdev->netdev)
> +				dev_close(wdev->netdev);
> +			found = true;
> +		}
> +	}
> +
> +	if (!found)
> +		return;
> +
> +	wiphy_lock(&rdev->wiphy);
>  	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
> -		if (wdev->nl_owner_dead)
> +		if (wdev->nl_owner_dead) {
> +			cfg80211_leave(rdev, wdev);
>  			rdev_del_virtual_intf(rdev, wdev);
> +		}
>  	}
> +	wiphy_unlock(&rdev->wiphy);
>  }
>  
>  static void cfg80211_destroy_iface_wk(struct work_struct *work)
> @@ -350,9 +365,7 @@ static void cfg80211_destroy_iface_wk(struct work_struct *work)
>  			    destroy_work);
>  
>  	rtnl_lock();
> -	wiphy_lock(&rdev->wiphy);
>  	cfg80211_destroy_ifaces(rdev);
> -	wiphy_unlock(&rdev->wiphy);
>  	rtnl_unlock();
>  }
>  
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index b1df42e4f1eb..a5224da63832 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3929,7 +3929,7 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
>  	return err;
>  }
>  
> -static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
> +static int _nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>  	struct vif_params params;
> @@ -3938,9 +3938,6 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>  	int err;
>  	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
>  
> -	/* to avoid failing a new interface creation due to pending removal */
> -	cfg80211_destroy_ifaces(rdev);
> -
>  	memset(&params, 0, sizeof(params));
>  
>  	if (!info->attrs[NL80211_ATTR_IFNAME])
> @@ -4028,6 +4025,21 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>  	return genlmsg_reply(msg, info);
>  }
>  
> +static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	int ret;
> +
> +	/* to avoid failing a new interface creation due to pending removal */
> +	cfg80211_destroy_ifaces(rdev);
> +
> +	wiphy_lock(&rdev->wiphy);
> +	ret = _nl80211_new_interface(skb, info);
> +	wiphy_unlock(&rdev->wiphy);
> +
> +	return ret;
> +}
> +
>  static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> @@ -15040,7 +15052,9 @@ static const struct genl_small_ops nl80211_small_ops[] = {
>  		.doit = nl80211_new_interface,
>  		.flags = GENL_UNS_ADMIN_PERM,
>  		.internal_flags = NL80211_FLAG_NEED_WIPHY |
> -				  NL80211_FLAG_NEED_RTNL,
> +				  NL80211_FLAG_NEED_RTNL |
> +				  /* we take the wiphy mutex later ourselves */
> +				  NL80211_FLAG_NO_WIPHY_MTX,
>  	},
>  	{
>  		.cmd = NL80211_CMD_DEL_INTERFACE,
> 


-- 
Hilsen Harald
