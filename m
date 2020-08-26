Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619122526C2
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 08:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgHZGSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 02:18:24 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44431 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbgHZGSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 02:18:21 -0400
Received: from [192.168.0.2] (ip5f5af678.dynamic.kabel-deutschland.de [95.90.246.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C3F7320225BDA;
        Wed, 26 Aug 2020 08:18:17 +0200 (CEST)
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Caleb Jorden <caljorden@hotmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
References: <20200826055150.2753.90553@ml01.vlan13.01.org>
Cc:     iwd@lists.01.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
Date:   Wed, 26 Aug 2020 08:18:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826055150.2753.90553@ml01.vlan13.01.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Dear Caleb,


Thank you for the report. Linux has a no regression policy, so the 
correct forum to report this to is the Linux kernel folks. I am adding 
the crypto and stable folks to the receiver list.

Am 26.08.20 um 07:51 schrieb caljorden@hotmail.com:

> I wanted to note an issue that I have hit with iwd when I upgraded to
> the Linux 5.8.3 stable kernel.  My office network uses WPA Enterprise
> with EAP-PEAPv0 + MSCHAPv2.  When using this office network,
> upgrading to Linux 5.8.3 caused my system to refuse to associate
> successfully to the network.  I get the following in my dmesg logs:
> 
> [   40.846535] wlan0: authenticate with <redacted>:60
> [   40.850570] wlan0: send auth to <redacted>:60 (try 1/3)
> [   40.854627] wlan0: authenticated
> [   40.855992] wlan0: associate with <redacted>:60 (try 1/3)
> [   40.860450] wlan0: RX AssocResp from <redacted>:60 (capab=0x411 status=0 aid=11)
> [   40.861620] wlan0: associated
> [   41.886503] wlan0: deauthenticating from <redacted>:60 by local choice (Reason: 23=IEEE8021X_FAILED)
> [   42.360127] wlan0: authenticate with <redacted>:22
> [   42.364584] wlan0: send auth to <redacted>:22 (try 1/3)
> [   42.370821] wlan0: authenticated
> [   42.372658] wlan0: associate with <redacted>:22 (try 1/3)
> [   42.377426] wlan0: RX AssocResp from <redacted>:22 (capab=0x411 status=0 aid=15)
> [   42.378607] wlan0: associated
> [   43.402009] wlan0: deauthenticating from <redacted>:22 by local choice (Reason: 23=IEEE8021X_FAILED)
> [   43.875921] wlan0: authenticate with <redacted>:60
> [   43.879988] wlan0: send auth to <redacted>:60 (try 1/3)
> [   43.886244] wlan0: authenticated
> [   43.889273] wlan0: associate with <redacted>:60 (try 1/3)
> [   43.894586] wlan0: RX AssocResp from <redacted>:60 (capab=0x411 status=0 aid=11)
> [   43.896077] wlan0: associated
> [   44.918504] wlan0: deauthenticating from <redacted>:60 by local choice (Reason: 23=IEEE8021X_FAILED)
> 
> This continues as long as I let iwd run.
> 
> I downgraded back to Linux 5.8.2, and verified that everything works
> as expected.  I also tried using Linux 5.8.3 on a different system at
> my home, which uses WPA2-PSK.  It worked fine (though it uses an
> Atheros wireless card instead of an Intel card - but I assume that is
> irrelevant).
> 
> I decided to try to figure out what caused the issue in the changes
> for Linux 5.8.3.  I assumed that it was something that changed in the
> crypto interface, which limited my bisection to a very few commits.
> Sure enough, I found that if I revert commit
> e91d82703ad0bc68942a7d91c1c3d993e3ad87f0 (crypto: algif_aead - Only
> wake up when ctx->more is zero), the problem goes away and I am able
> to associate to my WPA Enterprise network successfully, and use it.
> I found that in order to revert this commit, I also first had to
> revert 465c03e999102bddac9b1e132266c232c5456440 (crypto: af_alg - Fix
> regression on empty requests), because the two commits have coupled
> changes.
> 
> I normally would have assumed that this should be sent to the kernel
> list, but I thought I would first mention it here because of what I
> found in some email threads on the Linux-Crypto list about the crypto
> interfaces to the kernel being sub-optimal and needing to be fixed.
> The changes in these commits look like they are just trying to fix
> what could be broken interfaces, so I thought that it would make
> sense to see what the iwd team thinks about the situation first.
> 
> The wireless card I was using during this testing is an Intel
> Wireless 3165 (rev 81).  If there is any additional information I
> could help provide, please let me know.

It’d be great, if you verified, if the problem occurs with Linus’ master 
branch too.


Kind regards,

Paul
