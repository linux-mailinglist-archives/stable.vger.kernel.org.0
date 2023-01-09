Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37481662949
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 16:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjAIPEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 10:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbjAIPEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 10:04:35 -0500
Received: from mail1.perex.cz (mail1.perex.cz [77.48.224.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B141E1D0E9
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 07:04:34 -0800 (PST)
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id C0A0EA0042;
        Mon,  9 Jan 2023 16:04:32 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz C0A0EA0042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1673276672; bh=yM+03FSHnu9RNBHhrGm0JoZhagoJhPvzZUzRzaEddh4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qbD1ZBfLOLOiEnpFF8zUlHyoe3jZBctEV2XWgaQcMxaLhoDGqA38dVpjF981wT6qF
         sMd7lU7APhX2qsSV1p5vEO+ctMaN3DQXycKWzRS7tY1jKpuczWOEzZSjqD+d2tjTvc
         uGa9rbVPluwcvVBauwp7DGxdzQO3cT4xkkJwYy2M=
Received: from [192.168.100.98] (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Mon,  9 Jan 2023 16:04:28 +0100 (CET)
Message-ID: <b5cf8bd4-4659-42f3-2f36-d94c1d587068@perex.cz>
Date:   Mon, 9 Jan 2023 16:04:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ALSA: control-led: use strscpy in set_led_id()
Content-Language: en-US
To:     ALSA development <alsa-devel@alsa-project.org>
Cc:     Takashi Iwai <tiwai@suse.de>, yang.yang29@zte.com.cn,
        stable@vger.kernel.org
References: <20230109134724.332868-1-perex@perex.cz>
From:   Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <20230109134724.332868-1-perex@perex.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09. 01. 23 14:47, Jaroslav Kysela wrote:
> The use of strncpy() in the set_led_id() was incorrect.
> The len variable should use 'min(sizeof(buf2) - 1, count)'
> expression.
> 
> Use strscpy() function to simplify things and handle the error gracefully.
> 
> Reported-by: yang.yang29@zte.com.cn
> BugLink: https://lore.kernel.org/alsa-devel/202301091945513559977@zte.com.cn/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jaroslav Kysela <perex@perex.cz>
> ---
>   sound/core/control_led.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/core/control_led.c b/sound/core/control_led.c
> index f975cc85772b..45c8eb5700c1 100644
> --- a/sound/core/control_led.c
> +++ b/sound/core/control_led.c
> @@ -530,12 +530,11 @@ static ssize_t set_led_id(struct snd_ctl_led_card *led_card, const char *buf, si
>   			  bool attach)
>   {
>   	char buf2[256], *s, *os;
> -	size_t len = max(sizeof(s) - 1, count);
>   	struct snd_ctl_elem_id id;
>   	int err;
>   
> -	strncpy(buf2, buf, len);
> -	buf2[len] = '\0';
> +	if (strscpy(buf2, buf, min(sizeof(buf2), count)) < 0)

Please, don't use this version of path (see v2). This min() expression will 
strip the last char and buf is '\0' terminated.

v2: https://lore.kernel.org/alsa-devel/20230109150119.342771-1-perex@perex.cz/

				Jaroslav

-- 
Jaroslav Kysela <perex@perex.cz>
Linux Sound Maintainer; ALSA Project; Red Hat, Inc.
