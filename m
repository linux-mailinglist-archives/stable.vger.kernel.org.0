Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E5E369BA7
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 22:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhDWU5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 16:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbhDWU5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 16:57:05 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8FAC06174A
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 13:56:28 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p8so1702480iol.11
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 13:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JwpEMfsFJcI5faK7sa42v6n59XW+1jdGvUyeeBhOqjo=;
        b=DRV0si9bOzUTGGgpFw81OQNtdjhTfuUuEd36od41RbPd0935mr0YEfMgMVBeBXwrgh
         Vr0p82y6/uujl53uFleN8IzDiDtQDnhNdTEET3ubWalfMmFxNQA/htqAllppkgTm2v1i
         1QSZj65QwbqgtwdqPu6RzY98fiEpTxH3VMbdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JwpEMfsFJcI5faK7sa42v6n59XW+1jdGvUyeeBhOqjo=;
        b=jcYo/2EHQB/OFnrg/9u0NlHBrTCTmBfiEbzK3JDuzIiGz9p8waBpWNx+hbijHyZL+z
         BuGtuXOuljBZ18zW5C4O85gHH3IB1Y8AURc7LPTxK/XV1nG9uY5/FxOCjyoa8vPNq+vo
         a1s0tts9xu2sm+fFIEzJIv7q4f+ZmtL4J3Bg0nDIk0AJDZ1v428c3ET+mZdJrJqJdxSc
         JIUxnflmsoBLtt3NkhwoT4jhX4pHmedcZ3ebBGVFfJy3wKo3XiunlnSYdAWdOWbZZWSW
         xAYYbnGjkzcjfBCzDMnqY3njrxJ17HYPGaOhd+QRR1lpv58YBM/zMMH+S8kW6OAy+0RT
         K8CQ==
X-Gm-Message-State: AOAM533k/Xv/f9ieNvQ70G10nB8mhcvC/HU6NV1KXDRRya8uGQqGM7zK
        tQi837eiRPdb+h0tdDC8JAxpxcoHwAJbzg==
X-Google-Smtp-Source: ABdhPJwPFhOZfkLgpA2WhkYn60vEUYJlEOndpDA/3CaVxIsGBexe2up5WTxKUVSDSOyP3qIRUYCKIA==
X-Received: by 2002:a02:a69a:: with SMTP id j26mr5343989jam.5.1619211387969;
        Fri, 23 Apr 2021 13:56:27 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m8sm3056064ilc.13.2021.04.23.13.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 13:56:27 -0700 (PDT)
Subject: Re: [PATCH] media: gspca: stv06xx: Fix memleak in stv06xx subdrivers
To:     Pavel Skripkin <paskripkin@gmail.com>, hverkuil-cisco@xs4all.nl
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        mchehab@kernel.org, linux-kernel-mentees@lists.linuxfoundation.org,
        linux-media@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210422160742.7166-1-atulgopinathan@gmail.com>
 <20210422215511.01489adb@gmail.com>
 <36f126fc-6a5e-a078-4cf0-c73d6795a111@linuxfoundation.org>
 <20210423234458.3f754de2@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4c22cfa5-5702-6181-0f9a-d1d8d4041156@linuxfoundation.org>
Date:   Fri, 23 Apr 2021 14:56:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210423234458.3f754de2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/23/21 2:44 PM, Pavel Skripkin wrote:
> Hi!
> 
> On Fri, 23 Apr 2021 14:19:15 -0600
> Shuah Khan <skhan@linuxfoundation.org> wrote:
>> On 4/22/21 12:55 PM, Pavel Skripkin wrote:
>>> Hi!
>>>
>>> On Thu, 22 Apr 2021 21:37:42 +0530
>>> Atul Gopinathan <atulgopinathan@gmail.com> wrote:
>>>> During probing phase of a gspca driver in "gspca_dev_probe2()", the
>>>> stv06xx subdrivers have certain sensor variants (namely, hdcs_1x00,
>>>> hdcs_1020 and pb_0100) that allocate memory for their respective
>>>> sensor which is passed to the "sd->sensor_priv" field. During the
>>>> same probe routine, after "sensor_priv" allocation, there are
>>>> chances of later functions invoked to fail which result in the
>>>> probing routine to end immediately via "goto out" path. While
>>>> doing so, the memory allocated earlier for the sensor isn't taken
>>>> care of resulting in memory leak.
>>>>
>>>> Fix this by adding operations to the gspca, stv06xx and down to the
>>>> sensor levels to free this allocated memory during gspca probe
>>>> failure.
>>>>
>>>> -
>>>> The current level of hierarchy looks something like this:
>>>>
>>>> 	gspca (main driver) represented by struct gspca_dev
>>>> 	   |
>>>> ___________|_____________________________________
>>>> |	|	|	|	|		| (subdrivers)
>>>> 			|			  represented
>>>>    			stv06xx			  by
>>>> "struct sd" |
>>>>    	 _______________|_______________
>>>>    	 |	|	|	|	|  (sensors)
>>>> 	 	|			|
>>>>    		hdcs_1x00/1020		pb01000
>>>> 			|_________________|
>>>> 				|
>>>> 			These three sensor variants
>>>> 			allocate memory for
>>>> 			"sd->sensor_priv" field.
>>>>
>>>> Here, "struct gspca_dev" is the representation used in the top
>>>> level. In the sub-driver levels, "gspca_dev" pointer is cast to
>>>> "struct sd*", something like this:
>>>>
>>>> 	struct sd *sd = (struct sd *)gspca_dev;
>>>>
>>>> This is possible because the first field of "struct sd" is
>>>> "gspca_dev":
>>>>
>>>> 	struct sd {
>>>> 		struct gspca_dev;
>>>> 		.
>>>> 		.
>>>> 	}
>>>>
>>>> Therefore, to deallocate the "sd->sensor_priv" fields from
>>>> "gspca_dev_probe2()" which is at the top level, the patch creates
>>>> operations for the subdrivers and sensors to be invoked from the
>>>> gspca driver levels. These operations essentially free the
>>>> "sd->sensor_priv" which were allocated by the "config" and
>>>> "init_controls" operations in the case of stv06xx sub-drivers and
>>>> the sensor levels.
>>>>
>>>> This patch doesn't affect other sub-drivers or even sensors who
>>>> never allocate memory to "sensor_priv". It has also been tested by
>>>> syzbot and it returned an "OK" result.
>>>>
>>>> https://syzkaller.appspot.com/bug?id=ab69427f2911374e5f0b347d0d7795bfe384016c
>>>> -
>>>>
>>>> Fixes: 4c98834addfe ("V4L/DVB (10048): gspca - stv06xx: New
>>>> subdriver.") Cc: stable@vger.kernel.org
>>>> Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
>>>> Reported-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
>>>> Tested-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
>>>> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
>>>
>>> AFAIK, something similar is already applied to linux-media tree
>>> https://git.linuxtv.org/media_tree.git/commit/?id=4f4e6644cd876c844cdb3bea2dd7051787d5ae25
>>>
>>
>> Pavel,
>>
>> Does the above handle the other drivers hdcs_1x00/1020 and pb01000?
>>
>> Atul's patch handles those cases. If thoese code paths need to be
>> fixes, Atul could do a patch on top of yours perhaps?
>>
>> thanks,
>> -- Shuah
>>
>>
> 
> It's not my patch. I've sent a patch sometime ago, but it was reject
> by Mauro (we had a small discussion on linux-media mailing-list), then
> Hans wrote the patch based on my leak discoverage.
> 

Yes my bad. :)

> I added Hans to CC, maybe, he will help :)
> 

Will wait for Hans to take a look.

thanks,
-- Shuah
