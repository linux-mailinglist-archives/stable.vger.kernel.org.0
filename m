Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D590F1B56CF
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 09:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgDWH7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 03:59:18 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47310 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWH7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 03:59:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jRWlM-00EkpM-0v; Thu, 23 Apr 2020 09:59:12 +0200
Message-ID: <885ae3bffad315445be3fc70cccade9067ee6937.camel@sipsolutions.net>
Subject: Re: Commit "mac80211: fix race in ieee80211_register_hw()" breaks
 mac80211 debugfs
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sumit Garg <sumit.garg@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, stable <stable@vger.kernel.org>
Date:   Thu, 23 Apr 2020 09:59:10 +0200
In-Reply-To: <CAFA6WYN3FbqTivGJTfXtHsMjXNPXW+P4MZWiCL14utF2sHkeYg@mail.gmail.com> (sfid-20200423_093447_121680_FAE877E7)
References: <c304ad9c-f404-d22e-de74-9398da3ebfc3@hauke-m.de>
         <CAFA6WYN3FbqTivGJTfXtHsMjXNPXW+P4MZWiCL14utF2sHkeYg@mail.gmail.com>
         (sfid-20200423_093447_121680_FAE877E7)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hauke, Sumit,

> > Felix reported that the file /sys/kernel/debug/ieee80211/phy0/rc is now
> > located at /sys/kernel/debug/rc.

Yeah, we noticed this the other day too.

> +++ b/net/wireless/core.c
> @@ -473,6 +473,10 @@ struct wiphy *wiphy_new_nm(const struct
> cfg80211_ops *ops, int sizeof_priv,
>                 }
>         }
> 
> +       /* add to debugfs */
> +       rdev->wiphy.debugfsdir = debugfs_create_dir(wiphy_name(&rdev->wiphy),
> +                                                   ieee80211_debugfs_dir);

This cannot work, we haven't committed to the name of the wiphy yet at
this point.

I have some fixes, I'll send them out asap.

johannes

