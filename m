Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD1841291D
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 00:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhITW6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 18:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbhITW4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 18:56:36 -0400
X-Greylist: delayed 3466 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Sep 2021 10:40:03 PDT
Received: from ns4.inleed.net (mailout4.inleed.net [IPv6:2a0b:dc80:cafe:104::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A89C0E48DA
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 10:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=diwic.se;
        s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yEv9NWBu3uZpQsNDkbdOJOgm0v68XHpSZXS3lb+TOUs=; b=R54V3ckeJXd61eLuED5tqhSloZ
        yYSqr1i1x+37xVvJw459/m2nDfZtzwJXyf/B8v6HTnBXaRr41H9SbV69W9YUpNm8t3l/tWRGBDrB5
        yZlAHfMuTWlqunJXhPeYKciThNuan7hGyU5jVg5792B/2ZWPTigN6MNM3uL6gkbQl06urwkzNey+j
        rMf3Tcreb3RAHbiepLGkKB1HlNHxFgQxuEM3zPWXZgCRoz3ZtMhxvu/wmWJYrhnXuuPI1TfFM4L/g
        9QAX0wrqxQ4A6tf91bA/tYyn25Bzt+008nFIpQ7GQI6rcOuvDrKT3wHtrqjbOcMAfkDWZvaE0tAFd
        WsY4FEjQ==;
Received: from c83-254-143-147.bredband.tele2.se ([83.254.143.147] helo=[192.168.5.6])
        by ns4.inleed.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <coding@diwic.se>)
        id 1mSMND-00DanS-QZ; Mon, 20 Sep 2021 18:42:31 +0200
Subject: Re: [PATCH] ALSA: rawmidi: introduce
 SNDRV_RAWMIDI_IOCTL_USER_PVERSION
To:     Jaroslav Kysela <perex@perex.cz>,
        ALSA development <alsa-devel@alsa-project.org>
Cc:     Takashi Iwai <tiwai@suse.de>, stable@vger.kernel.org
References: <20210920083538.128008-1-perex@perex.cz>
From:   David Henningsson <coding@diwic.se>
Message-ID: <5f2b66ef-01f2-f371-e8af-afa236f10cc5@diwic.se>
Date:   Mon, 20 Sep 2021 18:42:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920083538.128008-1-perex@perex.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Authenticated-Id: coding@diwic.se
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021-09-20 10:35, Jaroslav Kysela wrote:
> The new framing mode causes the user space regression, because
> the alsa-lib code does not initialize the reserved space in
> the params structure when the device is opened.
>
> This change adds SNDRV_RAWMIDI_IOCTL_USER_PVERSION like we
> do for the PCM interface for the protocol acknowledgment.
>
> Cc: David Henningsson <coding@diwic.se>
> Cc: <stable@vger.kernel.org>
> Fixes: 08fdced60ca0 ("ALSA: rawmidi: Add framing mode")
> BugLink: https://github.com/alsa-project/alsa-lib/issues/178
> Signed-off-by: Jaroslav Kysela <perex@perex.cz>
> ---
>   include/sound/rawmidi.h     | 1 +
>   include/uapi/sound/asound.h | 1 +
>   sound/core/rawmidi.c        | 9 +++++++++
>   3 files changed, 11 insertions(+)
>
> diff --git a/include/sound/rawmidi.h b/include/sound/rawmidi.h
> index 989e1517332d..7a08ed2acd60 100644
> --- a/include/sound/rawmidi.h
> +++ b/include/sound/rawmidi.h
> @@ -98,6 +98,7 @@ struct snd_rawmidi_file {
>   	struct snd_rawmidi *rmidi;
>   	struct snd_rawmidi_substream *input;
>   	struct snd_rawmidi_substream *output;
> +	unsigned int user_pversion;	/* supported protocol version */
>   };
>   
>   struct snd_rawmidi_str {
> diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
> index 1d84ec9db93b..f906e50a7919 100644
> --- a/include/uapi/sound/asound.h
> +++ b/include/uapi/sound/asound.h
> @@ -784,6 +784,7 @@ struct snd_rawmidi_status {
>   
>   #define SNDRV_RAWMIDI_IOCTL_PVERSION	_IOR('W', 0x00, int)
>   #define SNDRV_RAWMIDI_IOCTL_INFO	_IOR('W', 0x01, struct snd_rawmidi_info)
> +#define SNDRV_RAWMIDI_IOCTL_USER_PVERSION _IOW('A', 0x02, int)

How come it's not 'W' here but 'A' instead?

Looks good otherwise, given a quick glance. It'll need a corresponding 
alsa-lib patch to actually call SNDRV_RAWMIDI_IOCTL_USER_PVERSION.

Thanks for helping to sort this out.

// David

