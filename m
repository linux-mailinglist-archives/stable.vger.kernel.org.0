Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A02362A8A
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 23:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244978AbhDPVpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 17:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344513AbhDPVpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 17:45:46 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4166C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:45:17 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id p15so13383965iln.3
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ysh8yoPWThx5oSHO0cCLWLjvIovEYJTQX+zjYeCIAIE=;
        b=K4kQVT7tJptJamJzzIjmfWk0oRyWzAtxagp3jrY7sDaHWAn/rJE9G/m8FU3APvOun7
         eqmNiaijX234JQ483t5+rSQdY1g1hCYeyrXRIgf8oPlIx/gou0GgOIk4Mj7ib7duVFn0
         K2nKCUjnCLywDH407ponV0v7tvMdhZE/dwYyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ysh8yoPWThx5oSHO0cCLWLjvIovEYJTQX+zjYeCIAIE=;
        b=g9fhq8zsl+N+KjSU4sHiidociW7W7vKcHfvfGGVYPAqGGYgXu2kYhfd55Z9i1hBBgP
         07oac16EgHjrNL3777k15g50d8qCXTdRfBTCBrbhKs7RAyNi6W+2cx2fK+dHr7DWnvXB
         +Icj9N/bULYPYvj9bNDftG00KBnEcwqtyIbzpJnS2bK6x1d5ilpYhwDnohndfVsC1NAk
         7WrzdqUap6LaUGWeD0ls+8dvJRn8Fhf41q2yZhPjGopfwYhGmSTcC0YulVgkp4SS2Jkl
         xs6LPMXpB8/jQwsCP9pSkDW4SHlx08Pd/pmtOhfvbqrGYapDaB/r4ld9pExqXgtJT4Gk
         uwcg==
X-Gm-Message-State: AOAM530sQD6O+wKaUKBIA8/sRO49O/a9mRhFVb2B33EryDbRD37Q2K10
        IA+7ihbiu/fgpbp2xeuebONPKaizGYptuA==
X-Google-Smtp-Source: ABdhPJy6cgFQg75GELKw5Oyf8+LtTsrDb2rkE1EW6+iRlYLFaganX4eLbLYYaLdG/DDR2pGcHh/RJA==
X-Received: by 2002:a92:dcc8:: with SMTP id b8mr8500883ilr.286.1618609517305;
        Fri, 16 Apr 2021 14:45:17 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m8sm3333477ilc.13.2021.04.16.14.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 14:45:17 -0700 (PDT)
Subject: Re: [PATCH 3/4] usbip: vudc synchronize sysfs code paths
To:     Tom Seewald <tseewald@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
References: <20210416205319.14075-1-tseewald@gmail.com>
 <20210416205319.14075-3-tseewald@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d2cc4517-4790-b3a7-eec0-16fe06ea22eb@linuxfoundation.org>
Date:   Fri, 16 Apr 2021 15:45:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210416205319.14075-3-tseewald@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/21 2:53 PM, Tom Seewald wrote:
> From: Shuah Khan <skhan@linuxfoundation.org>
> 
> commit bd8b82042269a95db48074b8bb400678dbac1815 upstream.
> 
> Fuzzing uncovered race condition between sysfs code paths in usbip
> drivers. Device connect/disconnect code paths initiated through
> sysfs interface are prone to races if disconnect happens during
> connect and vice versa.
> 
> Use sysfs_lock to protect sysfs paths in vudc.
> 
> Cc: stable@vger.kernel.org # 4.9.x # 4.14.x
> Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Link: https://lore.kernel.org/r/caabcf3fc87bdae970509b5ff32d05bb7ce2fb15.1616807117.git.skhan@linuxfoundation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Tom Seewald <tseewald@gmail.com>


Thank you for the backport.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

Greg, please pick this up for 4.9.x and 4.14.x

thanks,
-- Shuah
