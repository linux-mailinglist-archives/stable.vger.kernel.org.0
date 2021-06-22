Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC04B3B1069
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 01:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFVXRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 19:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFVXRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 19:17:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48CB610C7;
        Tue, 22 Jun 2021 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624403714;
        bh=349vokvWXUEULt4QgtywirkV5miPSSIT3xH8DDEkvjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qk/vKHetrr3/B3YKvC0vS4LkzCJKc85/DAR8l4nvz6z1jHSu8MSdBqn1V9D5bxy/W
         kskDrIzFWxbbiGt++b5b2r3eVwpd/5AIcC+b/PZXHlzjqXKNoA2En4eGFZHWdaBl/7
         BYDEC2mOMd3/r1iIcoCMdPjNnf8XSXFgeGQBFMVxuFfK14KZAw2J9evMtcB01GIcB1
         +fdD+cr1lIyOGGXkZi9ihHEkcTJXqBLRVs7+YSyET3RzfOkOmP1tXCNsjuxLxNxpYb
         9rzt5zoRe8rDkxZnw53+PEfy/d1aZ5M+LqwVUVyZqiE9SuqYvA/ICJYGN+29irnU66
         hfDPhrPCePBTg==
Received: by pali.im (Postfix)
        id 80BFBCBA; Wed, 23 Jun 2021 01:15:11 +0200 (CEST)
Date:   Wed, 23 Jun 2021 01:15:11 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 11/12] mac80211: drop data frames without key on
 encrypted links
Message-ID: <20210622231511.nb7o2sohnnz5qdhi@pali>
References: <iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid>
 <20200327150342.252AF20748@mail.kernel.org>
 <20210611101046.zej2t2oc6hsc67yv@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210611101046.zej2t2oc6hsc67yv@pali>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday 11 June 2021 12:10:46 Pali Rohár wrote:
> On Friday 27 March 2020 15:03:41 Sasha Levin wrote:
> > This commit has been processed because it contains a -stable tag.
> > The stable tag indicates that it's relevant for the following trees: all
> > 
> > The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.
> > 
> > v5.5.11: Build OK!
> > v5.4.27: Build OK!
> > v4.19.112: Failed to apply! Possible dependencies:
> ...
> > v4.14.174: Failed to apply! Possible dependencies:
> ...
> > v4.9.217: Failed to apply! Possible dependencies:
> ...
> > v4.4.217: Failed to apply! Possible dependencies:
> ...
> > 
> > How should we proceed with this patch?
> 
> Hello! I have looked at this patch and backported it into 4.19 and older
> versions. But as this patch is security related and backporting needed
> some code changes, it is required to review this patch prior including
> it into any stable branch. Patch is below.

Hello Sasha and Greg!

Do you have any opinion how do you want to process this patch? I would
like to know if something else is needed from my side.

> The main change in backported patch is in ieee80211_key_replace()
> function.
> 
> So could you please review this patch if it is correct and if it is
> suitable for backporting it into stable kernels 4.19 in this (or other)
> form?

Johannes, you are the original author of this patch, what do you think,
would you be able to find some time and review at this backported patch?

> =======================================================================
> 
> From 189da5743e28d0c5d211b70b4cb06ce3aff77d86 Mon Sep 17 00:00:00 2001
> From: Johannes Berg <johannes.berg@intel.com>
> Date: Thu, 26 Mar 2020 15:09:42 +0200
> Subject: [PATCH] mac80211: drop data frames without key on encrypted links
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> commit a0761a301746ec2d92d7fcb82af69c0a6a4339aa upstream.
> 
> If we know that we have an encrypted link (based on having had
> a key configured for TX in the past) then drop all data frames
> in the key selection handler if there's no key anymore.
> 
> This fixes an issue with mac80211 internal TXQs - there we can
> buffer frames for an encrypted link, but then if the key is no
> longer there when they're dequeued, the frames are sent without
> encryption. This happens if a station is disconnected while the
> frames are still on the TXQ.
> 
> Detecting that a link should be encrypted based on a first key
> having been configured for TX is fine as there are no use cases
> for a connection going from with encryption to no encryption.
> With extended key IDs, however, there is a case of having a key
> configured for only decryption, so we can't just trigger this
> behaviour on a key being configured.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Jouni Malinen <j@w1.fi>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Link: https://lore.kernel.org/r/iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> [pali: Backported to 4.19 and older versions]
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  net/mac80211/debugfs_sta.c |  1 +
>  net/mac80211/key.c         |  7 +++++--
>  net/mac80211/sta_info.h    |  1 +
>  net/mac80211/tx.c          | 12 +++++++++---
>  4 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index 4105081dc1df..6f390c2e4c8e 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -80,6 +80,7 @@ static const char * const sta_flag_names[] = {
>  	FLAG(MPSP_OWNER),
>  	FLAG(MPSP_RECIPIENT),
>  	FLAG(PS_DELIVER),
> +	FLAG(USES_ENCRYPTION),
>  #undef FLAG
>  };
>  
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index f20bb39f492d..217db25a1afa 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -341,8 +341,11 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
>  	if (sta) {
>  		if (pairwise) {
>  			rcu_assign_pointer(sta->ptk[idx], new);
> -			sta->ptk_idx = idx;
> -			ieee80211_check_fast_xmit(sta);
> +			if (new) {
> +				set_sta_flag(new->sta, WLAN_STA_USES_ENCRYPTION);
> +				new->sta->ptk_idx = new->conf.keyidx;
> +				ieee80211_check_fast_xmit(new->sta);
> +			}
>  		} else {
>  			rcu_assign_pointer(sta->gtk[idx], new);
>  		}
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 9a04327d71d1..075609c4571d 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -101,6 +101,7 @@ enum ieee80211_sta_info_flags {
>  	WLAN_STA_MPSP_OWNER,
>  	WLAN_STA_MPSP_RECIPIENT,
>  	WLAN_STA_PS_DELIVER,
> +	WLAN_STA_USES_ENCRYPTION,
>  
>  	NUM_WLAN_STA_FLAGS,
>  };
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 98d048630ad2..3530d1a5fc98 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -593,10 +593,13 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
>  
> -	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
> +	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
>  		tx->key = NULL;
> -	else if (tx->sta &&
> -		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
> +		return TX_CONTINUE;
> +	}
> +
> +	if (tx->sta &&
> +	    (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
>  		tx->key = key;
>  	else if (ieee80211_is_group_privacy_action(tx->skb) &&
>  		(key = rcu_dereference(tx->sdata->default_multicast_key)))
> @@ -657,6 +660,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
>  		if (!skip_hw && tx->key &&
>  		    tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
>  			info->control.hw_key = &tx->key->conf;
> +	} else if (!ieee80211_is_mgmt(hdr->frame_control) && tx->sta &&
> +		   test_sta_flag(tx->sta, WLAN_STA_USES_ENCRYPTION)) {
> +		return TX_DROP;
>  	}
>  
>  	return TX_CONTINUE;
> -- 
> 2.20.1
