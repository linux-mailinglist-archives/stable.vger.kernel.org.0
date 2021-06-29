Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD963B79E3
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 23:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhF2Veo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 17:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232997AbhF2Veo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 17:34:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 765AE61D9E;
        Tue, 29 Jun 2021 21:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625002336;
        bh=EMiFmObauTBFjIn01Av+zLtfvMYd+HseuPo9yGQNfQA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SFUeVkBgXF5f7LegA6lufe3ZDOD5WCnxIVsYrx0ohf1+jyg/52MRXaPZ7ldR/niza
         zaaEZX+dEKARd3SjRnawImGUzXGQx4QytoHtMpJxX12Jl4uXKG8egm1fuW8pIEd7mz
         /Y8lHdCTHLlI6IPVcr7hThwxQ9+z49IdtMANHfMwa83swuafVE/G31lpFPKtDVeoXQ
         QkVQefngiKTz8CvfJCV4mEZg+d2iCWU5727l8qXBu8M5ldh2zJnaPkJ+39c3/WvzFh
         RpDd1w+WyGOQgCANKhbwdpOztswBs9gD4vWf118sFFi1/bg7C+Xn/o9Vr5jo/RLrTp
         UpAKKdY/MvwLw==
Received: by pali.im (Postfix)
        id 414E6AA8; Tue, 29 Jun 2021 23:32:14 +0200 (CEST)
Date:   Tue, 29 Jun 2021 23:32:14 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Sasha Levin <sashal@kernel.org>, Luca Coelho <luca@coelho.fi>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 11/12] mac80211: drop data frames without key on
 encrypted links
Message-ID: <20210629213214.wgypgbxor7mhutni@pali>
References: <iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid>
 <20200327150342.252AF20748@mail.kernel.org>
 <20210611101046.zej2t2oc6hsc67yv@pali>
 <804462f2381df5fb30fba7e186e62375352b8adc.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <804462f2381df5fb30fba7e186e62375352b8adc.camel@sipsolutions.net>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 23 June 2021 14:16:12 Johannes Berg wrote:
> On Fri, 2021-06-11 at 12:10 +0200, Pali Rohár wrote:
> > 
> > @@ -341,8 +341,11 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
> >  	if (sta) {
> >  		if (pairwise) {
> >  			rcu_assign_pointer(sta->ptk[idx], new);
> > -			sta->ptk_idx = idx;
> > -			ieee80211_check_fast_xmit(sta);
> > +			if (new) {
> > +				set_sta_flag(new->sta, WLAN_STA_USES_ENCRYPTION);
> > +				new->sta->ptk_idx = new->conf.keyidx;
> 
> I'm not entirely sure moving that assignment under the guard is correct.
> 
> > +				ieee80211_check_fast_xmit(new->sta);
> 
> and I'm pretty sure that moving call under the guard is incorrect,
> although in the end it probably doesn't even matter if we will drop all
> frames anyway (due to this patch).
> 
> So all you need under the assignment is the flag, but also only
> theoretically, because the function cannot be called with old==NULL &&
> new==NULL, the first time around it's called we must have old==NULL (no
> key was ever installed), and so the first time it's called it must be
> old==NULL && new!=NULL, and then the flag gets set and we never want to
> clear it again, so I believe you don't need the "if (new)" condition at
> all.
> 
> In the code as it was in (and before) my patch the condition is
> necessary because we use 'new' to obtain the 'sta' and 'local' pointers,
> but otherwise we don't really need it even in the current version.
> 
> johannes

Now I see, thank you for explanation. So the code should be like this:

 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
+			set_sta_flag(sta, WLAN_STA_USES_ENCRYPTION);
 			sta->ptk_idx = idx;
 			ieee80211_check_fast_xmit(sta);
 		} else {

Right?
