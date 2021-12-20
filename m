Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4881147A7F4
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 11:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhLTKvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 05:51:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60858 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhLTKvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 05:51:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02ACEB80E35
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 10:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49201C36AE7;
        Mon, 20 Dec 2021 10:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639997503;
        bh=zwK6+dWcK6qpC0HJM6p2allqi8yXx7XStPgBeIk3mbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y6d1ueHfnzoPnTsbZhgZEmuK/YBei9Ao9QFdKO2HDWhWJz10ljcpFQWBn9B7f5X2m
         /QZJuS+brn97ELtdvQgPJ0Dup3rVSWLS/8sdoD3QA7vYdZatVyxwufZc98zItltoKe
         n8ZCbsFHwcQCPxrWtsyJ3RiA2Y/tWY6JXhVMbyDg=
Date:   Mon, 20 Dec 2021 11:51:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com
Subject: Re: [PATCH v5.4] mac80211: validate extended element ID is present
Message-ID: <YcBgPaBjnxotvwdf@kroah.com>
References: <20211217203706.55031-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217203706.55031-1-johannes@sipsolutions.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 09:37:06PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Commit 768c0b19b50665e337c96858aa2b7928d6dcf756 upstream.
> 
> Before attempting to parse an extended element, verify that
> the extended element ID is present.
> 
> Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
> Reported-by: syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/20211211201023.f30a1b128c07.I5cacc176da94ba316877c6e10fe3ceec8b4dbd7d@changeid
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/util.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index decd46b38393..c1c117fdf318 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1227,6 +1227,8 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
>  				elems->max_idle_period_ie = (void *)pos;
>  			break;
>  		case WLAN_EID_EXTENSION:
> +			if (!elen)
> +				break;
>  			if (pos[0] == WLAN_EID_EXT_HE_MU_EDCA &&
>  			    elen >= (sizeof(*elems->mu_edca_param_set) + 1)) {
>  				elems->mu_edca_param_set = (void *)&pos[1];
> -- 
> 2.33.1
> 

Now queued up, thanks.

greg k-h
