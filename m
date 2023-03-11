Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B6F6B5A3B
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 10:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCKJ4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 04:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCKJ4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 04:56:11 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C626108C31;
        Sat, 11 Mar 2023 01:56:07 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 4F13C4248B;
        Sat, 11 Mar 2023 09:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1678528565; bh=WQv2RM/H+Nf4R69KWM6AeKDOyfaE/rl12gYu1zrMuhA=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=SqOErT1KAlhIuLV+rx0mU8z3+CrRCo+bXoJByLk2tPaYXbO4YzMF6dbNfLIlBuzhJ
         jwd/PRoU8bInf86qPwfzw0yCJnHjsU67+zaowvR4duC1m0q8CQx+sGipA5QvaXH9cr
         DpaL4Y9jLgNvw5btVCKH/B47vOwvNk81pmzz0NK1i45pGtbavijv5lV2mcJlsNknQA
         cKw2T9MsA9X8qYLOS8sseGXcjHj9yK24iwJEPfcRkVlg0S7+YVnSgJpuaZjDTj0+mt
         RsKpzUwTiY23AcYKiu4+4nIOcxa/J7h3X/vRdqFz20KBJ7IRJcPzAoZCqdIAoaBsuv
         iHOBBjvLFPCWw==
Message-ID: <d6851c2b-7966-6cb4-a51c-7268c60e0a86@marcan.st>
Date:   Sat, 11 Mar 2023 18:55:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Alexander Wetzel <alexander@wetzel-home.de>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org,
        Asahi Linux <asahi@lists.linux.dev>, Ilya <me@0upti.me>,
        Janne Grunau <j@jannau.net>,
        LKML <linux-kernel@vger.kernel.org>, regressions@lists.linux.dev
References: <20230124141856.356646-1-alexander@wetzel-home.de>
From:   Hector Martin <marcan@marcan.st>
Subject: [REGRESSION] Patch broke WPA auth: Re: [PATCH v2] wifi: cfg80211: Fix
 use after free for wext
In-Reply-To: <20230124141856.356646-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This broke WPA auth entirely on brcmfmac (in offload mode) and probably
others, including on stable 6.2.3 and 6.3-rc1 (tested with iwd). Please
revert or fix. Notes below.

Reported-by: Ilya <me@0upti.me>
Reported-by: Janne Grunau <j@jannau.net>

#regzbot introduced: 015b8cc5e7c4d7
#regzbot monitor:
https://lore.kernel.org/linux-wireless/20230124141856.356646-1-alexander@wetzel-home.de/

On 24/01/2023 23.18, Alexander Wetzel wrote:
> Key information in wext.connect is not reset on (re)connect and can hold
> data from a previous connection.
> 
> Reset key data to avoid that drivers or mac80211 incorrectly detect a
> WEP connection request and access the freed or already reused memory.
> 
> Additionally optimize cfg80211_sme_connect() and avoid an useless
> schedule of conn_work.
> 
> Fixes: fffd0934b939 ("cfg80211: rework key operation")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/c80f04d2-8159-a02a-9287-26e5ec838826@wetzel-home.de
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> 
> ---
> V2 changes:
> - updated comment
> - reset more key data
> 
> ---
>  net/wireless/sme.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 123248b2c0be..0cc841c0c59b 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
[snip]
> @@ -1464,6 +1476,15 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,

This if branch only fires if the connection is WEP.

>  	} else {
>  		if (WARN_ON(connkeys))
>  			return -EINVAL;
> +
> +		/* connect can point to wdev->wext.connect which
> +		 * can hold key data from a previous connection
> +		 */
> +		connect->key = NULL;
> +		connect->key_len = 0;
> +		connect->key_idx = 0;

And these are indeed only used by WEP.

> +		connect->crypto.cipher_group = 0;
> +		connect->crypto.n_ciphers_pairwise = 0;

But here you're killing the info that is used for *other* auth modes too
if !WEP, breaking WPA and everything else.

>  	}
>  
>  	wdev->connect_keys = connkeys;

- Hector
