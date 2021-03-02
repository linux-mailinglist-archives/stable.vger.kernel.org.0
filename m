Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076BA32B223
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbhCCAw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244061AbhCBRkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 12:40:11 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77813C06178A
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 09:39:10 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id f20so22610313ioo.10
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 09:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f1fS5NpFbu6beXKjjCtL5o94IGkB8gbIgEDDeVSe160=;
        b=jKSeCamb1tJMFb0v1+PCv4F4YShNUZG9qJIWxNEnlJkUpgAtZyugNZqvNVGa1nmr9X
         B7pPwjROdcsb8k3Ie8e7fmAiFLko64dBr6k2et3Zcq6TU0KzYFMkHxfhAkCW7J7Kjtux
         I1ourN6WVpzqF+OaduKSxTCqkrE0JccUZTaPs8v7AJLp1+mVwW6jamTFdH9FD/dgHWBv
         4ROKt0FlgVx9cro++Zpmcmi5FZBFc4ucK0jPKpPj5BsIVSFwtgmAoSuIdKI3OEKI4C03
         Nttmn7QJE07PhfXtlP3qbOlqr0ZbLT44FkmynwtRFILLyj7v3HRl+XbLk0aj33cVDgDX
         SUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f1fS5NpFbu6beXKjjCtL5o94IGkB8gbIgEDDeVSe160=;
        b=CldFE900Bbnio7klGk4zavQ/Clv/pcZeP57YwrSLAOQpKgM49/WblUpNWS06muHmHa
         fOg+7pQ7MS1DJE7G2bWOMFfgYnwH3ITxuyoC6wIn3GqKMiS9ztXeIa75eCzWrQe45tYu
         8n5VI9eggo7BKmppSmqH1I3HJZ9oWAoCmDFW1apjAwWn6ZwtqNMqRQDybXHJniw7VDlP
         zaxJAUb62RuwRZivuNdl9FI618eUZ1id2WhGqrW4trezxqbiZtFT/Hmb3joOjcfBtOAA
         TnsrF5y7rULzs60fydmDX1KpWOHE30FtGm+NMmATOPAEZltmsVh4d6H7YIROYR3zbM9N
         yffA==
X-Gm-Message-State: AOAM531iSOMvoT3Wbo3lRZjxU9y9gG+ybMbCO4NmnEXTdwiX4EGOCQJ/
        lI9DD1D4i06fgeMwkDkEKHA+eCSd2dIsfw==
X-Google-Smtp-Source: ABdhPJwYx646uI12383G6cXSip/WSHz1MeSEL1EHGinB9nkBLqNAFX2x4OtiP3kVoYD4w8LG46nOSQ==
X-Received: by 2002:a05:6638:3809:: with SMTP id i9mr1973536jav.24.1614706749753;
        Tue, 02 Mar 2021 09:39:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w6sm10882380ilm.38.2021.03.02.09.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 09:39:09 -0800 (PST)
Subject: Re: [PATCH 4.19 21/57] proc: dont allow async path resolution of
 /proc/self components
To:     Yang Yingliang <yangyingliang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        yangerkun <yangerkun@huawei.com>,
        Cheng Jian <cj.chengjian@huawei.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084650.205087954@linuxfoundation.org>
 <cced67ae-ceca-3812-121c-70e0ed104f49@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <395dd137-70d5-e915-92b5-b2a18f44badc@kernel.dk>
Date:   Tue, 2 Mar 2021 10:39:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cced67ae-ceca-3812-121c-70e0ed104f49@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/21 1:40 AM, Yang Yingliang wrote:
> Hi,
> 
> On 2020/12/1 16:53, Greg Kroah-Hartman wrote:
>> From: Jens Axboe <axboe@kernel.dk>
>>
>> [ Upstream commit 8d4c3e76e3be11a64df95ddee52e99092d42fc19 ]
>>
>> If this is attempted by a kthread, then return -EOPNOTSUPP as we don't
>> currently support that. Once we can get task_pid_ptr() doing the right
>> thing, then this can go away again.
> 
> https://www.spinics.net/lists/io-uring/msg05297.html
> 
> This patch seems used for io-wq worker which is merged in
> 
> v5.5-rc1, why we need this in linux-4.19.y ?

While that's true, it's also a sane safeguard in general.

-- 
Jens Axboe

