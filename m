Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85723B19AB
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 14:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFWMSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 08:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhFWMSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 08:18:37 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C53C061574;
        Wed, 23 Jun 2021 05:16:19 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lw1nh-00AYdK-GJ; Wed, 23 Jun 2021 14:16:13 +0200
Message-ID: <804462f2381df5fb30fba7e186e62375352b8adc.camel@sipsolutions.net>
Subject: Re: [PATCH v2 11/12] mac80211: drop data frames without key on
 encrypted links
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org
Date:   Wed, 23 Jun 2021 14:16:12 +0200
In-Reply-To: <20210611101046.zej2t2oc6hsc67yv@pali>
References: <iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid>
         <20200327150342.252AF20748@mail.kernel.org>
         <20210611101046.zej2t2oc6hsc67yv@pali>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-06-11 at 12:10 +0200, Pali Rohár wrote:
> 
> @@ -341,8 +341,11 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
>  	if (sta) {
>  		if (pairwise) {
>  			rcu_assign_pointer(sta->ptk[idx], new);
> -			sta->ptk_idx = idx;
> -			ieee80211_check_fast_xmit(sta);
> +			if (new) {
> +				set_sta_flag(new->sta, WLAN_STA_USES_ENCRYPTION);
> +				new->sta->ptk_idx = new->conf.keyidx;

I'm not entirely sure moving that assignment under the guard is correct.

> +				ieee80211_check_fast_xmit(new->sta);

and I'm pretty sure that moving call under the guard is incorrect,
although in the end it probably doesn't even matter if we will drop all
frames anyway (due to this patch).

So all you need under the assignment is the flag, but also only
theoretically, because the function cannot be called with old==NULL &&
new==NULL, the first time around it's called we must have old==NULL (no
key was ever installed), and so the first time it's called it must be
old==NULL && new!=NULL, and then the flag gets set and we never want to
clear it again, so I believe you don't need the "if (new)" condition at
all.

In the code as it was in (and before) my patch the condition is
necessary because we use 'new' to obtain the 'sta' and 'local' pointers,
but otherwise we don't really need it even in the current version.

johannes



