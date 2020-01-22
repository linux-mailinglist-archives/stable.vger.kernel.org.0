Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A656145D48
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 21:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgAVUtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 15:49:52 -0500
Received: from mail1.perex.cz ([77.48.224.245]:42556 "EHLO mail1.perex.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVUtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 15:49:52 -0500
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id CD3B5A003F;
        Wed, 22 Jan 2020 21:49:49 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz CD3B5A003F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1579726189; bh=P3Kp39KyT/Pvr8uGRVk6sasIqbfPwA+qafavKi1te/Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=vNx/xskWAXeLwGmtwdKeQQIopwF1We1BS2P6cka7AAFbUYD0ze3jUBHkeBHZnECNj
         zvGKO013YwARZXramFQyhBEaiXaMb86sk9Acv6NFlFpYlHgn6tpxspzklVqZxgE98p
         wzmviF8b69LqHbKNuhS0HP45Z2Pc0wVXOvH1abQA=
Received: from p50.perex-int.cz (unknown [192.168.100.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Wed, 22 Jan 2020 21:49:40 +0100 (CET)
Subject: Re: [alsa-devel] [PATCH] ASoC: topology: fix
 soc_tplg_fe_link_create() - link->dobj initialization order
To:     Mark Brown <broonie@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     ALSA development <alsa-devel@alsa-project.org>,
        Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Takashi Iwai <tiwai@suse.de>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200122190752.3081016-1-perex@perex.cz>
 <26ae4dbd-b1b8-c640-0dc0-d8c2bbe666e2@linux.intel.com>
 <20200122202530.GG3833@sirena.org.uk>
From:   Jaroslav Kysela <perex@perex.cz>
Message-ID: <045401f5-8d4c-cdc3-12fb-cf35148411e5@perex.cz>
Date:   Wed, 22 Jan 2020 21:49:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200122202530.GG3833@sirena.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dne 22. 01. 20 v 21:25 Mark Brown napsal(a):
> On Wed, Jan 22, 2020 at 01:28:57PM -0600, Pierre-Louis Bossart wrote:
>> On 1/22/20 1:07 PM, Jaroslav Kysela wrote:
> 
>>> The code which checks the return value for snd_soc_add_dai_link() call
>>> in soc_tplg_fe_link_create() moved the snd_soc_add_dai_link() call before
>>> link->dobj members initialization.
> 
>>> While it does not affect the latest kernels, the old soc-core.c code
>>> in the stable kernels is affected. The snd_soc_add_dai_link() function uses
>>> the link->dobj.type member to check, if the link structure is valid.
> 
>>> Reorder the link->dobj initialization to make things work again.
>>> It's harmless for the recent code (and the structure should be properly
>>> initialized before other calls anyway).
> 
>>> The problem is in stable linux-5.4.y since version 5.4.11 when the
>>> upstream commit 76d270364932 was applied.
> 
>> I am not following. Is this a fix for linux-5.4-y only, or is it needed on
>> Mark's tree? In the latter case, what is broken? We've been using Mark's
>> tree without issues, wondering what we missed?
> 
> He's saying it's a fix for stable but it's just a cleanup and robustness
> improvement in current kernels - when the patch 76d270364932 (ASoC:
> topology: Check return value for snd_soc_add_dai_link()) was backported
> by the bot the bot missed some other context which triggered bugs.

Exactly. It's because the commit 237d19080cd37e1ccf5462e63d8577d713f6da46 
("ASoC: soc-core: remove topology specific operation") removed the link->dobj 
checks, but this commit was not picked to the stable kernels.

The initialization reordering is fine for all kernels (and makes sense), so I 
would like to apply it everywhere.

			Thanks,
				Jaroslav

-- 
Jaroslav Kysela <perex@perex.cz>
Linux Sound Maintainer; ALSA Project; Red Hat, Inc.
