Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4725019C3AF
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 16:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388239AbgDBONJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 10:13:09 -0400
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:47132 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbgDBONJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 10:13:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jK0ae-0003b2-Dv; Thu, 02 Apr 2020 15:13:04 +0100
Message-ID: <b7a947dbf4222028149b12c9d63cfa2334664645.camel@codethink.co.uk>
Subject: Re: [PATCH 4.4 59/91] mac80211: mark station unauthorized before
 key removal
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 02 Apr 2020 15:13:02 +0100
In-Reply-To: <20200401161533.422920304@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
         <20200401161533.422920304@linuxfoundation.org>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-04-01 at 18:17 +0200, Greg Kroah-Hartman wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> commit b16798f5b907733966fd1a558fca823b3c67e4a1 upstream.
> 
> If a station is still marked as authorized, mark it as no longer
> so before removing its keys. This allows frames transmitted to it
> to be rejected, providing additional protection against leaking
> plain text data during the disconnection flow.
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20200326155133.ccb4fb0bb356.If48f0f0504efdcf16b8921f48c6d3bb2cb763c99@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  net/mac80211/sta_info.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -2,6 +2,7 @@
>   * Copyright 2002-2005, Instant802 Networks, Inc.
>   * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
>   * Copyright 2013-2014  Intel Mobile Communications GmbH
> + * Copyright (C) 2018-2020 Intel Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -904,6 +905,11 @@ static void __sta_info_destroy_part2(str
>  	might_sleep();
>  	lockdep_assert_held(&local->sta_mtx);
>  
> +	while (sta->sta_state == IEEE80211_STA_AUTHORIZED) {

So this should be retried forever?  Surely not.

Ben.

> +		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
> +		WARN_ON_ONCE(ret);
> +	}
> +
>  	/* now keys can no longer be reached */
>  	ieee80211_free_sta_keys(local, sta);
>  
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

