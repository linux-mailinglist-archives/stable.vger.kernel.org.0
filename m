Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED7D37208D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 21:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhECThL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 15:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhECThK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 15:37:10 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC68C06174A;
        Mon,  3 May 2021 12:36:16 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id o16so8265969ljp.3;
        Mon, 03 May 2021 12:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/15ZZgVs4HWwrQnoXkLDtTe4rR3G5xM3bzUg9TCb5gA=;
        b=mhwZUQ+Wna2bTzVcsyO/hJn7zgi/eLCeH+k76NUpMWmcIUA0AeuMrubne0kmeVoBAP
         x0sqhLptrE4+IzSI06xEanCrLQTTqczVfQlS7Q9xolDG2pmQPfd5z6fv6Jya5PkkspRh
         6z/uSvyVUSPj7D+aY/+fKKXtAA020AeeowfW563Ug2mx6/86YL3z4eEvyKBT9MDw3Q+B
         hV8kOzDUzE5j+U/9ehHMGl950IiBSrLrafBE5bl/N5NQSRaulUFmjW3uP6YtK939m1xD
         UXXkk2fwH/gKS1QG7o4oJhycMOgAQoQO9++RGjCDrZmqUYg39rkSL9c73qPhZxtIhN69
         Ayhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/15ZZgVs4HWwrQnoXkLDtTe4rR3G5xM3bzUg9TCb5gA=;
        b=Fq7a3MF8X1ZS/PluFVbKozV/CahwTybIMgkvPQslJE/OfnzEW5VtXWpm5hP8hrlXVZ
         e6CRW/ddBe8DXjppZbPVt7B/+0PcAeJDq2Gs8EXedK/nleOVPt8DMfvt55or9N04U4WL
         PBV3yjo440yYPxiRiZtD0wmoXsJAcQDPqcGMzBHwqBtXUnwpRuxS0iK8O6K/3Wdwcwse
         RGrNEjWdnC9O5pJxEvlGSB67FTRDjaUxl5N24cQGy2F+r5uogkZjada99N+0VSwFtuFp
         5ZQkWSwskpiMbkHherRz3gBZ09tKNcAshmypxsysCcxGCSMH+2KmSTGYeB9AJHJv/C/r
         6tlg==
X-Gm-Message-State: AOAM532UYb9XRyWY5tHQfebEdtBVcN1BE7JV8tgAWdBUjnbmx+6U5vbM
        QKBqFM/4qdPGNbkh20XP7P0=
X-Google-Smtp-Source: ABdhPJzw1/XziLbg3TWRGUzEJJVGmqP7rmnq2JuXtgbEJAC/YSMWJ0prNTEqoTdphM31RidqYbhexw==
X-Received: by 2002:a2e:97c3:: with SMTP id m3mr1029889ljj.231.1620070575377;
        Mon, 03 May 2021 12:36:15 -0700 (PDT)
Received: from [192.168.0.131] ([194.183.54.57])
        by smtp.gmail.com with ESMTPSA id q27sm402397ljm.127.2021.05.03.12.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 12:36:14 -0700 (PDT)
Subject: Re: [PATCH 09/69] leds: lp5523: check return value of lp5xx_read and
 jump to cleanup code
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        stable <stable@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-10-gregkh@linuxfoundation.org>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <f821d2a3-3801-66a6-3c5b-0e00a8289ec1@gmail.com>
Date:   Mon, 3 May 2021 21:36:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210503115736.2104747-10-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/3/21 1:56 PM, Greg Kroah-Hartman wrote:
> From: Phillip Potter <phil@philpotter.co.uk>
> 
> Check return value of lp5xx_read and if non-zero, jump to code at end of
> the function, causing lp5523_stop_all_engines to be executed before
> returning the error value up the call chain. This fixes the original
> commit (248b57015f35) which was reverted due to the University of Minnesota
> problems.
> 
> Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/leds/leds-lp5523.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 5036d7d5f3d4..b1590cb4a188 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -305,7 +305,9 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
>   
>   	/* Let the programs run for couple of ms and check the engine status */
>   	usleep_range(3000, 6000);
> -	lp55xx_read(chip, LP5523_REG_STATUS, &status);
> +	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
> +	if (ret)
> +		goto out;
>   	status &= LP5523_ENG_STATUS_MASK;
>   
>   	if (status != LP5523_ENG_STATUS_MASK) {
> 

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

Cc: Pavel Machek <pavel@ucw.cz>, linux-leds@vger.kernel.org

-- 
Best regards,
Jacek Anaszewski
